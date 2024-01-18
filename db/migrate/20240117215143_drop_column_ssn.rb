class DropColumnSsn < ActiveRecord::Migration[7.1]
  def change
    remove_column :residents, :ssn, :string
  end
end
