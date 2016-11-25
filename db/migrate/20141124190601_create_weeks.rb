class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :schedule_id
      t.integer :course_id
      t.date :date
      t.timestamps
    end
  end
end
