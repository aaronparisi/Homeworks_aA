class ChangeAuthorIdIdInPolls < ActiveRecord::Migration[5.2]
  def change
    rename_column :polls, :author_id_id, :author_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
