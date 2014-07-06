class CreateUserHours < ActiveRecord::Migration
  def change
    create_table :user_hours do |t|
      t.references :entry
      t.references :category
      t.references :subcategory
      t.float :recorded_hours
      t.float :valid_hours
      t.timestamps
    end
  end
end
