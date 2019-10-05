class CreatePosts < ActiveRecord::Migration[5.2]
  def change
     create_table :posts do |t|
      t.integer :budget
      t.integer :cost
      t.integer :user_id
      t.string :comment
      t.string :result
      t.timestamps null: false
     end
  end
end
