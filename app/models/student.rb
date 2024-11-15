class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations
    has_and_belongs_to_many :users

    def enrolled_activities
        Registration.where(student_id: id).where(status: :Enrolled)
    end

    def waitlisted_activities
        Registration.where(student_id: id).where(status: :Waitlist)
    end



end
