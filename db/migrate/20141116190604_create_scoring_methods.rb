class CreateScoringMethods < ActiveRecord::Migration
  def change
    create_table :scoring_methods do |t|
      t.integer :season_id
      t.string :type
      t.integer :points_per_match
      t.text :description
      t.timestamps
    end
  end
end
