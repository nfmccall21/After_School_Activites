require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe "model attributes" do
    it "should respond to required attribute methods" do
      a = Activity.new
      expect(a).to respond_to(:title)
      expect(a).to respond_to(:description)
      expect(a).to respond_to(:spots)
      expect(a).to respond_to(:chaperone)
      expect(a).to respond_to(:time_start)
      expect(a).to respond_to(:time_end)
    end

    it "should have the correct enumeration for day" do
      expect(Activity.days.keys).to include("Monday")
      expect(Activity.days.keys).to include("Tuesday")
      expect(Activity.days.keys).to include("Wednesday")
      expect(Activity.days.keys).to include("Thursday")
      expect(Activity.days.keys).to include("Friday")
    end

    it "should have the correct enumeration for approval status" do
      expect(Activity.approval_statuses.keys).to include("Approved")
      expect(Activity.approval_statuses.keys).to include("Pending")
      expect(Activity.approval_statuses.keys).to include("Denied")
    end

    it "should allow creation of model objects with all attributes" do
      a = Activity.new(title: "test", description: "test", spots: 20, chaperone: "test", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Tuesday")
      expect(a.save).to be true
      expect(Activity.all.count).to eq(1)
    end
  end

  describe "validations" do
    it "should fail if no title" do
      a = Activity.new(description: "test", spots: 20, chaperone: "test", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if no description" do
      a = Activity.new(title: "test", spots: 20, chaperone: "test", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if no spots" do
      a = Activity.new(title: "test", description: "test", chaperone: "test", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if invalid number of spots" do
      a = Activity.new(title: "test", description: "test", spots: -1, chaperone: "test", time_start: DateTime.parse('3 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if no time start" do
      a = Activity.new(title: "test", description: "test", spots: 20, chaperone: "test", time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if no time end" do
      a = Activity.new(title: "test", description: "test", spots: 20, chaperone: "test", time_start: DateTime.parse('3 am').to_time, day: "Monday")
      expect(a.save).to be false
    end

    it "should fail if time end is before time start" do
      a = Activity.new(title: "test", description: "test", chaperone: "test", time_start: DateTime.parse('5 am').to_time, time_end: DateTime.parse('4 am').to_time, day: "Monday")
      expect(a.save).to be false
    end
  end
end
