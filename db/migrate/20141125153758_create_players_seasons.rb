class CreatePlayersSeasons < ActiveRecord::Migration
  def change
    create_table :players_seasons do |t|
      t.integer :player_id
      t.integer :season_id
      t.boolean :fees_paid
      t.boolean :skins_paid
      t.timestamps
    end
  end
end
