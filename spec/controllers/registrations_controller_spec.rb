require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }
  let(:student) { Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: 'homeroom 4', users: [parent]) }
  let(:activity) { Activity.create!(title: 'Games Club', description: 'Board and video games', spots: 2, chaperone: 'Ms. V', approval_status: :Approved, day: :Monday, time_start: '3 pm'.to_time, time_end: '5 pm'.to_time) }
  let!(:registration) { Registration.create!(student: student, activity: activity, status: :Pending) }

  before { sign_in parent }

  describe 'POST #approve' do
    context 'when spots are available' do
      it 'approves the registration' do
        post :approve, params: { id: registration.id }
        registration.reload

        expect(registration.status).to eq('Enrolled')
        expect(flash[:notice]).to eq('Registration approved successfully.')
      end
    end

    # context 'when spots are full' do
    #   before do
    #     activity.spots.times { |i| Registration.create!(student: Student.create!(firstname: "Student #{i}", lastname: 'Test', grade: 3, homeroom: 'Room'), activity: activity, status: :Enrolled) }
    #   end

    #   it 'does not approve the registration' do
    #     post :approve, params: { id: registration.id }
    #     registration.reload

    #     expect(registration.status).to eq('Waitlist')
    #     expect(flash[:notice]).to eq('This activity is full.')
    #   end
    # end
  end

  describe 'POST #decline' do
    it 'declines the registration' do
      patch :decline, params: { id: registration.id }
      registration.reload

      expect(registration.status).to eq('Denied')
      expect(flash[:notice]).to eq('Registration has been declined.')
    end
  end

  describe 'GET #new' do
    it "renders the new registration form" do
      get :new, params: { activity_id: activity.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the registration' do
      expect {
        delete :destroy, params: { id: registration.id }
      }.to change(Registration, :count).by(-1)
    end
  end

  describe 'POST #create' do
    let(:student) { Student.create!(firstname: 'Test', lastname: 'Student', grade: 3, homeroom: 'Room') }
    let(:activity) { Activity.create!(title: 'Cooking Club', description: 'Cooking', spots: 5, chaperone: 'Ms. M', approval_status: :Approved, day: :Monday, time_start: '3 pm'.to_time, time_end: '5 pm'.to_time) }

    it 'enrolls the student' do
      initial_count = Registration.count
    
      post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
    
      final_count = Registration.count
      expect(final_count).to eq(initial_count)
    
      new_registration = Registration.last
      expect(new_registration.status).to eq('Enrolled')
      expect(new_registration.activity_id).to eq(activity.id)
      expect(flash[:notice]).to eq('Successfully registered with status: Enrolled!')
    end

    context 'when the activity is full' do
      before do
        activity.spots.times do |i|
          Registration.create!(
            student: Student.create!(firstname: "Student #{i}", lastname: 'Test', grade: 3, homeroom: 'Room'),
            activity: activity,
            status: :Enrolled
          )
        end
      end

      it 'adds the student to the waitlist' do
        expect {
          post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
        }.to change(Registration, :count).by(1)

        new_registration = Registration.last
        expect(new_registration.status).to eq('Waitlist')
        expect(new_registration.activity_id).to eq(activity.id)
        expect(flash[:notice]).to eq('Successfully registered with status: Waitlist!')
      end
    end

    context 'when the waitlist is full' do
      before do
        activity.spots.times do
          Registration.create!(
            student: Student.create!(firstname: 'Full', lastname: 'Enrolled', grade: 3, homeroom: 'Room'),
            activity: activity,
            status: :Enrolled
          )
        end
        35.times do
          Registration.create!(
            student: Student.create!(firstname: 'Full', lastname: 'Waitlist', grade: 3, homeroom: 'Room'),
            activity: activity,
            status: :Waitlist
          )
        end
      end

      it 'denies the registration' do
        expect {
          post :create, params: { activity_id: activity.id, registration: { student_id: student.id } }
        }.not_to change(Registration, :count)

        expect(flash[:notice]).to eq('Successfully registered with status: Denied!')
      end
    end
  end
end

