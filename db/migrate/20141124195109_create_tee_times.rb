class CreateTeeTimes < ActiveRecord::Migration
  def change
    create_table :tee_times do |t|
      t.datetime :tee_time
      t.string :group
      t.integer :starting_hole
      t.integer :season_id
      t.timestamps
    end
  end
end
