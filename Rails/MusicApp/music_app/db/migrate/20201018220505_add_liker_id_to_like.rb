class AddLikerIdToLike < ActiveRecord::Migration[5.2]
  def change
    add_reference :likes, :liker, foreign_key: { to_table: :users }
  end
end
