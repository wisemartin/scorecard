class CreateMatchups < ActiveRecord::Migration
  def change
    create_table :matchups do |t|
      t.integer :week_id
      t.integer :home_team_id
      t.integer :visiting_team_id
      t.timestamps
    end
    add_index :matchups, :week_id
    add_index :matchups, :home_team_id
    add_index :matchups, :visiting_team_id
    add_index :matchups, [:week_id,:visiting_team_id,:home_team_id], :unique => true
  end
end
