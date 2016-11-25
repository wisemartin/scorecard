class CreatePlayerLeagueHandicaps < ActiveRecord::Migration
  def change
    create_table :player_league_handicaps do |t|
      t.integer :player_id
      t.integer :season_id
      t.float :handicap_index
      t.timestamps
    end
  end
end
