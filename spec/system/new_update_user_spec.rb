require 'rails_helper'

RSpec.describe "User System Tests", type: :system do
    include Devise::Test::IntegrationHelpers
    before do
      driven_by(:rack_test)
    end

    describe "log in" do
      before (:each) do
        @user = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
      end
      # this test was for old way
      # it "should show the log in form from index page button" do
      #     visit root_path
      #     expect(page.current_path).to eq(root_path)
      #     click_on "Log In"
      #     expect(page.current_path).to eq(new_user_session_path)
      #     expect(page).to have_content("Log in")
      # end
      it "should prompt user to log in" do
          visit root_path
          expect(page).to have_content("You need to sign in or sign up before continuing.")
      end
      it "should re-render the page with error message if log in fails" do
          visit new_user_session_path
          click_on "Log in"
          expect(page.current_path).to eq(new_user_session_path) # it still switches path just rerenders
          expect(page.text).to match /Invalid Email or password/
      end
      it 'should log in successfully' do
          visit new_user_session_path
          fill_in 'Email', with: 'admin@colgate.edu'
          fill_in 'Password', with: 'testing'
          click_on "Log in"
          expect(page).to have_content('Signed in successfully.')
      end
    end

    describe "log out" do
      before (:each) do
        @user = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
        sign_in @user
      end

      it "should show the log out button" do
        visit root_path
        expect(page).to have_content("Log Out")
      end
      it "should log out successfully" do
        visit root_path
        click_on "Log Out"
        expect(page).to have_content("You need to sign in or sign up before continuing.")
      end
    end

    describe "Visibility of Students" do
      before (:each) do
        @student = Student.create!(firstname: 'firstname', lastname: 'lastname', grade: 3, homeroom: 'test')
        @parent = User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent)
        @admin = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
      end
      it "parent see no if not theres when admin can" do
        sign_in @parent
        visit students_path
        expect(page).not_to have_content('firstname')
      end
      it "admin can see all students" do
        sign_in @admin
        visit students_path
        expect(page).to have_content('firstname')
      end
      it "parent should see their student" do
        sign_in @parent
        @parent.students << @student
        visit students_path
        expect(page).to have_content('firstname')
      end
      it "should not let a parent see another student's details" do
        sign_in @parent
        @parent.students << @student
        s2 = Student.create(firstname: "test2", lastname: "test2", grade: 20, homeroom: "test2")
        @activity = Activity.create!(title: 'testAct',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: :Monday,
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @activity.students<<s2
        visit activities_path
        click_on "testAct"
        click_on "test2 test2"
        expect(page).to have_content("You do not have permission to view this student")
      end



      it 'removes student from acitivity when unenrolled' do
        sign_in @admin
        s2 = Student.create(firstname: "test2", lastname: "test2", grade: 20, homeroom: "test2")
        @activity = Activity.create!(title: 'testAct',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: :Monday,
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @activity.students<<s2
        visit students_path
        click_on "test2 test2"
        click_on "Un-enroll"
        visit students_path
        click_on "test2 test2"
        expect(page).not_to have_content("testAct")
      end
    end

    describe "Visibility of Approving" do
      before (:each) do
        @activity = Activity.create!(title: 'I am an unapproved activity',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: :Monday,
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Pending)
        @admin = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
        @parent = User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent)
        @teacher = User.create!(email: 'teacher@colgate.edu', password: 'testing', role: :teacher)
      end

      it "a new activity should be unapproved" do
        sign_in @parent
        visit activities_path
        expect(page).not_to have_content('I am an unapproved activity')
      end
      it "admin can see unapproved activities button" do
        sign_in @admin
        visit activities_path
        expect(page).to have_content('Unapproved Activities')
      end
      it "teacher can see unapproved activities button" do
        sign_in @teacher
        visit activities_path
        expect(page).to have_content('Unapproved Activities')
      end
      it "parent cannot see unapproved activities button" do
        visit activities_path
        sign_in @parent
        expect(page).not_to have_content('Unapproved Activities')
      end

      it "admin can approve unapproved activities" do
        sign_in @admin
        visit activities_path
        first(:link, 'Unapproved Activities').click
        expect(page.current_path).to eq(unapproved_activities_path)
        expect(page).to have_content('I am an unapproved activity')
        click_on 'Approve'
        expect(page.current_path).to eq(activities_path)
        expect(page).to have_content('Activity was successfully approved.')
        expect(page).to have_content('I am an unapproved activity')
      end

      it "admin can decline unapproved activities" do
        sign_in @admin
        visit activities_path
        first(:link, 'Unapproved Activities').click
        expect(page.current_path).to eq(unapproved_activities_path)
        expect(page).to have_content('I am an unapproved activity')
        click_on 'Deny'
        expect(page.current_path).to eq(activities_path)
        expect(page).to have_content('Activity was successfully denied.')
        expect(page).not_to have_content('I am an unapproved activity')
      end

      it "cannot approve activity (sad path)" do
        sign_in @admin
        a = Activity.new
        allow(Activity).to receive(:find).and_return(a)
        expect(a).to receive(:approval_status).and_return('Accepted')
        visit activities_path
        first(:link, 'Unapproved Activities').click
        expect(page.current_path).to eq(unapproved_activities_path)
        expect(page).to have_content('I am an unapproved activity')
        click_on 'Approve'
        expect(page.current_path).to eq(activities_path)
        expect(page).to have_content('Activity cannot be approved.')
      end

      it "cannot deny activity (sad path)" do
        sign_in @admin
        a = Activity.new
        allow(Activity).to receive(:find).and_return(a)
        expect(a).to receive(:approval_status).and_return('Accepted')
        visit activities_path
        first(:link, 'Unapproved Activities').click
        expect(page.current_path).to eq(unapproved_activities_path)
        expect(page).to have_content('I am an unapproved activity')
        click_on 'Deny'
        expect(page.current_path).to eq(activities_path)
        expect(page).to have_content('Activity cannot be denied.')
      end
    end
end
