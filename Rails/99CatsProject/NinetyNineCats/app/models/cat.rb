# == Schema Information
#
# Table name: cats
#
#  id          :bigint           not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  description :string           not null
#  name        :string           not null
#  sex         :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Cat < ApplicationRecord
  validates :birth_date, :color, :name, :sex, :description, presence: true
end
