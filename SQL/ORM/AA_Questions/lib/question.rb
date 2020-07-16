require_relative 'intermediary'

require_relative 'user'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'reply_like'

require_relative 'model_base'

require 'byebug'

class Question
    
    attr_accessor :id, :title, :body, :author_id

    def self.all
        # returns an array of Question objects
        # representing all questions in db
        ModelBase.all("questions", Question)
    end

    def self.find_by_id(num)
        # returns a Question object representing the question in the db
        # whose id matches the given num
        # or nil
        arr = ModelBase.find_by_matcher("questions",
                                        ['id'],
                                        [{
                                            :match_type => '=',
                                            :val => num
                                        }],
                                        Question)
        arr.empty? ? nil : arr.first
    end

    def self.find_by_title(str)
        # returns an array of Question objects
        # whose title matches the given string
        ModelBase.find_by_matcher("questions",
                                        ['title'],
                                        [{
                                            :match_type => 'like',
                                            :val => str
                                        }],
                                        Question)
    end

    def self.find_by_body(str)
        # returns an array of question objects
        # whose body contains the given string
        ModelBase.find_by_matcher("questions",
                                        ['body'],
                                        [{
                                            :match_type => 'like',
                                            :val => str
                                        }],
                                        Question)
    end

    def self.find_by_author_id(num)
        # returns an array of Question objects
        # whose author_id's match the given number
        ModelBase.find_by_matcher("questions",
                                        ['author_id'],
                                        [{
                                            :match_type => '=',
                                            :val => num
                                        }],
                                        Question)
    end

    def self.most_followed
        # returns an array Question object(s) 
        # representing the most followed question(s)
        # or nil if no follows or no questions
        all = QuestionFollow.most_followed_questions
        if all.nil?
            nil
        else
            top_count = all.first[1]
            all.filter {|q| q[1] == top_count}
        end
    end

    def most_liked
        # returns Question object(s) representing the most liked question(s)
        # or nil if no likes or no questions
        all = QuestionLike.most_liked_questions
        if all.nil?
            nil
        else
            all.first[1] = top_count
            all.filter {|q| q[1] == top_count}
        end
    end

    def self.has_question_with_id?(num)
        # returns true if questions table has given num
        # else false
        all_ids = QuestionsDB.instance.execute(<<-SQL)
            select id
            from questions;
        SQL

        all_ids.any? {|datum| datum["id"] == num}
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def create
        # add question to db
        raise "already asked" if self.id
        raise "title already exists" unless Question.find_by_title(self.title).empty?
        
        begin
            QuestionsDB.instance.execute(<<-SQL, self.title, self.body, self.author_id)
                insert into questions (title, body, author_id)
                values (?, ?, ?);
            SQL
            self.id = QuestionsDB.instance.last_insert_row_id

            return self.id
        rescue => exception
            raise "failed to create question: #{exception}"
        end
    end

    def update
        # update question info
        raise "question not in db" unless self.id

        begin
            QuestionsDB.instance.execute(<<-SQL, self.title, self.body, self.id)
                update questions
                set title = ?, body = ?
                where id = ?;
            SQL

            return true
        rescue => e
            raise "failed to update question: #{e}"
        end
    end

    def get_follows
        # returns an array of User objects
        # representing all users who have followed this question
        QuestionFollow.question_follows_full(self.id)
    end

    def get_likes
        # returns an array of Users
        # representing all users who have liked this question
        QuestionLike.question_likers_full(self.id)
    end

    def num_likes
        # returns the number of likes
        QuestionLike.num_likes_for_question_id(self.id)
    end

    def get_replies
        # returns an array of Reply objects
        # representing all replies (and their descendents) to this question
        Reply.find_by_question_id(self.id)
    end

    def get_first_replies
        # returns an array of Reply objects
        # representing all first replies to this question (i.e. no parent)
        data = QuestionsDB.instance.execute(<<-SQL, self.id)
            select *
            from replies
            where question_id = ? and parent_id is null;
        SQL
        data.map {|datum| Reply.new(datum)}
    end

    def author
        # returns the User who authored the question
        data = QuestionsDB.instance.execute(<<-SQL, author_id)
            select U.*
            from questions Q
            join users U on Q.author_id = U.id
            where U.id = ?;
        SQL
        User.new(data.first)
    end

    def remove
        # removes the question from the db
        # and removes all followers, likes, and replies,
        # along with their likes and replies, etc.
        raise "question does not exist" unless self.id
        begin
            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete this question from the db
                delete from questions
                where id = ?;
            SQL

            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete followers
                delete from question_follows
                where question_id = ?;
            SQL

            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete question likes
                delete from question_likes
                where question_id = ?;
            SQL

            # get first reply
            get_first_replies.each {|reply| reply.remove}

            puts "successfully deleted question, id = #{self.id}"
        rescue => e
            puts "question deletion failed: #{e}"
        end

    end
    
end