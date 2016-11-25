class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :hole_id
      t.integer :score
      t.integer :round_id
      t.timestamps
    end
  end
end
