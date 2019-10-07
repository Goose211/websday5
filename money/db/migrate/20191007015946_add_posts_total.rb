class AddPostsTotal < ActiveRecord::Migration[5.2]
  def change
     add_column :posts, :total, :integer
  end
end
