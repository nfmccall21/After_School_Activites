class CreateRegistrations < ActiveRecord::Migration[7.2]
  def change
    create_table :registrations do |t|
      t.references :student, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.integer :status
      t.datetime :requested_registration_at
      t.datetime :registration_update_at

      t.timestamps
    end
  end
end
