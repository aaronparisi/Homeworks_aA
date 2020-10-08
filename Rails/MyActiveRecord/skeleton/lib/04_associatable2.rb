require_relative '03_associatable'

# 
#                                                                                               
#                                                                                               
#                                                                                               
#                                                                                               
# `7MMpMMMb.pMMMb.  ,pW"Wq.`7Mb,od8 .gP"Ya                                                      
#   MM    MM    MM 6W'   `Wb MM' "',M'   Yb                                                     
#   MM    MM    MM 8M     M8 MM    8M""""""                                                     
#   MM    MM    MM YA.   ,A9 MM    YM.    ,                                                     
# .JMML  JMML  JMML.`Ybmd9'.JMML.   `Mbmmd'                                                     
#                                                                                               
#                                                                                               
#                                                                                               
#                                                  ,,                     ,,        ,,          
#       db                                         db         mm         *MM      `7MM          
#      ;MM:                                                   MM          MM        MM          
#     ,V^MM.   ,pP"Ybd ,pP"Ybd  ,pW"Wq.   ,p6"bo `7MM  ,6"YbmmMMmm ,6"Yb. MM,dMMb.  MM  .gP"Ya  
#    ,M  `MM   8I   `" 8I   `" 6W'   `Wb 6M'  OO   MM 8)   MM MM  8)   MM MM    `Mb MM ,M'   Yb 
#    AbmmmqMA  `YMMMa. `YMMMa. 8M     M8 8M        MM  ,pm9MM MM   ,pm9MM MM     M8 MM 8M"""""" 
#   A'     VML L.   I8 L.   I8 YA.   ,A9 YM.    ,  MM 8M   MM MM  8M   MM MM.   ,M9 MM YM.    , 
# .AMA.   .AMMAM9mmmP' M9mmmP'  `Ybmd9'   YMbmd' .JMML`Moo9^Yo`Mbm`Moo9^YoP^YbmdP'.JMML.`Mbmmd' 
#                                                                                               
#                                                                                               
# 

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name.to_s) do
      thru_options = assoc_options[through_name]
      thru_table = thru_options.table_name
      thru_fk = thru_table.thru_options.foreign_key
      thru_fk = thru_table.thru_options.primary_key
      
      src_options = thru_options.model_class.assoc_options[source_name]
      src_table = src_options.table_name
      src_fk = src_table.src_options.foreign_key
      src_pk = src_table.src_options.primary_key

      query = DBConnection.execute(<<-SQL, self.send(thru_fk))
        select
          #{src_table}.*
        from
          #{thru_table}
        join
          #{src_table}
        on
          #{thru_fk} = #{src_pk}
        where
          #{thru_pk} = ?
      SQL

      return source_options.model_class.parse_all(query).first
    end
  end

  def has_many_through(name, through_name, source_name)
    define_method(name.to_s) do
      thru_options = assoc_options[through_name]
      thru_table = thru_options.table_name
      thru_fk = thru_table.thru_options.foreign_key
      thru_fk = thru_table.thru_options.primary_key
      
      src_options = thru_options.model_class.assoc_options[source_name]
      src_table = src_options.table_name
      src_fk = src_table.src_options.foreign_key
      src_pk = src_table.src_options.primary_key

      query = DBConnection.execute(<<-SQL, self.send(thru_fk))
        select
          #{src_table}.*
        from
          #{thru_table}
        join
          #{src_table}
        on
          #{thru_fk} = #{src_pk}
        where
          #{thru_pk} = ?
      SQL

      return source_options.model_class.parse_all(query)
    end
  end

  def includes
    
  end
  
  def joins(t1, t2)
    
  end
  
end