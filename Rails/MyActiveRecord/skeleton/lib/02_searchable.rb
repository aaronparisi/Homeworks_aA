require 'byebug'
require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    # performs a where search on the database
    # whereString = params.map { |attr, val| "#{attr} = #{val}"}.join(" and ")
    # # valString = params.values.join(", ")
    # # debugger
    # DBConnection.execute(<<-SQL, whereString)
    #   select *
    #   from #{self.table_name}
    #   where ?
    # SQL

    where_line = params.keys.map { |key| "#{key} = ?"}.join(" and ")
    # it's important to splat the VALUES; some are strings, some are integers, etc
    results = DBConnection.execute(<<-SQL, *params.values)
      select *
      from #{table_name}
      where #{where_line}
    SQL

    parse_all(results)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
