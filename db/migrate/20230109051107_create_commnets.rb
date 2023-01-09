class CreateCommnets < ActiveRecord::Migration[6.1]
  def change
    create_table :commnets do |t|

      t.timestamps
    end
  end
end
