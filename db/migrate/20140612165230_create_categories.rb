class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :is_counselling
      t.float :requirement
      t.boolean :max
      t.integer :ref
      t.timestamps
    end
  end
end
