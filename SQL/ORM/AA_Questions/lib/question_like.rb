require_relative 'intermediary'

require_relative 'question'
require_relative 'user'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'reply_like'
require_relative 'like'

require_relative 'model_base'

require 'byebug'

class QuestionLike < Like

    attr_accessor :question_id, :liker_id

    def self.all
        # returns an array of QuestionLike's
        # representing all entries in the question_likes table
        data = QuestionsDB.instance.execute(<<-SQL)
            select *
            from question_likes
        SQL
        data.map {|datum| QuestionLike.new(datum)}
    end

    def self.find_by_question_id(num)
        # given a number representing a question_id,
        # returns an array of QuestionLike's
        # representing all likes of the given question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from question_likes
            where question_id = ?;
        SQL
        data.map {|datum| QuestionLike.new(datum)}
    end

    def self.find_by_liker_id(num)
        # given a number representing a user's id,
        # returns an array of QuestionLike's
        # representing all likes by given user
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select *
            from question_likes
            where liker_id = ?;
        SQL
        data.map {|datum| QuestionLike.new(datum)}
    end

    def self.question_likers_ids(num)
        # given a number representing a question_id,
        # returns an array of numbers representing
        # id's of users who have liked the question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select liker_id
            from question_likes
            where question_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.question_likers_full(num)
        # given a number representing a question_id,
        # returns an array of User's who have liked the question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select U.*
            from users U
            join question_likes QL on U.id = QL.liker_id
            where QL.question_id = ?;
        SQL
        data.map {|datum| User.new(datum)}
    end

    def self.likers_question_ids(num)
        # given a number representing a user_id,
        # returns an array of numbers representing
        # id's of all questions the given user has liked
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select question_id
            from question_likes
            where liker_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.likers_questions_full(num)
        # given a number representing a user_id
        # returns an array of Question's representing
        # every question the user has liked
        raise "user not in db" unless User.has_user_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select Q.*
            from questions Q
            join question_likes QL on Q.id = QL.question_id
            where QL.liker_id = ?;
        SQL
        data.map {|datum| Question.new(datum)}
    end

    def self.num_likes_for_question_id(num)
        # given a number representing a question_id,
        # returns the number of likes for said question
        raise "question not in db" unless Question.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select count(question_id) as c
            from question_likes
            where question_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.num_likes_for_user_id(num)
        # given a number representing a user id,
        # returns the number of questions the user has liked
        raise "user not in db" unless User.has_question_with_id?(num)
        data = QuestionsDB.instance.execute(<<-SQL, num)
            select count(question_id) as c
            from question_likes
            where liker_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.most_liked_questions(n = self.all.length)
        data = QuestionsDB.instance.execute(<<-SQL, n)
            select Q.*, count(QL.question_id) as like_count
            from question_likes QL
            left join questions Q on QL.question_id = Q.id
            group by Q.*
            order by like_count desc
            limit ?;
        SQL
        data.empty? ? nil : data.map {|datum| [Question.new(datum), datum["like_count"]]}
    end

    def initialize(options)
        @question_id = options['question_id']
        @liker_id = options['liker_id']
    end

    def create
        # add a like to the db
        raise "already liked" if QuestionLike.likers_question_ids(self.liker_id).include?(self.question_id)
        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.liker_id)
                insert into question_likes (question_id, liker_id)
                values (?, ?);
            SQL
            return true
        rescue => exception
            raise "failed to like question: #{exception}"
        end
    end

    def update
        # update a question like
        # is this ever gonna be used??
    end

    def remove
        # removes this like from the db
        raise "can't unlike a question you didn't like" unless QuestionLike.likers_question_ids(self.liker_id).include?(self.question_id)

        begin
            QuestionsDB.instance.execute(<<-SQL, self.question_id, self.liker_id)
                delete from question_likes
                where question_id = ? and liker_id = ?;
            SQL

            return true
        rescue => e
            raise "failed to delete question_like: #{e}"
        end
    end
end