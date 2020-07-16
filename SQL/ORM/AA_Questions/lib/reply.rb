require_relative 'intermediary'

require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'user'
require_relative 'reply_like'

require_relative 'model_base'

require 'byebug'

class Reply

    attr_accessor :id, :question_id, :parent_id, :body, :author_id

    def self.all
        # returns an array of Reply objects
        # representing every reply in the db
        data = QuestionsDB.instance.execute(<<-SQL)
            select *
            from replies;
        SQL
        data.map {|datum| Reply.new(datum)}
    end

    def self.find_by_id(num)
        # given a number representing a reply_id
        # returns a single Reply object representing
        # the reply whose id matches the given num
        # OR nil if no such reply exists
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from replies
            where id = ?;
        SQL
        data.empty? ? nil : Reply.new(data.first)
    end

    def self.find_by_question_id(num)
        # given a number representing a question id,
        # returns an array of Reply objects representing
        # all replies to said question in the db
        raise "no replies to non-existent question" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from replies
            where question_id = ?;
        SQL
        Reply.render_replies(data)
    end

    def self.find_by_parent_id(num)
        # given a number representing a reply_id,
        # returns an array of Reply objs whose parent_id matches the given num
        raise "no replies with given id in db" unless Reply.has_reply_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from replies
            where parent_id = ?;
        SQL
        Reply.render_replies(data)
    end

    def self.find_by_body(str)
        # given a string,
        # returns an array of Reply objects representing
        # all replies whose body contains the given string
        data = QuestionsDB.instance.execute(<<-SQL, str)
            select *
            from replies
            where body like '%str%';
        SQL
        Reply.render_replies(data)
    end

    def self.find_by_author_id(num)
        # given a number representing a user_id,
        # returns an array of question objects representing
        # all questions authored by the user with the given ID
        raise "no user with that id" unless User.has_reply_with_id(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from replies
            where author_id = ?;
        SQL
        Reply.render_replies(data)
    end

    def self.render_replies(data)
       data.map {|datum| Reply.new(datum)}
       # this will be expanded to format for children, threads, etc 
    end

    def has_reply_with_id?(num)
        # given a number representing an id for a Reply,
        # returns true if the db has a reply with said number
        # else, false
        all_ids = QuestionsDB.instance.execute(<<-SQL)
            select id
            from replies;
        SQL

        all_ids.any? {|datum| datum["id"] == num}
    end
    
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_id = options['parent_id']
        @body = options['body']
        @author_id = options['author_id']
    end

    def create
        # adds the reply to the db
        raise "reply already exists" if self.id

        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.parent_id, self.body, self.author_id)
                insert into replies (question_id, parent_id, body, author_id)
                values (?, ?, ?, ?);
            SQL

            self.id = QuestionsDB.instance.last_insert_row_id

            return self.id
        rescue => exception
            raise "failed to create reply: #{exception}"
        end
    end

    def update
        # updates the reply (think: edit reply)
        raise "reply does not exist" unless self.id

        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.parent_id, self.body, self.author_id, self.id)
                update replies
                set question_id = ?,
                    parent_id = ?,
                    body = ?,
                    author_id = ?
                where id = ?;
            SQL

            return true
        rescue => exception
            raise "failed to update reply: #{exception}"
        end
    end

    def author
        # returns a User object
        # representing the author of this question
        data = QuestionsDB.instance.execute(<<-SQL, self.author_id)
            select U.*
            from replies R
            join users U on R.author_id = U.id
            where U.id = ?;
        SQL

        User.new(data.first)
    end

    def question
        # returns a Question object representing
        # the question to which this reply is replying
        data = QuestionsDB.instance.execute(<<-SQL, self.question_id, self.id)
            select Q.*
            from replies R
            join questions Q on R.question_id = Q.id
            where Q.id = ? and R.id = ?;
        SQL

        Question.new(data.first)
    end

    def parent_reply
        # returns a Reply object representing
        # this reply's parent
        data = QuestionsDB.instance.execute(<<-SQL, self.parent_id)
            select Parents.*
            from replies Children
            join replies Parents on Children.parent_id = Parents.id
            where Parents.id = ?;
        SQL

        data.empty? ? nil : Reply.new(data.first)
    end

    def children
        # returns an array of Reply objects representing
        # all direct descendents of this reply
        # (no children of children)
        data = QuestionsDB.instance.execute(<<-SQL, self.id)
            select Children.*
            from replies Parents
            join replies Children on Parents.id = Children.parent_id
            where Children.parent_id = ?;
        SQL

        data.map {|datum| Reply.new(datum)}
    end

    def remove
        raise "reply not in db" unless self.id

        begin
            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- remove any likes of this reply from the DB
                delete from reply_likes
                where reply_id = ?;
            SQL

            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- remove this reply from the DB
                delete from replies
                where id = ?;
            SQL

            # remove all children
            children.each

            puts "successfully deleted reply, id = #{self.id}"
        rescue
            raise "deletion unsuccessful"
        end
    end

    def all_children
        # helps in formatting replies?
    end
    
end