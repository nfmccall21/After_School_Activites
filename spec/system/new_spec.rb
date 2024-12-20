require 'rails_helper'

RSpec.describe "new/delete", type: :system do
    include Devise::Test::IntegrationHelpers
    before do
      driven_by(:rack_test)
      @user = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
      sign_in @user
    end

    describe "create new activity" do
        
        it "should show the new form from index page button" do
            visit activities_path
            expect(page.current_path).to eq(activities_path)
            click_on "Propose an Activity!"
            expect(page.current_path).to eq(new_activity_path)
            expect(page).to have_content("Propose Activity")
        end
        it "should re-render the page with error message if save fails" do
            visit new_activity_path
            click_on "Propose Activity"
            expect(page.current_path).to eq(activities_path) # it still switches path just rerenders
            expect(page.text).to match /Cannot propose activity/
        end
        it 'should create successfully' do
            visit new_activity_path
            fill_in 'Title', with: 'test act'
            fill_in 'Description', with: 'desc test'
            fill_in 'Spots', with: 10
            fill_in 'Chaperone', with: 'm. test'
            select 'Monday', from: 'Day'
            select '03', from: 'activity_time_start_4i'   # 4i --> hour
            select '00', from: 'activity_time_start_5i'  # 5i --> Minute
            select '04', from: 'activity_time_end_4i'
            select '00', from: 'activity_time_end_5i'
            click_on "Propose Activity"
            expect(page).to have_content('Activity test act proposed')
            expect(page.current_path).to eq(activities_path)
            expect(page).to have_content('test act') # will need to change this since it won't be visible due to status
        end
    end


    describe 'delete an activity' do
        before (:each) do
            a = Activity.create!(title: 'test',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: :Monday,
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
            a.update!(approval_status: :Approved)
        end

        # IT ISNT APPROVED YET

        it 'should delete an activity' do
            visit activities_path
            click_on 'test'
            expect(page).to have_content('Back to Activities')
            click_on 'Delete'
            expect(page).to have_content('activity removed')
            expect(page).not_to have_content('test')
        end
    end

    describe "create new student" do
        before (:each) do
            @user = User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent)
            sign_in @user
        end
        it "should create a new student with valid input" do
            @student = Student.create(firstname: "test", lastname: "test", grade: 20, homeroom: "test")
            @user.students << @student
            visit students_path
            expect(page).to have_content('test')
            expect(@student.full_name).to eq('test test')
        end
        it "should show correct error message if save fails" do
            s = Student.new
            allow(Student).to receive(:new).and_return(s)
            expect(s).to receive(:save).and_return(false)
            visit new_student_path
            click_on "Create Student"
            expect(page).to have_content("Cannot add student :(")
        end
        it "should create a new student successfully" do
            visit new_student_path
            fill_in 'Firstname', with: 'testfn'
            fill_in 'Lastname', with: 'testln'
            fill_in 'Grade', with: 2
            fill_in 'Homeroom', with: 'testhr'
            click_on "Create Student"
            expect(page.current_path).to eq(students_path)
            expect(page).to have_content("added!")
        end
        it "should show the new student on the index page" do
            @student = Student.create(firstname: "testfn2", lastname: "testln2", grade: 4, homeroom: "test")
            @user.students << @student
            visit students_path
            click_on "#{@student[:firstname]} #{@student[:lastname]}"
            expect(page).to have_content('testfn2')
            expect(page.current_path).to eq(student_path(@student))
        end
        it "should successfully delete a student" do
            @student = Student.create(firstname: "testfn3", lastname: "testln3", grade: 4, homeroom: "test")
            @user.students << @student
            visit students_path
            click_on 'testfn3 testln3'
            click_on 'Delete Student'
            expect(page).to have_content('Student removed')
            expect(page.current_path).to eq(students_path)
            expect(page).not_to have_content('testfn3')
        end
    end

    describe "waitlisting students" do
        it "should correctly show students on the waitlist" do
            @student = Student.create!(firstname: "testfn2", lastname: "testln2", grade: 4, homeroom: "test")
            activity = Activity.create!(title: 'testact', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
            activity.update!(approval_status: :Approved)
            @registration = Registration.create!(student: @student, activity: activity, status: :Waitlist, requested_registration_at: Time.now, registration_update_at: Time.now)
            visit students_path
            expect(page).to have_content('Waitlisted for:')
            expect(activity.waitlist_students[0].student_id).to eq(@student.id)
            expect(page).to have_content('testfn2 testln2')
        end
        it "should correctly identify denied students" do
            @student = Student.create!(firstname: "testfn3", lastname: "testln3", grade: 4, homeroom: "test")
            @activity = Activity.create!(title: 'testact', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
            @registration = Registration.create!(student: @student, activity: @activity, status: :Denied, requested_registration_at: Time.now, registration_update_at: Time.now)
            @registration.update!(status: :Denied)
            expect(@activity.denied_students).to include(@registration) # note it adds the REGISTRATION and NOT the STUDENT
        end
    end

    describe "registering from act show page" do
      it "should allow an admin to register any child for an activity (if not already registered)" do
        @student = Student.create!(firstname: "testfn4", lastname: "testln4", grade: 4, homeroom: "test")
        @activity = Activity.create!(title: 'testact', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        visit activities_path
        click_on 'testact'
        select 'testfn4 testln4', from: 'student_id'
        click_on 'Register'
        expect(page).to have_content('has been successfully registered')
      end
      it "should not allow user register a student who is already registered" do
        @student = Student.create!(firstname: "testfn5", lastname: "testln5", grade: 4, homeroom: "test")
        @activity = Activity.create!(title: 'testact2', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @registration = Registration.create!(student: @student, activity: @activity, status: :Enrolled, requested_registration_at: Time.now, registration_update_at: Time.now)
        visit activities_path
        click_on 'testact'
        select 'testfn5 testln5', from: 'student_id'
        click_on 'Register'
        expect(page).to have_content('is already registered')
      end
      it "should add student to waitlist if activity is full" do
        @student = Student.create!(firstname: "testfn6", lastname: "testln6", grade: 4, homeroom: "test")
        @activity = Activity.create!(title: 'testact3', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @student2 = Student.create!(firstname: "testfn7", lastname: "testln7", grade: 4, homeroom: "test")
        @registration = Registration.create!(student: @student, activity: @activity, status: :Enrolled, requested_registration_at: Time.now, registration_update_at: Time.now)
        visit activities_path
        click_on 'testact'
        select 'testfn7 testln7', from: 'student_id'
        click_on 'Register'
        expect(page).to have_content('has been successfully added to the waitlist')
      end
      it "cannot register a student (sad path -- spots available)" do
        @student = Student.create!(firstname: "testfn8", lastname: "testln8", grade: 4, homeroom: "test")
        @activity = Activity.create!(title: 'testact4', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @reg = Registration.new
        allow(Registration).to receive(:new).and_return(@reg)
        allow(@reg).to receive(:save).and_return(false)
        visit activities_path
        click_on 'testact'
        select 'testfn8 testln8', from: 'student_id'
        click_on 'Register'
        expect(page).to have_content('There was an issue with registering')
      end
      it "cannot register a student (sad path -- no spots available)" do
        @student = Student.create!(firstname: "testfn8", lastname: "testln8", grade: 4, homeroom: "test")
        @activity = Activity.create!(title: 'testact4', description: 'test description', spots: 1, chaperone: 'm', day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('4 pm').to_time)
        @activity.update!(approval_status: :Approved)
        @student2 = Student.create!(firstname: "testfn7", lastname: "testln7", grade: 4, homeroom: "test")
        @registration = Registration.create!(student: @student2, activity: @activity, status: :Enrolled, requested_registration_at: Time.now, registration_update_at: Time.now)
        @reg = Registration.new
        allow(Registration).to receive(:new).and_return(@reg)
        allow(@reg).to receive(:save).and_return(false)
        visit activities_path
        click_on 'testact'
        select 'testfn8 testln8', from: 'student_id'
        click_on 'Register'
        expect(page).to have_content('There was an issue with registering')
      end

    end
end