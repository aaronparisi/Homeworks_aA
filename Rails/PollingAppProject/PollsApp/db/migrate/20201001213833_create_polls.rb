class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.string :title
      t.references :author_id, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
