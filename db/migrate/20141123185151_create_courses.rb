class CreateCourses < ActiveRecord::Migration
  def up
    create_table :courses do |t|
      t.string :name
      t.string :city
      t.string :state_or_province
      t.string :country
      t.boolean :private
      t.integer :user_id
      t.timestamps
    end
  end

  def down
  end
end
