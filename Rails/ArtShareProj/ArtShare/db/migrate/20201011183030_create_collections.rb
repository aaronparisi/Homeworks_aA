class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :name
      t.references :artist, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
