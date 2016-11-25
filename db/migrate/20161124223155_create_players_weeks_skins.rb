class CreatePlayersWeeksSkins < ActiveRecord::Migration
  def change
    create_table :players_weeks_skins do |t|
      t.integer :players_season_id
      t.integer :week_id
      t.float :amount
      t.timestamps
    end
  end
end
