class Registration < ApplicationRecord
  belongs_to :student
  belongs_to :activity


  enum :status, %i[Pending Enrolled Waitlist Denied]

  scope :pending, -> { where(status: :Pending) }
  scope :enrolled, -> { where(status: :Enrolled) }
  scope :waitlist, -> { where(status: :Waitlist) }
  scope :denied, -> { where(status: :Denied) }

  validates :student_id, uniqueness: { scope: :activity_id, message: "is already registered for this activity" }
  
end
