# == Schema Information
#
# Table name: visits
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shortened_url_id :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_visits_on_shortened_url_id  (shortened_url_id)
#  index_visits_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (shortened_url_id => shortened_urls.id)
#  fk_rails_...  (user_id => users.id)
#
class Visit < ApplicationRecord
  belongs_to :visitor, class_name: 'User', foreign_key: :user_id
  belongs_to :visited, class_name: 'ShortenedUrl', foreign_key: :shortened_url_id

  def self.record_visit!(user, shortened_url)
    Visit.create(user_id: user.id, shortened_url_id: shortened_url.id)
  end
  
end
