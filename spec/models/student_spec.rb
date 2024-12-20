require 'rails_helper'

RSpec.describe Student, type: :model do

  describe "student attributes" do
    it "should respond to required attribute methods" do
      a = Student.new
      expect(a).to respond_to(:firstname)
      expect(a).to respond_to(:lastname)
      expect(a).to respond_to(:grade)
      expect(a).to respond_to(:homeroom)
    end

    it "should allow creation of model objects with all attributes" do
      a = Student.new(firstname: "test", lastname: "test", grade: 20, homeroom: "test")
      expect(a.save).to be true
      expect(Student.all.count).to eq(1)
    end

  end
end