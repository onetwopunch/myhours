class AddEntryId < ActiveRecord::Migration
  def change
  	add_column :sites, :entry_id, :integer
  end
end
