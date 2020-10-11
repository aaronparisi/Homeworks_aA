class CreateCollectionAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_assignments do |t|
      t.references :collection, foreign_key: true
      t.references :artwork, foreign_key: true

      t.timestamps
    end
  end
end
