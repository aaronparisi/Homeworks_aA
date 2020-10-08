class AddTitleUniquenessIndexToArtworks < ActiveRecord::Migration[5.2]
  def change
    add_index :artworks, [:title, :artist_id], unique: true
    #Ex:- add_index("admin_users", "username")
  end
end
