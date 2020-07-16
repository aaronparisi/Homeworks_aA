require_relative 'intermediary'

require_relative 'user'
require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'
require_relative 'reply_like'

require 'byebug'

# Klass::all

# Klass::find_by_id

# instance#save

class ModelBase

    def self.all(table_name, class_name)
        data = QuestionsDB.instance.execute(<<-SQL)
            select *
            from #{table_name};
        SQL
        data.map {|datum| class_name.new(datum)}
    end

    def self.find_by_matchers(table_name, match_arr, val_pairs, class_name)
        # val_pairs is an array of hashes
        # each hash contains 2 elements: :match_type and :val
        # {:match_type => '='} OR {:match_type => 'like'}
        match_arr.map!.with_index do |m, i|
            type = val_pairs[i][:match_type]
            to_append = val_pairs[i][:val]
            if type == 'like'
                to_append = "%#{to_append}%"
            end
            if to_append.is_a?(Integer)
                "#{m} #{type} #{to_append}"
            else
                "#{m} #{type} '#{to_append}'"
            end
        end
        where_str = match_arr.join(", ")
        data = QuestionsDB.instance.execute(<<-SQL)
            select *
            from #{table_name}
            where #{where_str}
        SQL

        # ALL FINDERS RETURN ARRAYS
        data.map {|datum| class_name.new(datum)}
    end

    def self.save(inst)
        obj = ModelBase.new(inst)
        obj.var_vals[0].nil? ? ModelBase.create(obj) : ModelBase.update(obj)
    end

    def self.create(obj)
        # avoid duplication
        raise "already in db" unless obj.var_vals[0].nil?

        # determine table for insertion
        case obj.klass.to_s
        when "User"
            table_name = "users"
        when "Question"
            table_name = "questions"
        end

        # get column names, row values
        col_string = obj.vars[1..-1].map do |var|
            if var.is_a?(Integer)
                var
            else
                var.to_s[1..-1]
            end
        end.join(", ")

        row_string = obj.var_vals[1..-1]
        row_string = "'#{row_string.join("', '")}'"
        
        QuestionsDB.instance.execute(<<-SQL)
            insert into #{table_name} (#{col_string})
            values (#{row_string});
        SQL
        # why the fuck is it saying 'no column 'John''?????

        return QuestionsDB.instance.last_insert_row_id
    end

    def self.update(obj)
        raise "not in db" if obj.var_vals[0].nil?
        
        case obj.klass.to_s
        when "User"
            table_name = "users"
        when "Question"
            table_name = "questions"
        end

        # get column names, row values
        col_arr = obj.vars[1..-1].map {|var| var.to_s[1..-1] + " = "}

        col_arr.map!.with_index do |el, i|
            to_add = obj.var_vals[i+1]
            if to_add.is_a?(Integer)
                el + to_add.to_s
            else
                el + "\'#{to_add}\'"
            end
        end
        set_string = col_arr.join(", ")
        match_id = obj.var_vals[0]
        
        QuestionsDB.instance.execute(<<-SQL, match_id)
            update #{table_name}
            set #{set_string}
            where id = ?;
        SQL
        
        true
    end

    attr_reader :vars, :var_vals, :klass

    def initialize(obj)
        @vars = obj.instance_variables
        @var_vals = []
        @vars.each do |var|
            @var_vals << obj.instance_variable_get(var)
        end
        @klass = obj.class
    end
end