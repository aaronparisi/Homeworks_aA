class AddViewerReferenceToArtworkShares < ActiveRecord::Migration[5.2]
  def change
    add_reference :artwork_shares, :viewer, index: true, foreign_key: { to_table: :users }
  end
end
