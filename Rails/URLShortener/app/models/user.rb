# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  premium    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email)
#
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_many :shortened_urls, dependent: :destroy

  has_many :visits, dependent: :destroy
  has_many :visiteds, through: :visits, source: :visited

  has_many :votes, dependent: :destroy
  has_many :voted_ons, through: :votes, source: :voted_on

  # 
#                                                                                                                                                    
#   ,,                                                                                                         ,,                        ,,          
#   db                        mm                                                                        mm   `7MM                      `7MM          
#                             MM                                                                        MM     MM                        MM          
# `7MM  `7MMpMMMb.  ,pP"Ybd mmMMmm  ,6"Yb.  `7MMpMMMb.  ,p6"bo   .gP"Ya      `7MMpMMMb.pMMMb.  .gP"Ya mmMMmm   MMpMMMb.  ,pW"Wq.    ,M""bMM  ,pP"Ybd 
#   MM    MM    MM  8I   `"   MM   8)   MM    MM    MM 6M'  OO  ,M'   Yb       MM    MM    MM ,M'   Yb  MM     MM    MM 6W'   `Wb ,AP    MM  8I   `" 
#   MM    MM    MM  `YMMMa.   MM    ,pm9MM    MM    MM 8M       8M""""""       MM    MM    MM 8M""""""  MM     MM    MM 8M     M8 8MI    MM  `YMMMa. 
#   MM    MM    MM  L.   I8   MM   8M   MM    MM    MM YM.    , YM.    ,       MM    MM    MM YM.    ,  MM     MM    MM YA.   ,A9 `Mb    MM  L.   I8 
# .JMML..JMML  JMML.M9mmmP'   `Mbmo`Moo9^Yo..JMML  JMML.YMbmd'   `Mbmmd'     .JMML  JMML  JMML.`Mbmmd'  `Mbmo.JMML  JMML.`Ybmd9'   `Wbmd"MML.M9mmmP' 
#                                                                                                                                                    
#                                                                                                                                                    
# hello world

  def cast_vote(url)
    Vote.tabulate_vote(self.id, ShortenedUrl.find_by(long_url: url).id)
  end
    
end

# when we say has_many :visiteds, we are saying
# "hey, when someone wants to do an active record thing like MyClass.visiteds
# they must call it visiteds"

# now usually, there would be a visiteds_id and a class visited

# but since we are channging the names, we have to be explicit about
# which fields in the related table to look at
# in this case, we want the shortened_url_id from the visits table
# but in this case, we didn't say 'a visit belongs to a user' we said it belongs
# to a visitor (and in that association we specified where that was to look)
# so we say source: :visited, i.e. the information which indicates which visited
# the visit belongs to, i.e. the user_id
