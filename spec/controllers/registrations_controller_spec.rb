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

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }
  let(:student) do
    student = Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: 'homeroom 4')
    student.users << parent
    student
  end
  let(:activity) do
    Activity.create!(
      title: 'Games Club',
      description: 'Come play! Each week we will alternate between board games and video games',
      spots: 2,
      chaperone: 'Ms. V',
      approval_status: :Pending,
      day: :Monday,
      time_start: DateTime.parse('3 pm').to_time,
      time_end: DateTime.parse('5 pm').to_time
    )
  end

  let!(:existing_registration) do
    Registration.create!(student_id: student.id, activity_id: activity.id, status: :Waitlist)
  end

  let(:registration) { existing_registration }

  describe 'GET #new' do
    context 'when the user is a parent' do
      before do
        sign_in parent
      end

      it 'assigns a new registration and lists students' do
        get :new
        expect(assigns(:registration)).to be_a_new(Registration)
        expect(assigns(:students)).to match_array(parent.students)
        expect(response).to render_template(:new)
      end
    end

    context 'when the user is not a parent' do
      let(:non_parent) { User.create!(email: 'user@test.com', password: 'password', role: :student) }

      before do
        sign_in non_parent
      end

      it 'redirects to the root path with an alert' do
        get :new
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You are not authorized to register students.')
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in parent
    end

    context 'when spots are available' do
      it 'creates a registration with status Enrolled' do
        post :create, params: { registration: { student_id: student.id } }
        registration = Registration.last

        expect(registration.status).to eq('Enrolled')
        expect(flash[:notice]).to eq("Successfully registered with status: Enrolled!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when spots are full but waitlist is available' do
      before do
        activity.spots.times do
          other_student = Student.create!(firstname: 'Student', lastname: 'Full', grade: 3, homeroom: 'Homeroom')
          activity.registrations.create!(student_id: other_student.id, status: :Enrolled)
        end
      end

      it 'creates a registration with status Waitlist' do
        post :create, params: { registration: { student_id: student.id } }
        registration = Registration.last

        expect(registration.status).to eq('Waitlist')
        expect(flash[:notice]).to eq("Successfully registered with status: Waitlist!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when both spots and waitlist are full' do
      before do
        activity.spots.times do
          other_student = Student.create!(firstname: 'Student', lastname: 'Full', grade: 3, homeroom: 'Homeroom')
          activity.registrations.create!(student_id: other_student.id, status: :Enrolled)
        end
        35.times do
          waitlist_student = Student.create!(firstname: 'Waitlist', lastname: 'Student', grade: 3, homeroom: 'Homeroom')
          activity.registrations.create!(student_id: waitlist_student.id, status: :Waitlist)
        end
      end

      it 'creates a registration with status Denied' do
        post :create, params: { registration: { student_id: student.id } }
        registration = Registration.last

        expect(registration.status).to eq('Denied')
        expect(flash[:notice]).to eq("Successfully registered with status: Denied!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when registration fails to save' do
      it 'renders the new template with an error message' do
        post :create, params: { registration: { student_id: nil } }

        expect(flash[:alert]).to eq('There was an error with your registration.')
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in parent
    end

    let!(:registration_to_destroy) do
      Registration.create!(student_id: student.id, activity_id: activity.id, status: :Enrolled)
    end

    context 'when format is turbo_stream' do
      it 'removes the registration and renders turbo_stream' do
        delete :destroy, params: { id: registration_to_destroy.id }, as: :turbo_stream

        expect { Registration.find(registration_to_destroy.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      end
    end

    context 'when format is html' do
      it 'removes the registration and redirects to the student path' do
        delete :destroy, params: { id: registration_to_destroy.id }

        expect { Registration.find(registration_to_destroy.id) }.to raise_error(ActiveRecord::RecordNotFound)
        expect(response).to redirect_to(student_path(registration_to_destroy.student_id))
      end
    end
  end
end
