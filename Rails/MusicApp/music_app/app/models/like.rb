# == Schema Information
#
# Table name: likes
#
#  id            :bigint           not null, primary key
#  likeable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  likeable_id   :bigint
#  liker_id      :bigint
#
# Indexes
#
#  index_likes_on_likeable_type_and_likeable_id  (likeable_type,likeable_id)
#  index_likes_on_liker_id                       (liker_id)
#
# Foreign Keys
#
#  fk_rails_...  (liker_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true
  belongs_to :liker, class_name: :User, foreign_key: :liker_id
end
