class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.column :name, :string
      t.column :season_id, :integer
      t.timestamps
    end
    add_index :divisions, :season_id
  end
end
