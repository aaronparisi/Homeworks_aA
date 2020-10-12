require 'action_view'

# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  description :text             not null
#  name        :string           not null
#  sex         :string(1)        not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  CAT_COLORS = ['black', 'brown', 'orange', 'gray']

  validates :birth_date, :color, :name, :sex, :description, presence: true
  validates :color, inclusion: CAT_COLORS
  validates :sex, inclusion: ['M', 'F']
  

  def age
    distance_of_time_in_words(self.birth_date, Time.now)
  end
  
end
