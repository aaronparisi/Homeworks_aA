require 'byebug'
# == Schema Information
#
# Table name: responses
#
#  id               :integer          not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  answer_choice_id :integer
#  respondent_id    :integer
#
# Indexes
#
#  index_responses_on_answer_choice_id  (answer_choice_id)
#  index_responses_on_respondent_id     (respondent_id)
#
class Response < ApplicationRecord
  validate :not_duplicate_response
  validate :not_answered_by_author
  # why can I create a response by aaron to the first poll?????

  belongs_to :respondent, class_name: :User, foreign_key: :respondent_id
  belongs_to :answer_choice
  has_one :question, through: :answer_choice
  # each response is tied to a single answer choice
  # and that answer choice belongs to a single question

  def self.build_response(user, answer_choice)
    Response.create(respondent_id: user.id, answer_choice_id: answer_choice.id)
  end

  def sibling_responses
    # should return all RESPONSES to this response's question's OTHER answer_choices
    # we need this so we can check if any of those responses have the current
    # respondent as THEIR respondent
    # self.question.answer_choices.responses.respondents # <- redundant, we have through associations
    self.question.responses.where.not(id: self.id)
    # we are making sure THIS response is not included
    # because duh, this response will have the same respondent_id...
  end
  
  def respondent_already_answered?
    # returns true if any of this response's sibling responses
    # have THIS response's respondent as THEIR respondent also
    self.sibling_responses.any? { |sib| sib.respondent_id == self.respondent_id }
  end
  
  def not_duplicate_response
    # returns true if the respondent has not answered the associated question yet
    # used to prevent a user submitting multiple responses for the same question
    # i.e. selecting multiple answer_choices (or selecting the same multiple times)
    if respondent_already_answered?
      errors.add(:respondent_id, "user already submitted an answer for this poll")
    end
  end

  def not_answered_by_author
    # returns true if this response's respondent (user) does NOT have the same
    # id as the response's question's poll's author (user)
    # respondent_id != self.question.author.id
    # ^^ I guess rails has a bug??

    # if respondent_id == self.answer_choice.question.poll.author.id
    #   errors.add(:respondent_id, "cannot submit answer to authored poll")
    # end
    # this works, but it makes THREE sql queries

    # unless Response
    #               .joins(:question)
    #               .joins(:poll)
    #               .where(polls: { author_id: self.respondent_id })
    #               .empty?
    #   errors.add(:respondent_id, "cannot submit answer to authored poll")
    # end
    # this is not the correct syntax for nested joins

    poll_author =  Poll.joins(questions: :answer_choices)
                        .where(answer_choices: { id: self.answer_choice_id })
                        .select(:author_id)
                        .first
                        .author_id

    if poll_author == self.respondent_id
        errors.add(:respondent_id, "cannot submit answer to authored poll; author: #{poll_author}")
    end

  end
  
end