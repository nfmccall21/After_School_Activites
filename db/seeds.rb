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
               approval_status: :Approved,
               day: :Wednesday,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('4 pm').to_time)
a1.save!

a2 = Activity.new(title: 'Gardening Club',
               description: 'Develop a green thumb and get your own area in the school garden to raise a plant of your own! Students willb ebal eot grow fruits/veg as well as flowers and seeds will be provided',
               spots: 20,
               chaperone: 'mr. G',
               approval_status: :Pending,
               day: :Friday,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a2.save!

a3 = Activity.new(title: 'Spanish Club',
               description: 'Join other students in learning more Spanish outside of class, as well as engaging in cultural learning. Students will practice converstaion in a fun and engaging space',
               spots: 15,
               chaperone: 'ms. S',
               approval_status: :Denied,
               day: :Thursday,
               time_start: DateTime.parse('4 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a3.save!


a4 = Activity.new(title: 'Baking Club',
               description: 'Students will use the home ec space to bake a new fun treat each week!',
               spots: 10,
               chaperone: 'mr. B',
               approval_status: :Approved,
               day: :Tuesday,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a4.save!

a5 = Activity.new(title: 'Games Club',
               description: 'Come play! Each week we will alternate between board games and video games',
               spots: 25,
               chaperone: 'ms. V',
               approval_status: :Pending,
               day: :Monday,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a5.save!

a6 = Activity.new(title: 'Meditation Club',
               description: 'Students will be able to spend 30 min learning about and practicing meditation',
               spots: 23,
               chaperone: 'ms.M',
               approval_status: :Pending,
               day: :Thursday,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('3:30 pm').to_time)
a6.save!

# MORE ACTIVITIES

# APPROVED activities
aa1 = Activity.new()
aa2 = Activity.new()
aa3 = Activity.new()
aa4 = Activity.new()
aa5 = Activity.new()
aa6 = Activity.new()
approvedactssarr = [aa1, aa2, aa3, aa4, aa5, aa6]
1.upto(6) do |i|
  puts "Creating Approved Club #{i}"
  approvedactssarr[i-1] = Activity.create!(title: "Approved Club #{i} ",
        description: "This is the description for Approved Club #{i}. There would normally be more text and words here but I dont know what to write. Basically just know that this actvity is super cool! And its approved!",
        spots: 5,
        chaperone: 'testchap',
        approval_status: :Approved,
        day: rand(0..4),
        time_start: DateTime.parse('3 pm').to_time,
        time_end: DateTime.parse('3:30 pm').to_time)
end

# PENDING activities
ap1 = Activity.new()
ap2 = Activity.new()
ap3 = Activity.new()
ap4 = Activity.new()
ap5 = Activity.new()
ap6 = Activity.new()
pendingactssarr = [ap1, ap2, ap3, ap4, ap5, ap6]
1.upto(6) do |i|
  puts "Creating Pending Club #{i}"
  pendingactssarr[i-1] = Activity.create!(title: "Pending Club #{i} ",
        description: "This is the description for Pending Club #{i}. There would normally be more text and words here but I dont know what to write. Basically just know that this actvity is super cool! But it is not approved!",
        spots: 5,
        chaperone: 'testchap',
        approval_status: :Pending,
        day: rand(0..4),
        time_start: DateTime.parse('3 pm').to_time,
        time_end: DateTime.parse('3:30 pm').to_time)
end

# DENIED activities
ad1 = Activity.new()
ad2 = Activity.new()
ad3 = Activity.new()
ad4 = Activity.new()
ad5 = Activity.new()
ad6 = Activity.new()
deniedactssarr = [ad1, ad2, ad3, ad4, ad5, ad6]
1.upto(6) do |i|
  puts "Creating Denied Club #{i}"
  deniedactssarr[i-1] = Activity.create!(title: "Denied Club #{i} ",
        description: "This is the description for Denied Club #{i}. There would normally be more text and words here but I dont know what to write. Basically just know that this club got denied for a reason so booohoooo you cant join go cry about it.",
        spots: 5,
        chaperone: 'testchap',
        approval_status: :Pending,
        day: rand(0..4),
        time_start: DateTime.parse('3 pm').to_time,
        time_end: DateTime.parse('3:30 pm').to_time)
end







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
r1 = Registration.new(student: s1, activity: a1, status: :Enrolled,requested_registration_at: Time.now ,registration_update_at: Time.now )
r1.save!

r2 = Registration.new(student: s2, activity: a4, status: :Enrolled,requested_registration_at: Time.now ,registration_update_at: Time.now )
r2.save!

r3 = Registration.new(student: s2, activity: a1, status: :Waitlist,requested_registration_at: Time.now ,registration_update_at: Time.now )
r3.save!

r4 = Registration.new(student: s3, activity: a1, status: :Enrolled,requested_registration_at: Time.now ,registration_update_at: Time.now )
r4.save!

r5 = Registration.new(student: s4, activity: a3, status: :Enrolled,requested_registration_at: Time.now ,registration_update_at: Time.now )
r5.save!






