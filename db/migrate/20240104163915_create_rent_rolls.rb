class CreateRentRolls < ActiveRecord::Migration[7.1]
  def change
    create_table :rent_rolls do |t|
      t.integer :unit
      t.string :floor_plan
      t.string :resident
      t.date :move_in
      t.date :move_out

      t.timestamps
    end
  end
end
