class AddNotes < ActiveRecord::Migration
  def change
    add_column :entries, :note, :text
  end
end
