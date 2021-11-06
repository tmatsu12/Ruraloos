class CreateUserPrefectures < ActiveRecord::Migration[5.2]
  def change
    create_table :user_prefectures do |t|
      t.references :user, foreign_key: true
      t.references :prefecture, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
