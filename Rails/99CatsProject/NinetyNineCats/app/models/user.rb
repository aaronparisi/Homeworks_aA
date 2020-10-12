# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :name, :email, presence: :true
  validates :email, uniqueness: true

  has_many :rental_requests, dependent: :destroy
  has_many :cats, through: :rental_requests
end
