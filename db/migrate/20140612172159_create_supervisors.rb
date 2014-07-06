class CreateSupervisors < ActiveRecord::Migration
  def change
    create_table :supervisors do |t|
      t.references :site
      t.string :name
      t.string :phone
      t.string :email
      t.string :license_state
      t.string :license_type
      t.string :license_number
      t.timestamps
    end
  end
end
