class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_valid, :boolean, default: true, null: false #会員登録中はdefaultがtrue,退会後はfalse
  end
end
