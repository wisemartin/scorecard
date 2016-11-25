class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :city
      t.integer :state_id
      t.timestamps
    end
    add_index(:organizations, :state_id)
    add_column(:leagues, :organization_id,:integer)
    add_index(:leagues,:organization_id)

    create_table :organizations_players do |t|
      t.integer :organization_id
      t.integer :player_id
    end
  end
end
