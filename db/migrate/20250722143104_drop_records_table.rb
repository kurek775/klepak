class DropRecordsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :records
  end
end
