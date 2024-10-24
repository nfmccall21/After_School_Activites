# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


a1 = Activity.new(title: 'Clay Club', 
               description: 'Come join us for an hour to learn and play with clay! Students will learn to use a pottery wheel and sculpture techniques',
               spots: 7,
               chaperone: 'ms. M', 
               approval_status: false,
               day: 2,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('4 pm').to_time)
a1.save!

a2 = Activity.new(title: 'Gardening Club', 
               description: 'Develop a green thumb and get your own area in the school garden to raise a plant of your own! Students willb ebal eot grow fruits/veg as well as flowers and seeds will be provided',
               spots: 20,
               chaperone: 'mr. G', 
               approval_status: true,
               day: 4,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a2.save!

a3 = Activity.new(title: 'Spanish Club', 
               description: 'Join other students in learning more Spanish outside of class, as well as engaging in cultural learning. Students will practice converstaion in a fun and engaging space',
               spots: 15,
               chaperone: 'ms. S', 
               approval_status: true,
               day: 3,
               time_start: DateTime.parse('4 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a3.save!


a4 = Activity.new(title: 'Baking Club', 
               description: 'Students will use the home ec space to bake a new fun treat each week!',
               spots: 10,
               chaperone: 'mr. B', 
               approval_status: false,
               day: 1,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a4.save!

a5 = Activity.new(title: 'Games Club', 
               description: 'Come play! Each week we will alternate between board games and video games',
               spots: 25,
               chaperone: 'ms. V', 
               approval_status: true,
               day: 5,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('5 pm').to_time)
a5.save!

a6 = Activity.new(title: 'Meditation Club', 
               description: 'Students will be able to spend 30 min learning about and practicing meditation',
               spots: 23,
               chaperone: 'ms.M', 
               approval_status: false,
               day: 3,
               time_start: DateTime.parse('3 pm').to_time,
               time_end: DateTime.parse('3:30 pm').to_time)
a3.save!