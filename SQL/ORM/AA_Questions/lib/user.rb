require_relative 'intermediary'

require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'reply_like'

require_relative 'model_base'

require 'byebug'

class User
    attr_accessor :id, :fname, :lname

    def self.all
        # returns an array of User objects
        # representing every user in the db
        ModelBase.all("users", self)
    end

    def self.find_by_id(num)
        # returns a single user object
        # representing the user whose id matches the given num
        # OR nil if no match is found
        arr = ModelBase.find_by_matchers("users",
                                        ["id"],
                                        [{
                                            :match_type => '=', 
                                            :val => num
                                        }],
                                        self)
        arr.empty? ? nil : arr.first
    end

    def self.find_by_fname(str)
        # returns an array of User objects
        # with matching first names
        ModelBase.find_by_matchers("users",
                                    ["fname"],
                                    [{
                                        :match_type => '=',
                                        :val => str
                                    }],
                                    self)
    end

    def self.find_by_lname(str)
        # returns an array of User objects
        # with matching last names
        ModelBase.find_by_matchers("users",
                                    ["lname"],
                                    [{
                                        :match_type => '=',
                                        :val => str
                                    }],
                                    self)
    end

    def self.find_by_full_name(first, last)
        # returns an array of User objects
        # with matching full names
        ModelBase.find_by_matchers("users",
                                    ["fname", "lname"],
                                    [{
                                        :match_type => '=',
                                        :val => first
                                    }, {
                                        :match_type => '='
                                        :val => last
                                    }],
                                    self)
    end

    def self.has_user_with_id?(num)
        # returns true if users table has given id,
        # else false
        ! self.find_by_id(num).nil?
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def save
        self.id = ModelBase.save(self)
    end

    def authored_questions
        # returns an array of question objects representing
        # questions that this user has authored
        Question.find_by_author_id(self.id)
    end

    def liked_questions
        # returns an array of question objects
        # representing all questions that the user has liked
        QuestionLike.likers_questions_full(self.id)
    end

    def followed_questions
        # returns an array of Question objects
        # representing all questions that the user has followed
        QuestionFollow.followers_questions_full(self.id)
    end

    def authored_replies
        # returns an array of Reply objects
        # representing all replies that the user authored
        Reply.find_by_author_id(self.id)
    end

    def liked_replies
        # returns an array of Reply objects
        # representing all replies the user liked
        ReplyLike.find_by_liker_id(self.id)
    end

    def average_karma
        # returns the average number of likes for a user's questions
        data = QuestionsDB.instance.execute(<<-SQL, self.id)
            select cast(A.total_likes as float) / A.num_authored_questions as avg
            from
                (select count(QL.question_id) as total_likes, count(distinct(Q.id)) as num_authored_questions
                from questions Q
                left join question_likes QL on Q.id = QL.question_id
                where Q.author_id = ?) A
        SQL
        data.empty? ? nil : data.first["avg"]
    end

    def ask_question(title, body)
        # adds a question with the given title and body to the database
        # returns the id of the question upon success
        begin
            Question.new('title' => title, 'body' => body, 'author_id' => self.id).create
            QuestionsDB.instance.last_insert_row_id
        rescue => e
            raise "ask_question failed: #{e}"
        end
    end

    def update_question(title, body)
        # updates question in the db
        # returns true upon success
        this = Question.find_by_title(title)
        
        raise "not yours to update" if this.author_id != self.id

        begin
            QuestionsDB.instance.execute(<<-SQL, title, body, this.id)
                update questions
                set title = ?, body = ?
                where id = ?;
            SQL
            true
        rescue => e
            raise "update_question failed: #{e}"
        end
    end

    def remove
        # removes a user from the db
        # along with their questions, replies, follows, and likes, etc.
        raise "user does not exist" unless self.id
        begin
            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete reply_likes
                delete from reply_likes
                where liker_id = ?;
            SQL

            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete question_likes
                delete from question_likes
                where liker_id = ?;
            SQL

            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete follows
                delete from question_follows
                where follower_id = ?;
            SQL
            
            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete questions
                delete from questions
                where author_id = ?;
            SQL
            
            QuestionsDB.instance.execute(<<-SQL, self.id)
                -- delete self from users
                delete from users
                where id = ?;
            SQL

            while true
                a_reply = QuestionsDB.instance.execute(<<-SQL, self.id)
                    select *
                    from replies
                    where author_id = ?
                    limit 1;
                SQL

                break if a_reply.empty?

                Reply.new(a_reply.first).remove
            end

            true
        rescue => e
            raise "user deletion failed: #{e}"
        end
    end

    ## this stuff is more like user object interaction w db
    ## which I guess mimics how a user would click on things?

    def follow_question(question_id)
        # adds an entry to question_follows for this user with given question
        # returns true upon success
        begin
            QuestionFollow.new(question_id, self.id).create
            true
        rescue => exception
            raise "follow_question failed: #{exception}"
        end
    end

    def unfollow_question(question_id)
        # removes row from question_follows
        begin
            QuestionFollow.new(question_id, self.id).remove
            true
        rescue => exception
            raise "unfollow_question failed: #{exception}"
        end
    end

    def like_question(question_id)
        QuestionLike.new(question_id, self.id).create
    end

    def unlike_question(question_id)
        QuestionLike.new(question_id, self.id).remove
    end

    def reply_to_question(question_id, body)
        Reply.new(question_id, null, body, self.id).create
    end

    def delete_question_reply
        
    end

    def reply_to_reply(parent_id, body)
        Reply.new(Reply.find_question_seed(parent_id), parent_id, body, self.id).create
    end

    def delete_reply_reply()
        
    end

    def like_reply(subject_id)
        ReplyLike.new(subject_id, self.id).create
    end

    def unlike_reply(reply_id)
        ReplyLike.new(reply_id, self.id).remove
    end
    
end