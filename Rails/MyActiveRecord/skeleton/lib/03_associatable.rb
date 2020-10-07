require 'byebug'
require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  # BelongsToOptions will inherit this class
  # meaning it will have access to this class' methods
  # i.e. instances of BelongsToOptions will have methods like
  # model_class and table_name,
  # as well as getters and setters for foreign_key, class_name, and primary_key
  # the latter simply means that instances of BelongsToOptions
  # can assign values to those variables, as well as access those var's values
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # any instance of BelongsToOptions will have access to the model_class method
    self.class_name.constantize
  end

  def table_name
    # any instance of BelongsToOptions will have access to the table_name method
    # we want to call the inheriting's class's table_name method,
    # which allows defaults to be set (i.e. "humans" instead of "humen")
    self.model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # HERE is where we define the defaults,
    # aided by the methods in AssocOptions
    self.foreign_key = (options[:foreign_key] ? options[:foreign_key] : name.to_s.foreign_key.to_sym)
    self.class_name = (options[:class_name] ? options[:class_name] : name.to_s.classify)
    self.primary_key = (options[:primary_key] ? options[:primary_key] : :id)
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = (options[:foreign_key] ? options[:foreign_key] : self_class_name.to_s.foreign_key.to_sym)
    self.class_name = (options[:class_name] ? options[:class_name] : name.to_s.classify)
    self.primary_key = (options[:primary_key] ? options[:primary_key] : :id)
  end
end

module Associatable
  # note that these are CLASS methods because our SQL object classes EXTEND this module?
  # Phase IIIb
  def belongs_to(name, options = {})
    # remember, belogns_to is a method which creates methods like aCat.owner
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options
    define_method(options.class_name.underscore) do
      options.model_class
        .send(:where, {options.primary_key => self.send(options.foreign_key)})
        .first
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)
    define_method(options.table_name) do
      options.model_class
      .send(:where, {options.foreign_key => self.send(options.primary_key)})
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    # we are going to STORE some BelongsToOptions for later use
    @assoc_options ||= {}
  end
end

class SQLObject
  # Mixin Associatable here...
  extend Associatable
end
