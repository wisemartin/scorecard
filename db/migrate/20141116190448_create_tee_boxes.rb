class CreateTeeBoxes < ActiveRecord::Migration
  def change
    create_table :tee_boxes do |t|
      t.integer :course_id
      t.string :name
      t.string :color
      t.timestamps
    end
  end
end
