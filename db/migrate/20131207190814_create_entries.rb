class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
    	t.string 'password'
    	t.string 'description'
    	t.string 'username'
    	t.boolean 'is_active', :default=>true
    	t.references :user
      t.timestamps 
    end
  end
end
