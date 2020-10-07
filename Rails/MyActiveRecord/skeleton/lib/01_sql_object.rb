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
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
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
