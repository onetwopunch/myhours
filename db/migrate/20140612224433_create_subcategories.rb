class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.references :categories
      t.boolean :max
      t.string :name
      t.float :requirement
      t.timestamps
    end
  end
end
