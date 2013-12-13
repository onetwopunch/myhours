class AddIndicies < ActiveRecord::Migration
  def change
  	add_index :entries, ['user_id'], :name => 'index_entries_on_user_id'
    add_index :users, ["email"], :name => "index_users_on_email"
  end
end
