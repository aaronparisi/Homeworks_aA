class Course < ApplicationRecord
  has_many :enrollments, foreign_key: :course_id
  has_many :enrolled_students, through: :enrollments, source: :student
  belongs_to :prerequisite, class_name: :Course, foreign_key: :prereq_id
end
