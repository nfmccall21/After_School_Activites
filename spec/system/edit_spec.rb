require 'rails_helper'

RSpec.describe "edit", type: :system do
    include Devise::Test::IntegrationHelpers
    before do
      driven_by(:rack_test)
      @admin = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
      sign_in @admin
    end

    describe 'edit an activity' do
        before (:each) do
            a = Activity.create!(title: 'origTitle',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: 'Monday',
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
            a.update!(approval_status: :Approved)
            
        end

        it "should edit an activity" do
            visit activities_path
            click_on "origTitle"
            click_on 'Edit'
            expect(page).to have_content('Edit Activity')
            fill_in 'Title', with: 'updated'
            click_on "Update Activity"
            expect(page).to have_content('activity details updated successfully')
            expect(page).not_to have_content('origTitle')
        end

        it "should fail if a field is empty" do
            visit activities_path
            click_on 'origTitle'
            click_on 'Edit'
            fill_in 'Title', with: ''
            click_on "Update Activity"
            expect(page).to have_content('Activity could not be edited')
        end
    end

    describe "Admin ability to change Users' Role" do
      it "if user is a teacher: should see switch to parent and admin (& not teacher)" do
        @teacher = User.create(email: "teacher@colgate.edu", password: "password", role: "teacher")
        visit moderate_users_path
        expect(page).to have_content("Switch to Admin")
        expect(page).to have_content("Switch to Parent")
        expect(page).to_not have_content("Switch to Teacher")
      end
      it "if user is a parent: should see switch to teacher and admin (& not parent)" do
        @parent = User.create(email: "parent@colgate.edu", password: "password", role: "parent")
        visit moderate_users_path
        expect(page).to have_content("Switch to Admin")
        expect(page).to have_content("Switch to Teacher")
        expect(page).to_not have_content("Switch to Parent")
      end
      it "if user is an admin: should see switch to teacher and parent (& not admin)" do
        @admin2 = User.create(email: "admin2@colgate.edu", password: "password", role: "admin")
        visit moderate_users_path
        expect(page).to have_content("Switch to Teacher")
        expect(page).to have_content("Switch to Parent")
        expect(page).to_not have_content("Switch to Admin")
      end
      it "should allow admin to switch parent to teacher" do
        @parent = User.create(email: "parent2@colgate.edu", password: "password", role: "parent")
        visit moderate_users_path
        click_on "Switch to Teacher"
        expect(page).to have_content("Role successfully updated")
        expect(@parent.reload.role).to eq("teacher") 
      end
      it "should allow admin to switch teacher to parent" do
        @teacher = User.create(email: "teacher2@colgate.edu", password: "password", role: "teacher")
        visit moderate_users_path
        click_on "Switch to Parent"
        expect(page).to have_content("Role successfully updated")
        expect(@teacher.reload.role).to eq("parent")
      end
      it "should allow admin to switch teacher to admin" do
        @teacher = User.create(email: "teacher2@colgate.edu", password: "password", role: "teacher")
        visit moderate_users_path
        click_on "Switch to Admin"
        expect(page).to have_content("Role successfully updated")
        expect(@teacher.reload.role).to eq("admin")
      end
    end
end
