require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    # returns an array of the corresponding database table's column names
    unless @columns
      query = DBConnection.execute2(<<-SQL)
        select *
        from "#{self.table_name}"
      SQL
      @columns = query.first.map(&:to_sym)
    end

    return @columns
  end

  def self.finalize!
  end

  def self.table_name=(table_name)
    # sets the table name attribute for this class
    @table_name = table_name
  end

  def self.table_name
    # returns the name of the database table for the class, like
    # User.table_name => users
    @table_name ? @table_name : self.to_s.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    # ...
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
