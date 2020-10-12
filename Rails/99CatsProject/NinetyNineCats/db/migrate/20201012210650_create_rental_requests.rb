class CreateRentalRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :rental_requests do |t|
      t.references :cat, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
