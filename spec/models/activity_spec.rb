require 'rails_helper'

RSpec.describe Activity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

describe "create new activity" do
  it "should show the new form" do
    visit activities_path
    click_on "Propose an Activity!"
    expect(page.text).to eq(/Propose Activity/)
  end
  it "should re-render the page with error message if save fails" do
    visit new_activity_path
    click_on "Propose Activity"
    expect(page.current_path).to eq(new_activity_path)
    expect(page.text).to match /Cannot propose activity/
  end
  it 'should create successfully' do
    visit new_activity_path
    fill_in 'Title', with: 'test act'
    fill_in 'Description', with: 'desc test'
    fill_in 'Spots', with: 10
    fill_in 'Chaperone', with: 'm. test'
    fill_in 'day', with: 'Monday'
    select_time('3', '00', from: 'Open time')
    select_time('4', '00', from: 'Close time')
    click_on 'Create Sight'
    expect(page).to have_content('Activity test act proposed')
    expect(page.current_path).to eq(activities_path)
    expect(page).to have_content('test act') #will need to change this since it won't be visible due to status
  end
end