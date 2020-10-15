class AddSessionTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :session_token, :string, null: false
    add_index :users, :session_token, unique: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
