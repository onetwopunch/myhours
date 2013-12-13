class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string "email", :limit => 100
    	t.string "password"
    	t.string "salt"
      t.timestamps
    end
  end
end
