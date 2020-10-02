class CreateAnswerChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_choices do |t|
      t.string :text
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
