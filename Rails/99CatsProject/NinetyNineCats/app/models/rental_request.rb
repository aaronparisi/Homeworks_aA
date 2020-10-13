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

  def approve!
    ActiveRecord::Base.transaction do
      self.update(status: 'APPROVED')
  
      self.overlapping_pending_requests.each { |req| req.deny! }
    end
  end
  
  def deny!
    self.update(status: 'DENIED')
  end

  def end_date_after_start_date
    unless self.end_date >= self.start_date
      errors.add(:end_date, "End Date must be on or after Start Date")
    end
  end
  
  def cat_is_available
    if self.status == 'APPROVED' && ! self.overlapping_approved_requests.empty?
      errors.add(:cat_id, "This cat is not available for the requested period")
    end
  end  

  def overlapping_requests
    RentalRequest
      .where(cat_id: cat_id)
      .where(
        "? < start_date and ? > start_date OR ? BETWEEN start_date and end_date", 
        self.start_date, 
        self.end_date,
        self.start_date
      )
      .where.not('id = ?', self.id)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end
  
  
  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end
  
end
