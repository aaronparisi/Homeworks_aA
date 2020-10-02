# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :authored_polls, class_name: :Poll, foreign_key: :author_id
  has_many :responses, class_name: :Response, foreign_key: :respondent_id
  has_many :answer_choices, through: :responses

  def cast_vote(answer_choice)
    Response.build_response(self, answer_choice)
  end
  
  
end
