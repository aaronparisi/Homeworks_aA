# == Schema Information
#
# Table name: rental_requests
#
#  id         :bigint           not null, primary key
#  end_date   :date             not null
#  start_date :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cat_id     :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_rental_requests_on_cat_id   (cat_id)
#  index_rental_requests_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (cat_id => cats.id)
#  fk_rails_...  (user_id => users.id)
#
class RentalRequest < ApplicationRecord
  validates :end_date, :start_date, :status, presence: true
  validate :end_date_after_start_date
  validate :cat_is_available

  belongs_to :cat
  belongs_to :user

  private

  def end_date_after_start_date
    unless self.end_date >= self.start_date
      self[:end_date].errors.add("End Date must be on or after Start Date")
    end
  end
  
  def cat_is_available
    unless self.overlapping_requests.empty?
      self[:cat_id].errors.add("This cat is not available for the requested period")
    end
  end

  def overlapping_requests
    RentalRequest.where(cat_id: cat_id).to_a.filter { |rental| date_overlaps?(rental) }
  end
  
  def date_overlaps?(rental)
    # returns true if the given rental's dates do not overlap with self's
    self.start_date.between?(rental.start_date, rental.end_date) ||
    self.end_date.between?(rental.start_date, rental.end_date)
  end  
  
end
