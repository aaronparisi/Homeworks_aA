require_relative 'intermediary'

require_relative 'question'
require_relative 'question_like'
require_relative 'user'
require_relative 'reply'
require_relative 'reply_like'

require_relative 'model_base'

require 'byebug'

class QuestionFollow

    attr_accessor :question_id, :follower_id

    def self.all
        # returns an array of QuestionFollow's
        # representing all entries in the question_follows table
        data = QuestionsDB.instance.execute(<<-SQL)
            select *
            from question_follows
        SQL
        data.map {|datum| QuestionFollow.new(datum)}
    end

    def self.find_by_question_id(num)
        # given a number representing a question_id,
        # returns an array of QuestionFollow's
        # representing all follows of the given question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from question_follows
            where question_id = ?;
        SQL
        data.map {|datum| QuestionFollow.new(datum)}
    end

    def self.find_by_follower_id(num)
        # given a number representing a user's id,
        # returns an array of QuestionFollow's
        # representing all follows by given user
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from question_follows
            where follower_id = ?;
        SQL
        data.map {|datum| QuestionFollow.new(datum)}
    end

    def self.question_follows_ids(num)
        # given a number representing a question_id,
        # returns an array of numbers representing
        # id's of users who have followed the question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select follower_id
            from question_follows
            where question_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.question_follows_full(num)
        # given a number representing a question_id,
        # returns an array of User's who have followed the question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select U.*
            from users U
            join question_follows QL on U.id = QL.follower_id
            where QL.question_id = ?;
        SQL
        data.map {|datum| User.new(datum)}
    end

    def self.followers_question_ids(num)
        # given a number representing a user_id,
        # returns an array of numbers representing
        # id's of all questions the given user has followed
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select question_id
            from question_follows
            where follower_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.followers_questions_full(num)
        # given a number representing a user_id
        # returns an array of Question's representing
        # every question the user has followed
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select Q.*
            from questions Q
            join question_follows QL on Q.id = QL.question_id
            where QL.follower_id = ?;
        SQL
        data.map {|datum| Question.new(datum)}
    end

    def self.num_follows_for_question_id(num)
        # given a number representing a question_id,
        # returns the number of follows for said question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select count(question_id) as c
            from question_follows
            where question_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.num_follows_for_user_id(num)
        # given a number representing a user id,
        # returns the number of questions the user has followed
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select count(question_id) as c
            from question_follows
            where follower_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.most_followed_questions(n = self.all.length)
        data = QuestionsDB.instance.execute(<<-SQL, n)
            select Q.id, Q.title, Q.body, Q.author_id, count(QL.question_id) as follow_count
            from question_follows QL
            left join questions Q on QL.question_id = Q.id
            group by Q.id, Q.title, Q.body, Q.author_id
            order by follow_count desc
            limit ?;
        SQL
        data.empty? ? nil : data.map {|datum| [Question.new(datum), datum["follow_count"]]}
    end

    def initialize(options)
        @question_id = options['question_id']
        @follower_id = options['follower_id']
    end

    def create
        # add a follow to the db
        raise "already followed" if QuestionFollow.followers_question_ids(self.follower_id).include?(self.question_id)
        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.follower_id)
                insert into question_follows (question_id, follower_id)
                values (?, ?);
            SQL
            return true
        rescue => exception
            raise "failed to follow question: #{exception}"
        end
    end

    def update
        # update a question follow
        # is this ever gonna be used??
    end

    def remove
        # removes this follow from the db
        raise "can't unfollow a question you didn't follow" unless QuestionFollow.followers_question_ids(self.follower_id).include?(self.question_id)

        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.follower_id)
                delete from question_follows
                where question_id = ? and follower_id = ?;
            SQL

            return true
        rescue => e
            raise "failed to delete question_follow: #{e}"
        end
    end
end