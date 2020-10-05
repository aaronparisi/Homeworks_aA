# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 
#                                               
#                                               
# `7MMF'   `7MF'                                
#   MM       M                                  
#   MM       M ,pP"Ybd  .gP"Ya `7Mb,od8 ,pP"Ybd 
#   MM       M 8I   `" ,M'   Yb  MM' "' 8I   `" 
#   MM       M `YMMMa. 8M""""""  MM     `YMMMa. 
#   YM.     ,M L.   I8 YM.    ,  MM     L.   I8 
#    `bmmmmd"' M9mmmP'  `Mbmmd'.JMML.   M9mmmP' 
#                                               
#                                               
# 

aaron = User.create(username: "Aaron")
kristin = User.create(username: "Kristin")
circe = User.create(username: "Circe")
maggie = User.create(username: "Maggie")
nick = User.create(username: "Nick")
jamison = User.create(username: "Jamison")
julie = User.create(username: "Julie")
annalivia = User.create(username: "Annalivia")

# 
#                                                                                                                         
#                                                                ,,                                             ,,    ,,  
# `7MM"""Yb.                                              mm     db                         `7MM"""Mq.        `7MM  `7MM  
#   MM    `Yb.                                            MM                                  MM   `MM.         MM    MM  
#   MM     `Mb  .gP"Ya   ,p6"bo   ,pW"Wq.`7Mb,od8 ,6"Yb.mmMMmm `7MM  ,pW"Wq.`7MMpMMMb.        MM   ,M9 ,pW"Wq.  MM    MM  
#   MM      MM ,M'   Yb 6M'  OO  6W'   `Wb MM' "'8)   MM  MM     MM 6W'   `Wb MM    MM        MMmmdM9 6W'   `Wb MM    MM  
#   MM     ,MP 8M"""""" 8M       8M     M8 MM     ,pm9MM  MM     MM 8M     M8 MM    MM        MM      8M     M8 MM    MM  
#   MM    ,dP' YM.    , YM.    , YA.   ,A9 MM    8M   MM  MM     MM YA.   ,A9 MM    MM        MM      YA.   ,A9 MM    MM  
# .JMMmmmdP'    `Mbmmd'  YMbmd'   `Ybmd9'.JMML.  `Moo9^Yo.`Mbmo.JMML.`Ybmd9'.JMML  JMML.    .JMML.     `Ybmd9'.JMML..JMML.
#                                                                                                                         
#                                                                                                                         
# 

decoration_poll = aaron.authored_polls.build(title: "Living Room Decorations")
decoration_poll.save

# question
streamer_decoration_q = decoration_poll.questions.build(text: "Should we put up streamers?")
streamer_decoration_q.save
# answer_choices
fuck_streamers = streamer_decoration_q.answer_choices.build(text: "Fuck your streamers")
fuck_streamers.save
no_ceiling = streamer_decoration_q.answer_choices.build(text: "I don't want to be able to see the ceiling")
no_ceiling.save
whats_a_streamer = streamer_decoration_q.answer_choices.build(text: "What's a streamer?")
whats_a_streamer.save
# responses
jamison.responses.build(answer_choice_id: fuck_streamers.id).save
kristin.responses.build(answer_choice_id: whats_a_streamer.id).save

# question
bday_banner_decoration_q = decoration_poll.questions.build(text: "Should we keep the bday banners up?")
bday_banner_decoration_q.save
# answer_choices
aarons_bday = bday_banner_decoration_q.answer_choices.build(text: "As long as it says Aaron")
aarons_bday.save
no_bdays = bday_banner_decoration_q.answer_choices.build(text: "We should not celebrate birthdays")
no_bdays.save
carved_bday = bday_banner_decoration_q.answer_choices.build(text: "Carve it into the wood")
carved_bday.save
#responses
annalivia.responses.build(answer_choice_id: aarons_bday.id).save
maggie.responses.build(answer_choice_id: carved_bday.id).save
kristin.responses.build(answer_choice_id: aarons_bday.id).save

