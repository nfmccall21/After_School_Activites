class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.integer :grade
      t.string :homeroom

      t.timestamps
    end
  end
end
