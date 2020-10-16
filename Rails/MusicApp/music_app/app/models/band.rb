# == Schema Information
#
# Table name: bands
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bands_on_name  (name)
#
class Band < ApplicationRecord
  validates :name, presence: true

  has_many :albums
  has_many :tracks, through: :albums
end
