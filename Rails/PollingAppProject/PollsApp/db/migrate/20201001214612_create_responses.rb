class CreateResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.references :respondent, index: true, foreign_key: { to_table: :users }
      t.references :answer_choice, foreign_key: true

      t.timestamps
    end
  end
end
