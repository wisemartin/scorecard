class CreateHandicappingMethods < ActiveRecord::Migration
  def change
    create_table :handicapping_methods do |t|
      t.integer :number_used
      t.integer :number_considered
      t.integer :handicap_percent
      t.boolean :use_ratings
      t.integer :minimum_considered
      t.boolean :exclude_extremes
      t.integer :season_id
      t.boolean :use_usga_schedule
      t.boolean :ignore_unopposed_rounds
      t.float   :max_handicap
      t.boolean :allow_positive_handicap
      t.boolean :use_stats_for_hole_handicap
      t.boolean :callaway
      t.boolean :rollover_season
      t.boolean :limit_to_max_hole_score
      t.integer :callaway_percent
      t.integer :rollover_number_weeks
      t.boolean :use_stats_for_hole_handicap
      t.boolean :limit_to_max_hole_score
      t.integer :max_hole_score_type
      t.integer :max_hole_score_amount
      t.timestamps
    end
  end


end
