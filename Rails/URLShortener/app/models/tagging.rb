# == Schema Information
#
# Table name: taggings
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :bigint
#  tag_topic_id     :bigint
#
# Indexes
#
#  index_taggings_on_shortened_url_id  (shortened_url_id)
#  index_taggings_on_tag_topic_id      (tag_topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (shortened_url_id => shortened_urls.id)
#  fk_rails_...  (tag_topic_id => tag_topics.id)
#
class Tagging < ApplicationRecord
  belongs_to :tag_topic
  belongs_to :shortened_url
end
