class CreateHoles < ActiveRecord::Migration
  def up
    create_table :holes do |t|
      t.integer :tee_box_id
      t.integer :par
      t.integer :handicap_index
      t.integer :number
      t.integer :length
      t.string :length_unit_of_measure
      t.timestamps
    end
    add_index :holes, :tee_box_id
    add_index :holes, [:handicap_index,:tee_box_id], :unique=>true
    add_index :holes, [:number,:tee_box_id], :unique=>true
  end

  def down
  end
end
