require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }
  # let(:admin) { create(:user, email: 'admin@colgate.edu', password: 'testing', role: :admin) }
  # let(:teacher) { create(:user, email: 'teacher@colgate.edu', password: 'testing', role: :teacher) }
  let(:student) do
    student = Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: 'homeroom 4')
    student.users << parent
    student
  end
  let(:destroy_student) do
    student = Student.create!(firstname: 'Nicholas', lastname: 'McCall', grade: 5, homeroom: 'homeroom 1')
    student.users << parent
    student
  end
  let(:activity) do
    Activity.create!(title: 'Games Club', description: 'Come play! Each week we will alternate between board games and video games', spots: 2, chaperone: 'Ms. V',
      approval_status: :Pending,
      day: :Monday,
      time_start: DateTime.parse('3 pm').to_time,
      time_end: DateTime.parse('5 pm').to_time
    )
  end

  let!(:destroy_registration) do
    Registration.create!(
      student_id: destroy_student.id,
      activity_id: activity.id,
      status: :Enrolled,
      requested_registration_at: Time.now,
      registration_update_at: Time.now
    )
  end

  let!(:existing_registration) do
    Registration.create!(student_id: student.id, activity_id: activity.id, status: :Waitlist)
  end

  let(:registration) { existing_registration }

  describe 'POST #approve' do
    context 'when spots are available' do
      it 'approves the registration and shows a success notice' do
        post :approve, params: { id: registration.id }
        registration.reload

        expect(registration.status).to eq('Enrolled')
        expect(flash[:notice]).to eq('Registration approved successfully.')
      end
    end

    context 'when the student is already enrolled' do
      before do
        existing_registration.update!(status: :Enrolled)
      end
    
      it 'does not approve the registration and shows a notice' do
        post :approve, params: { id: registration.id }
        registration.reload
    
        expect(flash[:notice]).to eq('Student is already enrolled in this activity.')
        expect(registration.status).to eq('Enrolled')
      end
    end

    context 'when spots are full' do
      before do
        activity.spots.times do 
          new_student = Student.create!(firstname: 'student', lastname: 'name', grade: 5, homeroom: 'homeroom 1')
          Registration.create!(student_id: new_student.id, activity_id: activity.id, status: :Enrolled) 
        end
      end

      it 'does not approve the registration and shows a notice' do
        post :approve, params: { id: registration.id }
        registration.reload

        expect(flash[:notice]).to eq('This activity is full')
        expect(registration.status).not_to eq('Enrolled') 
      end
    end
  end

  describe 'POST #decline' do
    it 'denies the registration and shows a notice' do
      patch :decline, params: { id: registration.id }
      registration.reload

      expect(flash[:notice]).to eq('Registration has been declined.')
      expect(registration.status).to eq('Denied')
    end
  end

  describe "GET #new" do
    context "when the user is a parent" do
      before { sign_in parent }

      it "assigns @registration as a new Registration" do
        get :new
        expect(assigns(:registration)).to be_a_new(Registration)
      end

      it "assigns @students belonging to the current user" do
        get :new
        expect(assigns(:students)).to include(student)
      end
    end

    it "redirects to root path with an alert message if the user is not signed in" do
      get :new, params: { id: registration.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("You must be signed in to register.")
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is signed in' do
      let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }

      before do
        sign_in parent 
      end

      it 'destroys the registration and redirects to student path' do
        expect {
          delete :destroy, params: { id: destroy_registration.id }
        }.to change(Registration, :count).by(-1)

        expect(response).to redirect_to(student_path(destroy_student.id))
      end

      it 'responds to turbo_stream format' do
        expect {
          delete :destroy, params: { id: destroy_registration.id }, format: :turbo_stream
        }.to change(Registration, :count).by(-1) 

        # expect(response.body).to include('turbo-stream')
        expect(response.body).to include("remove_#{destroy_registration.id}")
      end
    end
  end

  describe 'POST #create' do
    before do
      sign_in parent
    end
    context 'when there are spots available in the activity' do
      it 'enrolls the student and redirects to the activity page' do
        expect {
          post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
        }.to change(Registration, :count).by(1)
        
        registration = Registration.last
        expect(registration.status).to eq('Enrolled')
        expect(flash[:notice]).to eq("Successfully registered with status: Enrolled!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when the activity is full but the waitlist has space' do
      it 'waitlists the student and redirects to the activity page' do
        expect {
          post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
        }.to change(Registration, :count).by(1)
        
        registration = Registration.last
        expect(registration.status).to eq('Waitlist')
        expect(flash[:notice]).to eq("Successfully registered with status: Waitlist!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when the activity is full and the waitlist is also full' do
      before do
        activity.spots.times do
          new_student = Student.create!(firstname: 'student', lastname: 'name', grade: 5, homeroom: 'homeroom 1')
          Registration.create!(student_id: new_student.id, activity_id: activity.id, status: :Enrolled)
        end
    
        35.times do
          new_student = Student.create!(firstname: 'student', lastname: 'name', grade: 5, homeroom: 'homeroom 1')
          Registration.create!(student_id: new_student.id, activity_id: activity.id, status: :Waitlist)
        end
    
        new_student = Student.create!(firstname: 'student', lastname: 'new', grade: 5, homeroom: 'homeroom 1')
        @new_registration = Registration.create!(student_id: new_student.id, activity_id: activity.id, status: :Pending)
      end

      it 'denies the registration and redirects to the activity page' do
        expect {
          post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
        }.to change(Registration, :count).by(0)
        
        expect(flash[:notice]).to eq("Successfully registered with status: Denied!")
        expect(response).to redirect_to(activity_path(activity))
      end
    end

    context 'when there is an error with the registration (e.g., validation failure)' do
      it 'does not create the registration and re-renders the new registration form' do
        allow_any_instance_of(Registration).to receive(:save).and_return(false)
        
        post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }

        expect(flash[:alert]).to eq("There was an error with your registration.")
        expect(response).to render_template(:new)
      end
    end
  end
end