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
    # automatically adds a getter and setter for each column
    # this method is called at the end of the subclass definition
    # i.e. will be executed whenever the subclass is instantiated??
    # the getters and setters are available to INSTANCES of the subclass
    columns.each do |attr|
      # setter
      define_method("#{attr}=") do |setVal|
        attributes[attr] = setVal
      end

      # getter
      define_method(attr) do
        attributes[attr]
      end
    end
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
    # just like ActiveRecord- Cat.all => all cats
    results = DBConnection.execute(<<-SQL)
      select *
      from "#{self.table_name}"
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    # turn the results of self.all into actual Ruby objects
    ret = []
    results.each do |obj_hash|
      ret << self.new(obj_hash)
    end

    ret
  end

  def self.find(id)
    # returns a single Ruby object with the given id
    # eg. Cat.find(2) => <Cat {id: 2, ...}> or whatever
    result = DBConnection.execute(<<-SQL, id)
      select *
      from "#{self.table_name}"
      where id = ?
    SQL

    result.empty? ? nil : self.new(result.first)
  end

  def initialize(params = {})
    # set the attributes of this instance's @attributes hash
    curColumns = self.class.columns
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      unless curColumns.include?(attr_name)
        raise ArgumentError, "unknown attribute '#{attr_name}'"
      end

      # call the setter method defined in finalize!
      self.send("#{attr_name}=", val)
    end
  end

  def attributes
    # returns a hash, keys are column names, values are the particular
    # instance's attributes (eg. {name: "Wiskers", ...})
    @attributes ||= {}
  end

  def attribute_values
    # returns an array of VALUES corresponding to each of this instances attributes
    self.class.columns.map { |attr| self.send(attr) }
  end

  def insert
    # puts a row in the database corresponding to the Cat object
    columns = self.class.columns.drop(1) # we use this again to get quesiton marks length
    col_names = columns.map(&:to_s).join(", ") # make them strings
    question_marks = (["?"] * columns.length).join(", ")
    attr_vals = attribute_values.drop(1).join(", ")

    # only interpolate the attribute_values
    # could I just make them a string?
    # I think that when you join the attr_vals, you end up with just a string
    # instead of "Gizmo" and 1; idk, but it doesn't work when I do it that way.
    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      insert into #{self.class.table_name} (#{col_names})
      values (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
    # col_names = self.class.columns[1..-1].join(", ")
    # question_marks = (["?"] * (self.class.columns.length-1)).join(", ")

    # DBConnection.execute(<<-SQL, self.class.table_name, col_names, *attribute_values[1..-1])
    #   insert into ? (?)
    #   values (#{question_marks})
    # SQL
    # DBConnection.execute(<<-SQL)
    #   insert into cats (name, owner_id)
    #   values ("Gizmo", 1)
    # SQL

  end

  def update
    # ...
  end

  def save
    # ...
  end
end
