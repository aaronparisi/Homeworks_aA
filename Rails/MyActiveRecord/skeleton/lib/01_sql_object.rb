require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

# 
#                                                                                     
#          ,,                                                                         
#        `7MM                                                                         
#          MM                                                                         
#  ,p6"bo  MM   ,6"Yb.  ,pP"Ybd ,pP"Ybd                                               
# 6M'  OO  MM  8)   MM  8I   `" 8I   `"                                               
# 8M       MM   ,pm9MM  `YMMMa. `YMMMa.                                               
# YM.    , MM  8M   MM  L.   I8 L.   I8                                               
#  YMbmd'.JMML.`Moo9^Yo.M9mmmP' M9mmmP'                                               
#                                                                                     
#                                                                                     
#                                                                                     
#                                               ,,        ,,                          
#  .M"""bgd   .g8""8q. `7MMF'        .g8""8q.  *MM        db                    mm    
# ,MI    "Y .dP'    `YM. MM        .dP'    `YM. MM                              MM    
# `MMb.     dM'      `MM MM        dM'      `MM MM,dMMb.`7MM  .gP"Ya   ,p6"bo mmMMmm  
#   `YMMNq. MM        MM MM        MM        MM MM    `Mb MM ,M'   Yb 6M'  OO   MM    
# .     `MM MM.      ,MP MM      , MM.      ,MP MM     M8 MM 8M"""""" 8M        MM    
# Mb     dM `Mb.    ,dP' MM     ,M `Mb.    ,dP' MM.   ,M9 MM YM.    , YM.    ,  MM    
# P"Ybmmd"    `"bmmd"' .JMMmmmmMMM   `"bmmd"'   P^YbmdP'  MM  `Mbmmd'  YMbmd'   `Mbmo 
#                 MMb                                  QO MP                          
#                  `bood'                              `bmP                           
# 


class SQLObject
# 
#                                                                                                                                     
#                                ,,                                                              ,,                        ,,         
#                              `7MM                                                        mm  `7MM                      `7MM         
#         `\\.                   MM                                                        MM    MM                        MM         
#            `\\:.       ,p6"bo  MM  ,6"Yb. ,pP"Ybd ,pP"Ybd     `7MMpMMMb.pMMMb.  .gP"Ya mmMMmm  MMpMMMb.  ,pW"Wq.    ,M""bMM ,pP"Ybd 
# mmmmmmmmm     `\\.    6M'  OO  MM 8)   MM 8I   `" 8I   `"       MM    MM    MM ,M'   Yb  MM    MM    MM 6W'   `Wb ,AP    MM 8I   `" 
#              ,;//'    8M       MM  ,pm9MM `YMMMa. `YMMMa.       MM    MM    MM 8M""""""  MM    MM    MM 8M     M8 8MI    MM `YMMMa. 
# mmmmmmmmm ,;//'       YM.    , MM 8M   MM L.   I8 L.   I8       MM    MM    MM YM.    ,  MM    MM    MM YA.   ,A9 `Mb    MM L.   I8 
#         ,//'           YMbmd'.JMML`Moo9^YoM9mmmP' M9mmmP'     .JMML  JMML  JMML.`Mbmmd'  `Mbm.JMML  JMML.`Ybmd9'   `Wbmd"MMLM9mmmP' 
#                                                                                                                                     
#                                                                                                                                     
# 

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
    @table_name ? @table_name : self.to_s.tableize
  end

  # def self.all
  #   results = DBConnection.execute(<<-SQL)
  #     select *
  #     from "#{self.table_name}"
  #   SQL

  #   parse_all(results)
  # end

  # def self.parse_all(results)
  #   ret = []
  #   results.each do |obj_hash|
  #     ret << self.new(obj_hash)
  #   end

  #   ret
  # end

  # def self.find(id)
  #   result = DBConnection.execute(<<-SQL, id)
  #     select *
  #     from #{self.table_name}
  #     where id = ?
  #   SQL

  #   result.empty? ? nil : self.new(result.first)
  # end
# 
#                                                                                                                       
#                         ,,                                                       ,,                        ,,         
#                         db                        `7MMM.     ,MMF'         mm  `7MM                      `7MM         
#         `\\.                                        MMMb    dPMM           MM    MM                        MM         
#            `\\:.      `7MM `7MMpMMMb. ,pP"Ybd       M YM   ,M MM  .gP"Ya mmMMmm  MMpMMMb.  ,pW"Wq.    ,M""bMM ,pP"Ybd 
# mmmmmmmmm     `\\.      MM   MM    MM 8I   `"       M  Mb  M' MM ,M'   Yb  MM    MM    MM 6W'   `Wb ,AP    MM 8I   `" 
#              ,;//'      MM   MM    MM `YMMMa.       M  YM.P'  MM 8M""""""  MM    MM    MM 8M     M8 8MI    MM `YMMMa. 
# mmmmmmmmm ,;//'         MM   MM    MM L.   I8       M  `YM'   MM YM.    ,  MM    MM    MM YA.   ,A9 `Mb    MM L.   I8 
#         ,//'          .JMML.JMML  JMMLM9mmmP'     .JML. `'  .JMML.`Mbmmd'  `Mbm.JMML  JMML.`Ybmd9'   `Wbmd"MMLM9mmmP' 
#                                                                                                                       
#                                                                                                                       
# 

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

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      insert into #{self.class.table_name} (#{col_names})
      values (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    # updates an existing record in the database table
    set_line = self.class
      .columns
      .drop(1)
      .map { |attr_name| "#{attr_name.to_s} = ?"}
      .join(", ")
    DBConnection.execute(<<-SQL, *(attribute_values.rotate))
      update #{self.class.table_name}
      set #{set_line}
      where id = ?
    SQL
  end

  def save
    # calls either #insert or #update
    self.id ? update : insert
  end
end
