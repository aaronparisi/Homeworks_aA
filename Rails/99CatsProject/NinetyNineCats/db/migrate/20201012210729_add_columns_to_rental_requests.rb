class AddColumnsToRentalRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :rental_requests, :start_date, :date, null: false
    add_column :rental_requests, :end_date, :date, null: false
    add_column :rental_requests, :status, :string, null: false, default: 'PENDING'
  end
end
