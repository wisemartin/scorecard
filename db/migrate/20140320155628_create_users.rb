class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :role_id
      t.integer :league_id
      t.integer :player_id
      t.string :login_id, :limit=>200
      t.string :password_digest
      t.timestamps
    end
    add_index :users, :player_id
    add_index :users, :role_id
    add_index :users, :login_id, :unique => true
    add_index :users, [:league_id, :role_id, :player_id], :unique => true
  end
end
