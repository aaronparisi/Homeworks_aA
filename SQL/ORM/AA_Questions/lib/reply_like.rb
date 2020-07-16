require_relative 'intermediary'

require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'user'
require_relative 'like'

require_relative 'model_base'

require 'byebug'

class ReplyLike < Like

    attr_accessor :reply_id, :liker_id

    def self.all
        # returns an array of ReplyLike's
        # representing all entries in the reply_likes table
        data = repliesDB.instance.execute(<<-SQL)
            select *
            from reply_likes
        SQL
        data.map {|datum| ReplyLike.new(datum)}
    end

    def self.find_by_reply_id(num)
        # given a number representing a reply_id,
        # returns an array of ReplyLike's
        # representing all likes of the given reply
        raise "reply not in db" unless reply.has_reply_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select *
            from reply_likes
            where reply_id = ?;
        SQL
        data.map {|datum| ReplyLike.new(datum)}
    end

    def self.find_by_liker_id(num)
        # given a number representing a user's id,
        # returns an array of ReplyLike's
        # representing all likes by given user
        raise "user not in db" unless User.has_user_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select *
            from reply_likes
            where liker_id = ?;
        SQL
        data.map {|datum| ReplyLike.new(datum)}
    end

    def self.reply_likers_ids(num)
        # given a number representing a reply_id,
        # returns an array of numbers representing
        # id's of users who have liked the reply
        raise "reply not in db" unless reply.has_reply_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select liker_id
            from reply_likes
            where subject_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.reply_likers_full(num)
        # given a number representing a reply_id,
        # returns an array of User's who have liked the reply
        raise "reply not in db" unless reply.has_reply_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select U.*
            from users U
            join reply_likes QL on U.id = QL.liker_id
            where QL.reply_id = ?;
        SQL
        data.map {|datum| User.new(datum)}
    end

    def self.likers_reply_ids(num)
        # given a number representing a user_id,
        # returns an array of numbers representing
        # id's of all replies the given user has liked
        raise "user not in db" unless User.has_user_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select reply_id
            from reply_likes
            where liker_id = ?
        SQL
        data.map {|datum| datum.values.first}
    end

    def self.likers_replies_full(num)
        # given a number representing a user_id
        # returns an array of reply's representing
        # every reply the user has liked
        raise "user not in db" unless User.has_user_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select Q.*
            from replies Q
            join reply_likes QL on Q.id = QL.reply_id
            where QL.liker_id = ?;
        SQL
        data.map {|datum| reply.new(datum)}
    end

    def self.num_likes_for_reply_id(num)
        # given a number representing a reply_id,
        # returns the number of likes for said reply
        raise "reply not in db" unless reply.has_reply_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select count(reply_id) as c
            from reply_likes
            where reply_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.num_likes_for_user_id(num)
        # given a number representing a user id,
        # returns the number of replies the user has liked
        raise "user not in db" unless User.has_reply_with_id?(num)
        data = repliesDB.instance.execute(<<-SQL, num)
            select count(reply_id) as c
            from reply_likes
            where liker_id = ?;
        SQL
        data.empty? ? 0 : data.first["c"]
    end

    def self.most_liked_replies(n = self.all.length)
        data = repliesDB.instance.execute(<<-SQL, n)
            select Q.*, count(QL.reply_id) as like_count
            from reply_likes QL
            left join replies Q on QL.reply_id = Q.id
            group by Q.*
            order by like_count desc
            limit ?;
        SQL
        data.empty? ? nil : data.map {|datum| [reply.new(datum), datum["like_count"]]}
    end

    def initialize(options)
        @reply_id = options['reply_id']
        @liker_id = options['liker_id']
    end

    def create
        # add a like to the db
        raise "already liked" if ReplyLike.likers_reply_ids(self.liker_id).include?(self.reply_id)
        begin
            repliesDB.instance.execute(<<-SQL, self.reply_id, self.liker_id)
                insert into reply_likes (reply_id, liker_id)
                values (?, ?);
            SQL
            return true
        rescue => exception
            raise "failed to like reply: #{exception}"
        end
    end

    def update
        # update a reply like
        # is this ever gonna be used??
    end

    def remove
        # removes this like from the db
        raise "can't unlike a reply you didn't like" unless ReplyLike.likers_reply_ids(self.liker_id).include?(self.reply_id)

        begin
            repliesDB.instance.execute(<<-SQL, self.reply_id, self.liker_id)
                delete from reply_likes
                where reply_id = ? and liker_id = ?;
            SQL

            return true
        rescue => e
            raise "failed to delete reply_like: #{e}"
        end
    end
end