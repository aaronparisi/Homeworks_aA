require 'byebug'
require_relative '02_searchable'
require 'active_support/inflector'

# 
#                                                                                                              
#          ,,                                                                                                  
#        `7MM                                                                                                  
#          MM                                                                                                  
#  ,p6"bo  MM  ,6"Yb. ,pP"Ybd ,pP"Ybd                                                                          
# 6M'  OO  MM 8)   MM 8I   `" 8I   `"                                                                          
# 8M       MM  ,pm9MM `YMMMa. `YMMMa.                                                                          
# YM.    , MM 8M   MM L.   I8 L.   I8                                                                          
#  YMbmd'.JMML`Moo9^YoM9mmmP' M9mmmP'                                                                          
#                                                                                                              
#                                                                                                              
#                                                                                                              
#                                                                                ,,                            
#       db                                          .g8""8q.              mm     db                            
#      ;MM:                                       .dP'    `YM.            MM                                   
#     ,V^MM.   ,pP"Ybd ,pP"Ybd  ,pW"Wq.   ,p6"bo  dM'      `MM `7MMpdMAommMMmm `7MM  ,pW"Wq.`7MMpMMMb. ,pP"Ybd 
#    ,M  `MM   8I   `" 8I   `" 6W'   `Wb 6M'  OO  MM        MM   MM   `Wb MM     MM 6W'   `Wb MM    MM 8I   `" 
#    AbmmmqMA  `YMMMa. `YMMMa. 8M     M8 8M       MM.      ,MP   MM    M8 MM     MM 8M     M8 MM    MM `YMMMa. 
#   A'     VML L.   I8 L.   I8 YA.   ,A9 YM.    , `Mb.    ,dP'   MM   ,AP MM     MM YA.   ,A9 MM    MM L.   I8 
# .AMA.   .AMMAM9mmmP' M9mmmP'  `Ybmd9'   YMbmd'    `"bmmd"'     MMbmmd'  `Mbmo.JMML.`Ybmd9'.JMML  JMMLM9mmmP' 
#                                                                MM                                            
#                                                              .JMML.                                          
# 

class AssocOptions
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
    self.model_class.table_name
  end
end
# 
#                                                                                                                                       
#          ,,                                                                                                                           
#        `7MM                                                                                                                           
#          MM                                                                                                                           
#  ,p6"bo  MM  ,6"Yb. ,pP"Ybd ,pP"Ybd                                                                                                   
# 6M'  OO  MM 8)   MM 8I   `" 8I   `"                                                                                                   
# 8M       MM  ,pm9MM `YMMMa. `YMMMa.                                                                                                   
# YM.    , MM 8M   MM L.   I8 L.   I8                                                                                                   
#  YMbmd'.JMML`Moo9^YoM9mmmP' M9mmmP'                                                                                                   
#                                                                                                                                       
#                                                                                                                                       
#                                                                                                                                       
#                     ,,                                                                                  ,,                            
# `7MM"""Yp,        `7MM                                 MMP""MM""YMM        .g8""8q.              mm     db                            
#   MM    Yb          MM                                 P'   MM   `7      .dP'    `YM.            MM                                   
#   MM    dP  .gP"Ya  MM  ,pW"Wq.`7MMpMMMb.  .P"Ybmmm ,pP"Ybd MM  ,pW"Wq.  dM'      `MM `7MMpdMAommMMmm `7MM  ,pW"Wq.`7MMpMMMb. ,pP"Ybd 
#   MM"""bg. ,M'   Yb MM 6W'   `Wb MM    MM :MI  I8   8I   `" MM 6W'   `Wb MM        MM   MM   `Wb MM     MM 6W'   `Wb MM    MM 8I   `" 
#   MM    `Y 8M"""""" MM 8M     M8 MM    MM  WmmmP"   `YMMMa. MM 8M     M8 MM.      ,MP   MM    M8 MM     MM 8M     M8 MM    MM `YMMMa. 
#   MM    ,9 YM.    , MM YA.   ,A9 MM    MM 8M        L.   I8 MM YA.   ,A9 `Mb.    ,dP'   MM   ,AP MM     MM YA.   ,A9 MM    MM L.   I8 
# .JMMmmmd9   `Mbmmd.JMML.`Ybmd9'.JMML  JMML.YMMMMMb  M9mmmP.JMML.`Ybmd9'    `"bmmd"'     MMbmmd'  `Mbmo.JMML.`Ybmd9'.JMML  JMMLM9mmmP' 
#                                           6'     dP                                     MM                                            
#                                           Ybmmmd'                                     .JMML.                                          
# 

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    # HERE is where we define the defaults,
    # aided by the methods in AssocOptions
    self.foreign_key = (options[:foreign_key] ? options[:foreign_key] : name.to_s.foreign_key.to_sym)
    self.class_name = (options[:class_name] ? options[:class_name] : name.to_s.classify)
    self.primary_key = (options[:primary_key] ? options[:primary_key] : :id)
  end
