class CreateShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :shortened_urls do |t|
      t.string :short_url
      t.string :long_url
      t.references :user
      t.timestamps
    end
  end
end
