# == Schema Information
#
# Table name: tag_topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TagTopic < ApplicationRecord
  has_many :taggings
  has_many :shortened_urls, through: :taggings

  def popular_links(n)
    myLinks = self.shortened_urls.sort_by(&:num_clicks).take(n)
  end
  
end
