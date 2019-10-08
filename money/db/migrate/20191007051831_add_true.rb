class AddTrue < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :task ,:boolean
  end
end
