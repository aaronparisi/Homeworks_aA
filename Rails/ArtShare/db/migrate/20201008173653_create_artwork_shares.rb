class CreateArtworkShares < ActiveRecord::Migration[5.2]
  def change
    create_table :artwork_shares do |t|
      t.references :artist, index: true, foreign_key: { to_table: :users }
      t.references :artwork, foreign_key: true

      t.timestamps
    end
  end
end
