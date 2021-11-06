class RemoveColumnsFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :prefecture1_id, :integer
    remove_column :users, :prefecture2_id, :integer
  end
end
