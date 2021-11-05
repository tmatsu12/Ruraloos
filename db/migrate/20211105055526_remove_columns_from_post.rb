class RemoveColumnsFromPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :body1, :text
    remove_column :posts, :body2, :text
    remove_column :posts, :body3, :text
  end
end
