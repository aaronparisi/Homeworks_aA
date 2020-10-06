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

  def incomplete_polls
    # returns polls where this user responded to SOME, but not all, of the q's
    
    Poll # we don't keep polls w no questions
      .joins(questions: :answer_choices) # we don't keep questions w no possible choices
      .joins('left outer join responses on answer_choices.id = responses.answer_choice_id')
      .where('responses.respondent_id = ? or responses.respondent_id is null', self.id)
      .group('polls.id')
      .having('count(distinct questions.id) > count(responses.id)')
      .having('count(responses.id > 0)') # the user must have answered at least one of the questions
  end
  
  def pollStatus
    # I want a method which will return all the information for this user for each poll
    # ideally with only 1 sql query
    # I don't think it's possible to do it with 1 query
    # or rather, we can just basically grab the entire database
    # and then have to sort of run computations and aggregations on that 
    allInfo = Poll # we don't keep polls w no questions
      .includes(:questions)
      .joins(:answer_choices) # we don't keep questions w no possible choices
      .joins('left outer join responses on answer_choices.id = responses.answer_choice_id')
      .where('responses.respondent_id = ? or responses.respondent_id is null', self.id)


    pollInfo(poll)
  end

  def pollInfo(poll)
    # returns a hash 
    # { 
    #   title: "a poll's title",
    #   unanswered_questions: [
    #     "a list",
    #     "of question text's",
    #     "that this user has not completed"
    #   ]
    # }
    ret = {}
    ret[title] = poll.title
    ret[unanswered_questions] = []

    ret
    
  end
  
  
  def completed_polls
    # returns a list of polls for which this user has answered ALL questions
    Poll # we don't keep polls w no questions
      .joins(questions: :answer_choices) # we don't keep questions w no possible choices
      .joins('left outer join responses on answer_choices.id = responses.answer_choice_id')
      .where('responses.respondent_id = ?', self.id)
      .group('polls.id')
      .having('count(questions.id) = count(responses.id)')

      # Poll
      # .joins(:questions)
      # .joins('left outer join answer_choices on questions.id = answer_choices.question_id')
      # .joins('left outer join responses on answer_choices.id = responses.answer_choice_id')
      # .group('polls.id')
      # .having('responses.respondent_id = ?', self.id)
      # .having('count(questions.id) = count(responses.id)')
      # the issue is that the above says
      # "where 1. the respondent_id is the one we want, and"
      #  2. the TOTAL number of responses to that question is what we want"
      # RATHER than "the total number of responses BY THAT USER"
      # otherwise, kristin will not have "completed" a poll simply becasue
      # other people have ALSO submitted responses
=begin
    => all questions for a poll
    select p.*
    from polls p
    join questions q
    on p.id = q.poll_id

    => questions user has answered
    select q.*
    from questions q
    join question_choices qc on q.id = qc.question_id
    join responses r
    on qc.id = r.question_choice_id
    where r.respondent_id = #

    we want all the polls for which the number of responses BY A USER
    equals the number of total questions on the poll

    => questions per poll
    select p.*, count(q.*) as num_questions
    from polls p
    join questions q
    on p.id = q.poll_id
    group_by p.id

    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    select p.*
    from polls p
    join questions q on p.id = q.poll_id
    join answer_choices ac on q.id = ac.question_id
    join responses r on ac.id = r.question_choice_id
    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    select p.*
    from polls p
    "where number of question on that poll = number of responses on that poll by user X"

    select p.*
    from polls p
    join questions q
    on p.id = q.poll_id
    group by p.id
    having count(q.id) = (
      select count(r.id)
      from responses r
      join answer_choices aq
      on r.answer_choice_id = aq.id
      where r.respondent_id = 2
      and aq.question_id = 1
    );

    select * from responses r
    join answer_choices aq
    on r.answer_choice_id = aq.id
    where aq.question_id in (1, 2);

    ======================

    sql from executing completed polls on Kristin:
SELECT  "polls".title, questions.text, answer_choices.text
FROM "polls" 
INNER JOIN "questions" 
ON "questions"."poll_id" = "polls"."id" 
left outer join answer_choices on questions.id = answer_choices.question_id 
left outer join responses on answer_choices.id = responses.answer_choice_id 
GROUP BY polls.id 
HAVING (responses.respondent_id = 2) 
AND (count(questions.id) = count(responses.id)) LIMIT ?  [["LIMIT", 11]]

=end

  end
  
  
end


# Poll.joins(questions: :answer_choices).joins('left outer join responses on answer_choices.id = responses.answer_choice_id').where('responses.respondent_id = ?', self.id).group('polls.id').having('count(questions.id) > count(responses.id)').having('count(responses.id > 0)')
# select p.title, q.text, ac.text, count(distinct q.id) as num_questions, count(r.id) as num_responses_to_poll_by_user from polls p join questions q on p.id = q.poll_id join answer_choices ac on q.id = ac.question_id left outer join responses r on ac.id = r.answer_choice_id where r.respondent_id = 2 or r.respondent_id is null group by p.id having count(distinct q.id) > count(r.id);
# looks like we are losing questions who do NOT have responses by this user,
# thus the number of responses to the poll is NEVER greater than the number of responses by this particular user
# ok so we can make sure to keep anybody w responses w this user's id OR with id is null
# we also need to make sure we count DISTINCT question id's

=begin
select p.title, q.text, ac.text, u.username 
from polls p 
join questions q on p.id = q.poll_id 
join answer_choices ac on q.id = ac.question_id 
left outer join responses r on ac.id = r.answer_choice_id 
left outer join users u on r.respondent_id = u.id ;
=end