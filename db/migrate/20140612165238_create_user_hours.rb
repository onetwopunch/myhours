class CreateUserHours < ActiveRecord::Migration
  def change
    create_table :user_hours do |t|
      t.references :users
      t.references :categories
      t.float :recorded_hours
      t.float :valid_hours
      t.string :date
      t.timestamps
    end
  end
end
