require 'byebug'

# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint           not null, primary key
#  long_url   :string
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_shortened_urls_on_user_id  (user_id)
#
require 'securerandom'

class ShortenedUrl < ApplicationRecord
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true
  validate :no_spamming
  validate :non_premium_max, unless: -> { self.submitter.premium }

  belongs_to :submitter, class_name: :User, foreign_key: :user_id

  has_many :visits, dependent: :destroy
  has_many :visitors, -> { distinct }, through: :visits, source: :visitor
  # has_many :visitors, through: :visits, source: :visitor

  has_many :taggings, dependent: :destroy
  has_many :tag_topics, through: :taggings

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


  def self.create_short_url(user, long)
    # takes User object and long as a string
    self.create!(short_url: self.random_code(), long_url: long, user_id: user.id)
  end
  

  def self.random_code()
    ret = SecureRandom.urlsafe_base64(16)
    until ! ShortenedUrl.exists?(short_url: ret)
      ret = SecureRandom.urlsafe_base64(16)
    end

    ret
  end

  def self.prune()
    # unpopular means it has been clicked, but not recently enough
    ids_to_destroy = ShortenedUrl.all.to_a.select(&:qualifies?).map { |url| url.id }
    ShortenedUrl.destroy(ids_to_destroy)
  end

  def qualifies?()
    mins = 600
    myVisits = self.visits
    myVisits.empty? ? self.abandoned?(mins) : self.unpopular?(myVisits, mins)
  end

  def abandoned?(mins)
    # return true if there are NO visits and if self is too old
    self.created_at < (Time.now - mins)
  end

  def unpopular?(myVisits, mins)
    # return true if no visits happened recently enough
    myVisits.order(:created_at).none? { |visit| visit.created_at > (Time.now - mins) }
  end
  

  

  # 
#                                                                                                                                       
#                      ,,                                                                         ,,                        ,,          
#                    `7MM                mm            mm                                  mm   `7MM                      `7MM          
#                      MM                MM            MM                                  MM     MM                        MM          
# `7MM  `7MM  `7Mb,od8 MM      ,pP"Ybd mmMMmm  ,6"Yb.mmMMmm     `7MMpMMMb.pMMMb.  .gP"Ya mmMMmm   MMpMMMb.  ,pW"Wq.    ,M""bMM  ,pP"Ybd 
#   MM    MM    MM' "' MM      8I   `"   MM   8)   MM  MM         MM    MM    MM ,M'   Yb  MM     MM    MM 6W'   `Wb ,AP    MM  8I   `" 
#   MM    MM    MM     MM      `YMMMa.   MM    ,pm9MM  MM         MM    MM    MM 8M""""""  MM     MM    MM 8M     M8 8MI    MM  `YMMMa. 
#   MM    MM    MM     MM      L.   I8   MM   8M   MM  MM         MM    MM    MM YM.    ,  MM     MM    MM YA.   ,A9 `Mb    MM  L.   I8 
#   `Mbod"YML..JMML. .JMML.    M9mmmP'   `Mbmo`Moo9^Yo.`Mbmo    .JMML  JMML  JMML.`Mbmmd'  `Mbmo.JMML  JMML.`Ybmd9'   `Wbmd"MML.M9mmmP' 
#                                                                                                                                       
#                                                                                                                                       
# 


  def num_clicks
    # returns the number of times this url has been clicked on (visited)
    self.visits.count
  end

  def num_uniques
    # returns the number of DISTINCT users who have clicked on (visited)
    # self.visits.select(:user_id).distinct.count
    self.visitors.count
  end

  def num_recent_clicks(t=300) # default 5 mins
    # timeThresh = (Time.now - t).to_time.to_i
    # self.visits.where(["#{timeThresh} <= ?", created_at.to_time.to_i]).count
    timeThresh = (Time.now - t)
    self.visits.where("created_at > ?", timeThresh).count
  end
  
  def num_recent_uniques(t=300) # default 5 mins
    timeThresh = (Time.now - t).to_time.to_i
    self.visitors.where("created_at > ?", timeThresh).count
  end

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


  def non_premium_max(m=5)
    if self.submitter.shortened_urls.count > m
      self.errors.add(
        :user_id,
        "non-premium users can only submit #{m} urls for shortening"
      )
    end
  end

  def no_spamming(time_lim=60, num_allowed=100) # 1 minute
    timeThresh = (Time.now - time_lim)
    if over_hasty(timeThresh, num_allowed)
      self.errors.add(
        :user_id, 
        "can't make more than #{num_allowed} submissions in #{time_lim}"
      )
    end
  end
  
  def over_hasty(timeThresh, num_allowed)
    ShortenedUrl.where("created_at > ?", timeThresh)
    .where(user_id: self.user_id)
    .count > num_allowed
  end
  
end
