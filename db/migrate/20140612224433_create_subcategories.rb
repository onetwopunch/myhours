class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.references :category
      t.boolean :max
      t.string :name
      t.float :requirement
      t.integer :ref
      t.timestamps
    end
  end
end
