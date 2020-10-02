# == Schema Information
#
# Table name: polls
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#
# Indexes
#
#  index_polls_on_author_id  (author_id)
#
class Poll < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  belongs_to :author, class_name: :User, foreign_key: :author_id
  has_many :questions, class_name: :Question, foreign_key: :poll_id
end
