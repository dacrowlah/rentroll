class ChangeTimestampsToStringForSqlite < ActiveRecord::Migration[7.1]
  def change
    change_column :rent_rolls, :move_in, :string
    change_column :rent_rolls, :move_out, :string
  end
end
