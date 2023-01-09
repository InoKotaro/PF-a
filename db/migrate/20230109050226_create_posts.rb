class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.string :title, null: false, default: ""
      t.string :introduction, null: false, default: ""

      t.timestamps
    end
  end
end
