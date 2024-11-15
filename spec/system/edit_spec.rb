require 'rails_helper'
require 'date'

RSpec.describe "new/delete", type: :system do
    before do
      driven_by(:rack_test)
    end
  
    describe 'edit an activity' do
        before (:each) do
            Activity.create!(title: 'origTitle',
                          description: 'test description',
                          spots: 10,
                          chaperone: 'm',
                          day: 'Monday',
                          time_start: DateTime.parse('3 pm').to_time,
                          time_end: DateTime.parse('4 pm').to_time)
        end

        it 'should edit an activity' do
            visit activities_path
            click on 'origTitle'
            click_on 'Edit'
            expect(page).to have_content('Edit Activity')
            fill_in 'Title' with 'updated'
            expect(page).to have_content('activity details updated successfully')
            expect(page).not_to have_content('origTitle')
        end

        it 'should fail if a field is empty' do
            visit activities_path
            click on 'origTitle'
            click_on 'Edit'
            fill_in 'Title' with ''
            expect(page).to have_content('Activity could not be updated')
        end
    end
end