require 'byebug'
require_relative 'db_connection'
require_relative '01_sql_object'

# 
#                                                                                  
#                                   ,,              ,,                             
#                                 `7MM            `7MM                             
#                                   MM              MM                             
# `7MMpMMMb.pMMMb.  ,pW"Wq.    ,M""bMM `7MM  `7MM   MM  .gP"Ya                     
#   MM    MM    MM 6W'   `Wb ,AP    MM   MM    MM   MM ,M'   Yb                    
#   MM    MM    MM 8M     M8 8MI    MM   MM    MM   MM 8M""""""                    
#   MM    MM    MM YA.   ,A9 `Mb    MM   MM    MM   MM YM.    ,                    
# .JMML  JMML  JMML.`Ybmd9'   `Wbmd"MML. `Mbod"YML.JMML.`Mbmmd'                    
#                                                                                  
#                                                                                  
#                                                                                  
#                                           ,,               ,,        ,,          
#                                         `7MM              *MM      `7MM          
#                                           MM               MM        MM          
# ,pP"Ybd  .gP"Ya   ,6"Yb. `7Mb,od8 ,p6"bo  MMpMMMb.  ,6"Yb. MM,dMMb.  MM  .gP"Ya  
# 8I   `" ,M'   Yb 8)   MM   MM' "'6M'  OO  MM    MM 8)   MM MM    `Mb MM ,M'   Yb 
# `YMMMa. 8M""""""  ,pm9MM   MM    8M       MM    MM  ,pm9MM MM     M8 MM 8M"""""" 
# L.   I8 YM.    , 8M   MM   MM    YM.    , MM    MM 8M   MM MM.   ,M9 MM YM.    , 
# M9mmmP'  `Mbmmd' `Moo9^Yo.JMML.   YMbmd'.JMML  JMML`Moo9^YoP^YbmdP'.JMML.`Mbmmd' 
#                                                                                  
#                                                                                  
# 

module Searchable
  def where(params)

    where_line = params.keys.map { |key| "#{key} = ?"}.join(" and ")

    results = DBConnection.execute(<<-SQL, *params.values)
      select *
      from #{table_name}
      where #{where_line}
    SQL

    parse_all(results)
  end

  def lazy_where(params)
    # we want a where method that is "lazy"
    # i.e. does not execute the query until the results are NEEDED
    # (notice above, the query is run in the course of the execution of where)
    
  end
  
  def stackable_where(params)
    # we want a method that can be called on the results of previous calls
    # methinks that it can't be a class method cause we would say
    # Cat.where().where()
  end
  

  def all
    results = DBConnection.execute(<<-SQL)
      select *
      from #{table_name}
    SQL

    parse_all(results)
  end

  def parse_all(results)
    ret = []
    results.each do |obj_hash|
      ret << self.new(obj_hash)
    end

    ret
  end

  def find(id)
    result = DBConnection.execute(<<-SQL, id)
      select *
      from #{table_name}
      where id = ?
    SQL

    result.empty? ? nil : self.new(result.first)
  end
    
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable
end
