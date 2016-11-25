class CreateScoreCards < ActiveRecord::Migration
  def change
    create_table :score_cards do |t|
      t.integer :matchup_id
      t.integer :team_id
      t.string :type
      t.timestamps
    end
  end
end
