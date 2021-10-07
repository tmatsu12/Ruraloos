class AddPrefectureRefToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :prefecture1, foreign_key: true
    add_reference :users, :prefecture2, foreign_key: true
  end
end
