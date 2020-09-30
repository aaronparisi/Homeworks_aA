# == Schema Information
#
# Table name: votes
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_votes_on_shortened_url_id  (shortened_url_id)
#  index_votes_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shortened_url_id => shortened_urls.id)
#  fk_rails_...  (user_id => users.id)
#
class Vote < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: :shortened_url_id }
  validate :not_voting_on_own

  belongs_to :fan, class_name: :User, foreign_key: :user_id
  belongs_to :voted_on, class_name: :ShortenedUrl, foreign_key: :shortened_url_id

  # 
#                                                                                                                                                             
#                      ,,    ,,        ,,                  ,,                                                           ,,                        ,,          
#                    `7MM    db      `7MM           mm     db                                                    mm   `7MM                      `7MM          
#                      MM              MM           MM                                                           MM     MM                        MM          
# `7M'   `MF',6"Yb.    MM  `7MM   ,M""bMM   ,6"Yb.mmMMmm `7MM  ,pW"Wq.`7MMpMMMb.      `7MMpMMMb.pMMMb.  .gP"Ya mmMMmm   MMpMMMb.  ,pW"Wq.    ,M""bMM  ,pP"Ybd 
#   VA   ,V 8)   MM    MM    MM ,AP    MM  8)   MM  MM     MM 6W'   `Wb MM    MM        MM    MM    MM ,M'   Yb  MM     MM    MM 6W'   `Wb ,AP    MM  8I   `" 
#    VA ,V   ,pm9MM    MM    MM 8MI    MM   ,pm9MM  MM     MM 8M     M8 MM    MM        MM    MM    MM 8M""""""  MM     MM    MM 8M     M8 8MI    MM  `YMMMa. 
#     VVV   8M   MM    MM    MM `Mb    MM  8M   MM  MM     MM YA.   ,A9 MM    MM        MM    MM    MM YM.    ,  MM     MM    MM YA.   ,A9 `Mb    MM  L.   I8 
#      W    `Moo9^Yo..JMML..JMML.`Wbmd"MML.`Moo9^Yo.`Mbmo.JMML.`Ybmd9'.JMML  JMML.    .JMML  JMML  JMML.`Mbmmd'  `Mbmo.JMML  JMML.`Ybmd9'   `Wbmd"MML.M9mmmP' 
#                                                                                                                                                             
#                                                                                                                                                             
# 


  def not_voting_on_own
    if ShortenedUrl.find(self.shortened_url_id).user_id == self.user_id
      errors.add(:user_id, "Can't vote on your own url!")
    end
  end

  # 
#                                                                                                                   
#          ,,                                                                 ,,                        ,,          
#        `7MM                                                          mm   `7MM                      `7MM          
#          MM                                                          MM     MM                        MM          
#  ,p6"bo  MM   ,6"Yb.  ,pP"Ybd ,pP"Ybd     `7MMpMMMb.pMMMb.  .gP"Ya mmMMmm   MMpMMMb.  ,pW"Wq.    ,M""bMM  ,pP"Ybd 
# 6M'  OO  MM  8)   MM  8I   `" 8I   `"       MM    MM    MM ,M'   Yb  MM     MM    MM 6W'   `Wb ,AP    MM  8I   `" 
# 8M       MM   ,pm9MM  `YMMMa. `YMMMa.       MM    MM    MM 8M""""""  MM     MM    MM 8M     M8 8MI    MM  `YMMMa. 
# YM.    , MM  8M   MM  L.   I8 L.   I8       MM    MM    MM YM.    ,  MM     MM    MM YA.   ,A9 `Mb    MM  L.   I8 
#  YMbmd'.JMML.`Moo9^Yo.M9mmmP' M9mmmP'     .JMML  JMML  JMML.`Mbmmd'  `Mbmo.JMML  JMML.`Ybmd9'   `Wbmd"MML.M9mmmP' 
#                                                                                                                   
#                                                                                                                   
# 

  def self.tabulate_vote(user_id, url_id)
    self.create!(user_id: user_id, shortened_url_id: url_id)
  end
  
  
end
