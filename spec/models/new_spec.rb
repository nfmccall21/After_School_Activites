require 'rails_helper'

RSpec.describe "new", type: :system do
    before do
      driven_by(:rack_test)
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
end
