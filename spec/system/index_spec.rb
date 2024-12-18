require 'rails_helper'

RSpec.describe "Index route", type: :system do
  include Devise::Test::IntegrationHelpers
  before do
    driven_by(:rack_test)
  end

  describe "activities index" do
    before(:each) do
      @a1 = Activity.create!(title: "test1", description: "test1", spots: 20, chaperone: "test1", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Tuesday")
      @a1.update!(approval_status: :Approved)
      @a2 = Activity.create!(title: "test2", description: "test2", spots: 20, chaperone: "test2", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Tuesday")
      @a2.update!(approval_status: :Pending)
      @a3 = Activity.create!(title: "test3", description: "test3", spots: 20, chaperone: "test3", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Tuesday")
      @a3.update!(approval_status: :Denied)
    end
    it "should show approved activities" do
      visit activities_path
      expect(page).to have_content('test1')
    end
    it "should not show pending activities" do
      visit activities_path
      expect(page).not_to have_content('test2')
    end
    it "should not show denied activities" do
      visit activities_path
      expect(page).not_to have_content('test3')
    end
  end

  describe "Activities Index Filters" do
    before(:each) do
      @a1 = Activity.create!(title: "test1", description: "test1", spots: 20, chaperone: "test1", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      @a1.update!(approval_status: :Approved)
      @a2 = Activity.create!(title: "test2", description: "test2", spots: 20, chaperone: "test2", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      @a2.update!(approval_status: :Approved)
      @a3 = Activity.create!(title: "test3", description: "test3", spots: 20, chaperone: "test3", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Wednesday")
      @a3.update!(approval_status: :Approved)
      @a4 = Activity.create!(title: "full act", description: "test3", spots: 1, chaperone: "test3", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Wednesday")
      @a4.update!(approval_status: :Approved)
      
    end
    it "should show all activities if no day filter is applied" do
      visit activities_path
      expect(page).to have_content('test1')
      expect(page).to have_content('test2')
      expect(page).to have_content('test3')
    end
    it "should show activities that are full if spots filter is not applied" do
      visit activities_path
      expect(page).to have_content('full act')
    end
    it "should not show full activities if spots filter is applied" do
      @s1 =  Student.create!(firstname: "fn", lastname: "ln", grade: 20, homeroom: "hr")
      Registration.create!(student_id: @s1.id, activity_id: @a4.id, status: :Enrolled)
      visit activities_path
      check 'avail'
      click_on 'Filter Availability'
      expect(page).not_to have_content('full act')
    end
    it "should show Monday activities if Monday filter is applied" do
      visit activities_path
      check 'Monday'
      click_on 'Filter Days'
      expect(page).to have_content('test1')
      expect(page).to have_content('test2')
    end
    it "should not show Wednesday activities if Monday filter is applied" do
      visit activities_path
      check 'Monday'
      click_on 'Filter Days'
      expect(page).not_to have_content('test3')
      expect(page).not_to have_checked_field('Wednesday')
    end
    it "should show all activities if all days are checked" do
      visit activities_path
      check 'Monday'
      check 'Tuesday'
      check 'Wednesday'
      check 'Thursday'
      check 'Friday'
      click_on 'Filter Days'
      expect(page).to have_content('test1')
      expect(page).to have_content('test2')
      expect(page).to have_content('test3')
      expect(page).to have_checked_field('Monday')
      expect(page).to have_checked_field('Tuesday')
      expect(page).to have_checked_field('Wednesday')
      expect(page).to have_checked_field('Thursday')
      expect(page).to have_checked_field('Friday')
    end
    it "should show only activities that match the search string" do
      visit activities_path
      fill_in 'query', with: 'test1'
      click_on 'Filter Activities'
      expect(page).to have_content('test1')
      expect(page).not_to have_content('test2')
      expect(page).not_to have_content('test3')
    end
  end

  describe "Student Index" do
    before(:each) do
      @s1 = Student.create!(firstname: "fn12", lastname: "ln1", grade: 20, homeroom: "hr1")
      @s2 = Student.create!(firstname: "fn12", lastname: "ln2", grade: 20, homeroom: "hr2")
      @s3 = Student.create!(firstname: "fn3", lastname: "ln3", grade: 20, homeroom: "hr3")
      @admin = User.create!(email: 'admin@colgate.edu', password: 'testing', role: :admin)
      sign_in @admin
    end
    it "should show all students if no search" do
      visit students_path
      expect(page).to have_content('fn12')
      expect(page).to have_content('ln1')
      expect(page).to have_content('fn12')
      expect(page).to have_content('ln2')
      expect(page).to have_content('fn3')
      expect(page).to have_content('ln3')
    end
    it "should show ALL students that match the search string (fn only)" do
      visit students_path
      fill_in 'query', with: 'fn12'
      click_on 'Filter Students'
      expect(page).to have_content('fn12')
      expect(page).to have_content('ln1')
      expect(page).to have_content('fn12')
      expect(page).to have_content('ln2')
      expect(page).not_to have_content('fn3')
      expect(page).not_to have_content('ln3')
    end
    it "should show students that match the FULL string (fn and ln)" do
      visit students_path
      fill_in 'query', with: 'fn12 ln1'
      click_on 'Filter Students'
      expect(page).to have_content('fn12')
      expect(page).to have_content('ln1')
      expect(page).not_to have_content('ln2')
      expect(page).not_to have_content('fn3')
      expect(page).not_to have_content('ln3')
    end
  end
end
