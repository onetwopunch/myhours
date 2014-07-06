class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :user
      t.string :name
      t.string :address
      t.string :phone
      t.boolean :is_default_site
      t.timestamps
    end
  end
end
