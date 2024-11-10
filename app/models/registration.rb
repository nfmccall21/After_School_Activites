class Registration < ApplicationRecord
  belongs_to :student
  belongs_to :activity


  enum :status, %i[Pending, Enrolled, Waitlist, Denied]
  
end
