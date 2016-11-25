class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :course_rating
      t.integer :slope_rating
      t.integer :tee_box_id
      t.string :type
      t.timestamps
    end
  end
end
