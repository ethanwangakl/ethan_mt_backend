class CreateAdminUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_users do |t|
      t.string :username, null: false, limit: 64
      t.string :password_digest, null: false, limit: 256

      t.timestamps
    end
  end
end
