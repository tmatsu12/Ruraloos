class AddColumnsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :evaluation, :float
    add_column :posts, :body1, :text
    add_column :posts, :body2, :text
    add_column :posts, :body3, :text
    add_column :posts, :city, :string
  end
end
