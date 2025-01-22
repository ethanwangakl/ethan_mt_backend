class CreateUserMoods < ActiveRecord::Migration[8.0]
  def change
    create_table :user_moods do |t|
      t.string :uuid, null: false, limit: 64
      t.string :username, null: false, limit: 64
      t.integer :mood, null: false
      t.string :comment, null: true, limit: 2046

      t.timestamps
    end

    add_index :user_moods, :uuid, unique: true
    add_index :user_moods, :username
  end
end
