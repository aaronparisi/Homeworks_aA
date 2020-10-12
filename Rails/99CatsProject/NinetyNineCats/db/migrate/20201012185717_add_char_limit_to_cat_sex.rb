class AddCharLimitToCatSex < ActiveRecord::Migration[5.2]
  def change
    change_column :cats, :sex, :string, limit: 1
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
end
