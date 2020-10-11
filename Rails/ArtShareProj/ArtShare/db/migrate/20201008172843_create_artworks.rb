class CreateArtworks < ActiveRecord::Migration[5.2]
  def change
    create_table :artworks do |t|
      t.string :title
      t.string :image_url
      t.references :artist, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
