class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.date :date
      t.integer :player_id
      t.integer :score_card_id
      t.integer :tee_box_id
      t.string :type
      t.float :points
      t.float :handicap
      t.timestamps
    end
  end
end
