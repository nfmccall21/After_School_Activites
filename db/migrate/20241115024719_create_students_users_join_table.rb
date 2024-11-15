class CreateStudentsUsersJoinTable < ActiveRecord::Migration[7.2]
  def change
    create_join_table :students, :users do |t|
      t.references 'students'
      t.references 'users'
      # t.index [:student_id, :user_id]
      # t.index [:user_id, :student_id]
    end
  end
end
