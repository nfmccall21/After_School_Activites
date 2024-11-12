# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Registration.all.each do |registration|
  registration.destroy!
end

Activity.all.each do |activity|
  activity.destroy!
end

User.all.each do |user|
  user.destroy!
end

Student.all.each do |student|
  student.destroy!
end



a1 = Activity.new(title: 'Clay Club',
               description: 'Come join us for an hour to learn and play with clay! Students will learn to use a pottery wheel and sculpture techniques',
               spots: 7,
               chaperone: 'ms. M',
               approval_status: 0,
               day: 2,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('4 pm').to_time)
a1.save!

a2 = Activity.new(title: 'Gardening Club',
               description: 'Develop a green thumb and get your own area in the school garden to raise a plant of your own! Students willb ebal eot grow fruits/veg as well as flowers and seeds will be provided',
               spots: 20,
               chaperone: 'mr. G',
               approval_status: 1,
               day: 4,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a2.save!

a3 = Activity.new(title: 'Spanish Club',
               description: 'Join other students in learning more Spanish outside of class, as well as engaging in cultural learning. Students will practice converstaion in a fun and engaging space',
               spots: 15,
               chaperone: 'ms. S',
               approval_status: 2,
               day: 3,
               time_start: DateTime.parse('4 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a3.save!


a4 = Activity.new(title: 'Baking Club',
               description: 'Students will use the home ec space to bake a new fun treat each week!',
               spots: 10,
               chaperone: 'mr. B',
               approval_status: 0,
               day: 1,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a4.save!

a5 = Activity.new(title: 'Games Club',
               description: 'Come play! Each week we will alternate between board games and video games',
               spots: 25,
               chaperone: 'ms. V',
               approval_status: 1,
               day: 0,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a5.save!

a6 = Activity.new(title: 'Meditation Club',
               description: 'Students will be able to spend 30 min learning about and practicing meditation',
               spots: 23,
               chaperone: 'ms.M',
               approval_status: 1,
               day: 3,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('3:30 pm').to_time)
a6.save!

# USERS
User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
User.create!(email: 'teacher@colgate.edu', password: 'testing', role: :teacher)
User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent)

# STUDENTS
s1 = Student.new(firstname: 'Anna', lastname: 'Lieb', grade: 2, homeroom: "homeroom1")
s1.save!
s2 = Student.new(firstname: 'Julia', lastname: 'Goosay', grade: 6, homeroom: "homeroom2")
s2.save!
s3 = Student.new(firstname: 'Greta', lastname: 'Hoogstra', grade: 1, homeroom: "homeroom3")
s3.save!
s4 = Student.new(firstname: 'Natalie', lastname: 'Mccall', grade: 3, homeroom: "homeroom4")
s4.save!


# REGISTRATIONS
r1 = Registration.new(student: s1, activity: a1, status: 1,requested_registration_at: Time.now ,registration_update_at: Time.now )
r1.save!







