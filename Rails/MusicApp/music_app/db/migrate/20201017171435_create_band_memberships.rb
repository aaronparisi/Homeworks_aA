class CreateBandMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :band_memberships do |t|
      t.references :band, foreign_key: true
      t.references :member, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
