require 'rails_helper'

RSpec.describe Registration, type: :model do
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
  end
end
