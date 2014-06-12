class AddIndicies < ActiveRecord::Migration
  def change
    add_index :users, ["email"], :name => "index_users_on_email"
  end
end