end
# 
#                                                                                                                                   
#          ,,                                                                                                                       
#        `7MM                                                                                                                       
#          MM                                                                                                                       
#  ,p6"bo  MM  ,6"Yb. ,pP"Ybd ,pP"Ybd                                                                                               
# 6M'  OO  MM 8)   MM 8I   `" 8I   `"                                                                                               
# 8M       MM  ,pm9MM `YMMMa. `YMMMa.                                                                                               
# YM.    , MM 8M   MM L.   I8 L.   I8                                                                                               
#  YMbmd'.JMML`Moo9^YoM9mmmP' M9mmmP'                                                                                               
#                                                                                                                                   
#                                                                                                                                   
#                                                                                                                                   
#                                                                                                     ,,                            
# `7MMF'  `7MMF'             `7MMM.     ,MMF'                            .g8""8q.              mm     db                            
#   MM      MM                 MMMb    dPMM                            .dP'    `YM.            MM                                   
#   MM      MM  ,6"Yb. ,pP"Ybd M YM   ,M MM  ,6"Yb. `7MMpMMMb`7M'   `MFdM'      `MM `7MMpdMAommMMmm `7MM  ,pW"Wq.`7MMpMMMb. ,pP"Ybd 
#   MMmmmmmmMM 8)   MM 8I   `" M  Mb  M' MM 8)   MM   MM    MM VA   ,V MM        MM   MM   `Wb MM     MM 6W'   `Wb MM    MM 8I   `" 
#   MM      MM  ,pm9MM `YMMMa. M  YM.P'  MM  ,pm9MM   MM    MM  VA ,V  MM.      ,MP   MM    M8 MM     MM 8M     M8 MM    MM `YMMMa. 
#   MM      MM 8M   MM L.   I8 M  `YM'   MM 8M   MM   MM    MM   VVV   `Mb.    ,dP'   MM   ,AP MM     MM YA.   ,A9 MM    MM L.   I8 
# .JMML.  .JMML`Moo9^YoM9mmmP.JML. `'  .JMML`Moo9^Yo.JMML  JMML. ,V      `"bmmd"'     MMbmmd'  `Mbmo.JMML.`Ybmd9'.JMML  JMMLM9mmmP' 
#                                                               ,V                    MM                                            
#                                                            OOb"                   .JMML.                                          
# 

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = (options[:foreign_key] ? options[:foreign_key] : self_class_name.to_s.foreign_key.to_sym)
    self.class_name = (options[:class_name] ? options[:class_name] : name.to_s.classify)
    self.primary_key = (options[:primary_key] ? options[:primary_key] : :id)
  end
end
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
    assoc_options[name] = options
    define_method(options.table_name) do
      options.model_class
      .send(:where, {options.foreign_key => self.send(options.primary_key)})
    end
  end

  def assoc_options
    # we are going to STORE some BelongsToOptions for later use
    @assoc_options ||= {}
  end
end

# 
#                                                                                     
#                    ,,             ,,                                                
#                    db             db                                                
#                                                                                     
# `7MMpMMMb.pMMMb. `7MM `7M'   `MF`7MM `7MMpMMMb.                                     
#   MM    MM    MM   MM   `VA ,V'   MM   MM    MM                                     
#   MM    MM    MM   MM     XMX     MM   MM    MM                                     
#   MM    MM    MM   MM   ,V' VA.   MM   MM    MM                                     
# .JMML  JMML  JMML.JMML.AM.   .MA.JMML.JMML  JMML.                                   
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
  # Mixin Associatable here...
  extend Associatable
end
