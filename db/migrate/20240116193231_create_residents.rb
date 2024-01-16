class CreateResidents < ActiveRecord::Migration[7.1]
  def change
    create_table :residents do |t|
      t.string :name
      t.string :ssn

      t.timestamps
    end

    add_column :rent_rolls, :resident_id, :integer
    remove_column :rent_rolls, :resident, :string
  end
end
