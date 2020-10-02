# == Schema Information
#
# Table name: answer_choices
#
#  id          :integer          not null, primary key
#  text        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer
#
# Indexes
#
#  index_answer_choices_on_question_id  (question_id)
#
class AnswerChoice < ApplicationRecord
  validates :text, presence: true, uniqueness: { scope: :question, message: "already exists for this question"}

  belongs_to :question, class_name: :Question, foreign_key: :question_id
  has_many :responses
  has_many :respondents, through: :responses, class_name: :User, foreign_key: :respondent_id
end
