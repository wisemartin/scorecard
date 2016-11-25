class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :name
      t.integer :league_id
      t.date :start_date
      t.date :end_date
      t.boolean :eighteen_holes
      t.boolean :limit_subs_to_roster
      t.integer :roster_size
      t.integer :number_playing_each_match
      t.timestamps
    end
    add_index :seasons, :league_id
  end
end
