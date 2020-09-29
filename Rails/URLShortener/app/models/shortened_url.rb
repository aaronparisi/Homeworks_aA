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

  belongs_to :submitter, class_name: :User, foreign_key: :user_id

  has_many :visits
  has_many :visitors, -> { distinct }, through: :visits, source: :visitor
  # has_many :visitors, through: :visits, source: :visitor

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

  def num_clicks
    # returns the number of times this url has been clicked on (visited)
    self.visits.count
  end

  def num_uniques
    # returns the number of DISTINCT users who have clicked on (visited)
    # self.visits.select(:user_id).distinct.count
    self.visitors.count
  end

  def num_recent_clicks(t)
    timeThresh = (Time.now - t).to_time.to_i
    self.visits.where(["#{timeThresh} <= ?", created_at.to_time.to_i]).count
  end
  

  def num_recent_uniques(t)
    timeThresh = (Time.now - t).to_time.to_i
    # returns the number of unique clicks within some time period (eg. 10 mins)
    # self.visits.where(["#{timeThresh} <= ?", created_at.to_time.to_i])
    #   .select(:user_id)
    #   .distinct
    #   .count
    self.visitors.where(["#{timeThresh} <= ?", created_at.to_time.to_i]).count
  end
  
  
end
