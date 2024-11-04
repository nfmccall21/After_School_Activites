class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.integer :spots
      t.string :chaperone
      t.integer :approval_status
      t.integer :day
      t.time :time_start
      t.time :time_end

      t.timestamps
    end
  end
end
