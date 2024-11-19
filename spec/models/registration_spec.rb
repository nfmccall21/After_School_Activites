require 'rails_helper'

RSpec.describe Registration, type: :model do
  let(:parent) { User.create!(email: 'parent@colgate.edu', password: 'testing', role: :parent) }
  let(:student) { Student.create!(firstname: 'Natalie', lastname: 'McCall', grade: 3, homeroom: "homeroom 4", user: @parent) }
  let(:activity) { Activity.create!(title: 'Games Club', description: 'Come play! Each week we will alternate between board games and video games', spots: 25, chaperone: 'ms. V', approval_status: :Pending, day: :Monday, time_start: DateTime.parse('3 pm').to_time, time_end: DateTime.parse('5 pm').to_time) }
  end
  
  describe "model attributes" do
    it "should respond to required attribute methods" do
      a = Registration.new
      expect(a).to respond_to(:student)
      expect(a).to respond_to(:activity)
    end

    it "should have the correct enumeration for status" do
      expect(Registration.statuses.keys).to include("Pending")
      expect(Registration.statuses.keys).to include("Enrolled")
      expect(Registration.statuses.keys).to include("Waitlist")
      expect(Registration.statuses.keys).to include("Denied")
    end

    describe "validations" do
      it "should require a student" do
        registration = Registration.new(activity: activity)
        expect(registration).to_not be_valid
        expect(registration.errors[:student]).to include("can't be blank")
      end
  
      it "should require an activity" do
        registration = Registration.new(student: student)
        expect(registration).to_not be_valid
        expect(registration.errors[:activity]).to include("can't be blank")
      end
    end
  
    describe "status logic" do
      it "sets status to Enrolled if there is space" do
        registration = Registration.new(student: student, activity: activity)
        expect(registration.status).to eq("Pending") # Assuming "Pending" is the default
      end
  
      it "sets status to Waitlist if spots are full" do
        activity.update!(spots: 1) # Assuming spots were initially more
        second_student = create(:student, user: parent, firstname: 'John', lastname: 'Doe', grade: 4)
        Registration.create!(student: student, activity: activity)
        registration = Registration.new(student: second_student, activity: activity)
        registration.save
        expect(registration.status).to eq("Waitlist")
      end
  
      it "sets status to Denied if waitlist is full" do
        activity.update!(spots: 1) # Again, only 1 spot available
        second_student = create(:student, user: parent, firstname: 'John', lastname: 'Doe', grade: 4)
        third_student = create(:student, user: parent, firstname: 'Sally', lastname: 'Johnson', grade: 5)
        
        Registration.create!(student: student, activity: activity)
        Registration.create!(student: second_student, activity: activity)  # now waitlist is full
        denied_registration = Registration.create(student: third_student, activity: activity)
        
        expect(denied_registration.status).to eq("Denied")
      end
    end
  end
end
