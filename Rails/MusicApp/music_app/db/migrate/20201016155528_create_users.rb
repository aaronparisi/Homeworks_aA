class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, index: true, null: false, unique: true
      t.string :email, index: true, null: false, unique: true
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
