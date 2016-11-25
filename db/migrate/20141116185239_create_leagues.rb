class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.column :name, :string
      t.column :domain_identifier, :string
      t.timestamps
    end
    add_index :leagues, :domain_identifier, :unique => true
    add_index :leagues, :name, :unique => true
  end
end
