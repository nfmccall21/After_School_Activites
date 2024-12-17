# require 'rails_helper'

# RSpec.describe RegistrationsController, type: :controller do
#   let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }
#   let(:student) do
#     student = Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: 'homeroom 4')
#     student.users << parent
#     student
#   end
#   let(:activity) do
#     Activity.create!(title: 'Games Club', description: 'Come play! Each week we will alternate between board games and video games', spots: 2, chaperone: 'Ms. V',
#       approval_status: :Pending,
#       day: :Monday,
#       time_start: DateTime.parse('3 pm').to_time,
#       time_end: DateTime.parse('5 pm').to_time
#     )
#   end

#   let!(:existing_registration) do
#     Registration.create!(student_id: student.id, activity_id: activity.id, status: :Waitlist)
#   end

#   let(:registration) { existing_registration }

#   describe 'POST #approve' do
#     context 'when spots are available' do
#       it 'approves the registration and shows a success notice' do
#         post :approve, params: { id: registration.id }
#         registration.reload

#         expect(registration.status).to eq('Enrolled')
#         expect(flash[:notice]).to eq('Registration approved successfully.')
#       end
#     end

#     context 'when the student is already enrolled' do
#       before do
#         existing_registration.update!(status: :Enrolled)
#       end
    
#       it 'does not approve the registration and shows a notice' do
#         post :approve, params: { id: registration.id }
#         registration.reload
    
#         expect(flash[:notice]).to eq('Student is already enrolled in this activity.')
#         expect(registration.status).to eq('Enrolled')
#       end
#     end

#     context 'when spots are full' do
#       before do
#         activity.spots.times do
#           new_student = Student.create!(firstname: 'Nicholas', lastname: 'McCall', grade: 4, homeroom: 'homeroom 5')
#           Registration.create!(student_id: new_student.id, activity_id: activity.id, status: :Enrolled)
#         end
#       end
    
#       it 'does not approve the registration and shows a notice' do
#         post :approve, params: { id: registration.id }
#         registration.reload
    
#         expect(flash[:notice]).to eq('This activity is full')
#         expect(registration.status).not_to eq('Enrolled')
#       end
#     end
#   end

#   describe 'POST #decline' do
#     it 'denies the registration and shows a notice' do
#       patch :decline, params: { id: registration.id }
#       registration.reload

#       expect(flash[:notice]).to eq('Registration has been declined.')
#       expect(registration.status).to eq('Denied')
#     end
#   end
# end
