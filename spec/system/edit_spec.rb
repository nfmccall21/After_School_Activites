require 'rails_helper'

RSpec.describe "edit", type: :system do
    include Devise::Test::IntegrationHelpers
    before do
      driven_by(:rack_test)
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
            @user = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
            sign_in @user
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
end
