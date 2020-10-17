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

  has_many :albums, dependent: :destroy
  has_many :tracks, through: :albums

  has_many :band_memberships, class_name: :BandMembership, foreign_key: :band_id
  has_many :members, through: :band_memberships

  def has_member?(user)
    self.members.pluck(:id).include?(user.id)
  end
  
end
