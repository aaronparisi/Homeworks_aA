# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poll_id    :integer
#
# Indexes
#
#  index_questions_on_poll_id  (poll_id)
#
class Question < ApplicationRecord
  validates :text, presence: true, uniqueness: { scope: :poll, message: "has already been asked for this poll"}
  
  belongs_to :poll, class_name: :Poll, foreign_key: :poll_id
  has_one :author, through: :poll, class_name: :User, foreign_key: :author_id
  has_many :answer_choices
  has_many :responses, through: :answer_choices

  def n_plus_one_results
    myChoices = self.answer_choices
    
    results = {}
    myChoices.each do |choice|
      results[choice] = choice.responses.count
    end

    results
  end

  def include_results
    myChoices = self.answer_choices.includes(:responses)

    results = {}
    myChoices.each do |choice|
      results[choice] = choice.responses.length
    end

    results
  end
  
  def results
    retData = self.answer_choices
      .select('answer_choices.text as text, count(*) as result')
      .joins('left outer join responses on answer_choices.id = responses.answer_choice_id')
      .group(:id)

    ret = {}
    retData.each do |pair|
      ret[pair.text] = pair.result
    end

    ret

    # lessons
    # 1. the thing "retData" does not just "contain" the result of selecting 'result'
    #    in sql.  It is available as an ATTRIBUTE of the returned object.
    #    THAT's why we have to go through w each.
  end
  
end

=begin
  
a sql query to select this question's answer choices and the COUNTS of their responses

select answer_choices.*, COUNT(*) as response_count
from answer_choices AC
left join responses R
on AC.id = R.answer_choice_id
group by AC.id
  
=end
