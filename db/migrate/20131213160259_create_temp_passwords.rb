class CreateTempPasswords < ActiveRecord::Migration
  def change
    create_table :temp_passwords do |t|
    	t.string :uuid
    	t.string :email
      t.timestamps
    end
  end
end
