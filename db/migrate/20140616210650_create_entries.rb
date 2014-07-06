class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :user
      t.references :site
      t.string :date
      t.timestamps
    end
  end
end
