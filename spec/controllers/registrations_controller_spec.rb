require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before(:each) do
    @parent = User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent)
    @student = Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: "homeroom 4")
    
    # Creating an activity
    @activity = Activity.create!(title: 'Games Club', description: 'Come play! Each week we will alternate between board games and video games', 
                                 spots: 25, chaperone: 'ms. V', approval_status: :Pending, day: :Monday, 
                                 time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('5 pm').to_time)
  end

  describe "GET #new" do
    context "when the user is a parent" do
      before(:each) do
        sign_in @parent
      end

      it "assigns a new registration and the student's list" do
        get :new, params: { activity_id: @activity_id.id }
        expect(assigns(:registration)).to be_a_new(Registration)
        expect(assigns(:students)).to eq([@student])
      end
    end

    context "when the user is not a parent" do
      it "redirects to the root path with an alert" do
        get :new, params: { activity_id: @activity_id.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("You are not authorized to view this page.")
      end
    end
  end

  describe "POST #create" do
    context "when the user is a parent" do
      before(:each) do
        sign_in @parent
      end

      it "registers a student and assigns the correct status" do
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: @student_id.id } }
        registration = Registration.last
        expect(registration.status).to eq("Pending")
        expect(registration.student).to eq(@student)
        expect(registration.activity).to eq(@activity)
      end

      it "adds a student to the waitlist if spots are full" do
        @activity.update!(spots: 1) # Make activity full
        second_student = Student.create!(firstname: 'John', lastname: 'Doe', grade: 4, homeroom: "homeroom 5")
        
        # Register the first student
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: @student_id.id } }
        
        # Now add the second student (should be waitlisted)
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: second_student_id.id } }
        waitlisted_registration = Registration.last
        expect(waitlisted_registration.status).to eq("Waitlist")
        expect(waitlisted_registration.student).to eq(second_student)
      end

      it "denies registration if the waitlist is full" do
        @activity.update!(spots: 1) # Make activity full
        second_student = Student.create!(firstname: 'John', lastname: 'Doe', grade: 4)
        third_student = Student.create!(firstname: 'Sally', lastname: 'Johnson', grade: 5)

        post :create, params: { activity_id: @activity_id.id, registration: { student_id: @student_id.id } }
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: second_student_id.id } }
        
        # Now, third student should be denied because waitlist is full
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: third_student_id.id } }
        denied_registration = Registration.last
        expect(denied_registration.status).to eq("Denied")
      end
    end
  end

  describe "PUT #approve" do
    context "when the activity has space" do
      before(:each) do
        sign_in @parent
        @activity.update!(spots: 25) # Make sure there are spots available
        @registration = Registration.create!(student: @student, activity: @activity)
      end

      it "approves the registration and sets status to Enrolled" do
        put :approve, params: { activity_id: @activity_id.id, id: @registration.id }
        @registration.reload
        expect(@registration.status).to eq("Enrolled")
      end
    end

    context "when the activity is full" do
      before(:each) do
        sign_in @parent
        @activity.update!(spots: 1) # Set activity to be full
        @first_student = Student.create!(firstname: 'John', lastname: 'Doe', grade: 4)
        @second_student = Student.create!(firstname: 'Jane', lastname: 'Smith', grade: 5)
        
        # Register two students to fill the activity
        @registration1 = Registration.create!(student: @first_student, activity: @activity)
        @registration2 = Registration.create!(student: @second_student, activity: @activity)
      end

      it "does not approve the registration and shows a notice" do
        new_student = Student.create!(firstname: 'Sam', lastname: 'Brown', grade: 3)
        post :create, params: { activity_id: @activity_id.id, registration: { student_id: new_student_id.id } }
        expect(flash[:notice]).to eq("Activity is full.")
      end
    end
  end
end
