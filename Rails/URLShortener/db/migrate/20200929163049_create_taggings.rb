class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.references :tag_topic, foreign_key: true
      t.references :shortened_url, foreign_key: true

      t.timestamps
    end
  end
end
