class ChangeStatusOfPostComments < ActiveRecord::Migration[5.2]
  def change
    change_column :post_comments, :evaluation, :float, default: 0
  end
end
