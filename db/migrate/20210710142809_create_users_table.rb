class CreateUsersTable < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ''
      t.string :password_digest, null: false, default: ''

      t.string :username, null: false

      t.string :reset_password_token
      t.datetime :reset_token_expires_at

      t.boolean :locked, default: false
      t.bigint :failed_login_count, default: 0

      t.timestamps
    end

    add_index :users, :id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
