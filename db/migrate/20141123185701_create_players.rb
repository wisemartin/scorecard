class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :home_address
      t.string :city
      t.string :state_or_province
      t.string :country
      t.string :gender
      t.timestamps
    end
    add_index :players, :email, :unique=>true
  end

  def down
  end
end