# 
#                                                                    
#                                                          ,,    ,,  
# `7MM"""Mq.          mm               `7MM"""Mq.        `7MM  `7MM  
#   MM   `MM.         MM                 MM   `MM.         MM    MM  
#   MM   ,M9 .gP"Ya mmMMmm ,pP"Ybd       MM   ,M9 ,pW"Wq.  MM    MM  
#   MMmmdM9 ,M'   Yb  MM   8I   `"       MMmmdM9 6W'   `Wb MM    MM  
#   MM      8M""""""  MM   `YMMMa.       MM      8M     M8 MM    MM  
#   MM      YM.    ,  MM   L.   I8       MM      YA.   ,A9 MM    MM  
# .JMML.     `Mbmmd'  `MbmoM9mmmP'     .JMML.     `Ybmd9'.JMML..JMML.
#                                                                    
#                                                                    
# 


pets_poll = jamison.authored_polls.build(title: "Secret Pets")
pets_poll.save

#question
guinea_pig_q = pets_poll.questions.build(text: "Should we be allowed to keep guinea pigs in our rooms?")
guinea_pig_q.save
# answer_choices
no_pets = guinea_pig_q.answer_choices.build(text: "Um, no, it's on the fucking lease")
no_pets.save
all_pets = guinea_pig_q.answer_choices.build(text: "If one person has one, we all get one")
all_pets.save
allergic = guinea_pig_q.answer_choices.build(text: "I'm allergic")
allergic.save

# responses
kristin.responses.build(answer_choice_id: no_pets.id).save

# question
gecko_q = pets_poll.questions.build(text: "Who wants to feed Tony's leopard gecko?")
gecko_q.save
# answer_choices
starved_gecko = gecko_q.answer_choices.build(text: "Let the beast starve")
starved_gecko.save
ill_do_it = gecko_q.answer_choices.build(text: "I'll do it!")
ill_do_it.save
tattle_tale = gecko_q.answer_choices.build(text: "I'm telling AvenueOne")
tattle_tale.save

# responses
kristin.responses.build(answer_choice_id: tattle_tale.id).save

# 
#                                                                                                       
#                                    ,,                                                       ,,    ,,  
#                                  `7MM                                                     `7MM  `7MM  
#                                    MM                                                       MM    MM  
# `7MMpdMAo.`7Mb,od8 ,pW"Wq.    ,M""bMM `7MM  `7MM  ,p6"bo   .gP"Ya      `7MMpdMAo.  ,pW"Wq.  MM    MM  
#   MM   `Wb  MM' "'6W'   `Wb ,AP    MM   MM    MM 6M'  OO  ,M'   Yb       MM   `Wb 6W'   `Wb MM    MM  
#   MM    M8  MM    8M     M8 8MI    MM   MM    MM 8M       8M""""""       MM    M8 8M     M8 MM    MM  
#   MM   ,AP  MM    YA.   ,A9 `Mb    MM   MM    MM YM.    , YM.    ,       MM   ,AP YA.   ,A9 MM    MM  
#   MMbmmd' .JMML.   `Ybmd9'   `Wbmd"MML. `Mbod"YML.YMbmd'   `Mbmmd'       MMbmmd'   `Ybmd9'.JMML..JMML.
#   MM                                                                     MM                           
# .JMML.                                                                 .JMML.                         
# 

produce_poll = circe.authored_polls.build(title: "Communal Produce")
produce_poll.save

# question
carrots_q = produce_poll.questions.build(text: "Whose carrots are these?")
carrots_q.save
# answer_choices
aarons_carrots = carrots_q.answer_choices.build(text: "Aaron's.  This is Aaron's section.")
aarons_carrots.save
carrots_for_grabs = carrots_q.answer_choices.build(text: "Whoever feels like eating them")
carrots_for_grabs.save
evil_carrots = carrots_q.answer_choices.build(text: "Carrots are bad for the environment")
evil_carrots.save

# question
rotten_spinach_q = produce_poll.questions.build(text: "Can we throw out rotten spinach?")
rotten_spinach_q.save
# answer_choices
hands_off = rotten_spinach_q.answer_choices.build(text: "DON'T TOUCH MY FOOD!")
hands_off.save
leaking_leaves = rotten_spinach_q.answer_choices.build(text: "It's literally leaking into the drawer, throw it out")
leaking_leaves.save
sin_to_waste = rotten_spinach_q.answer_choices.build(text: "It's a sin to waste food, you have to eat it")
sin_to_waste.save
