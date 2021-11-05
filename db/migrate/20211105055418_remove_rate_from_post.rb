class RemoveRateFromPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :evaluation, :float
  end
end
