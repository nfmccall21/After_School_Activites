class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations

    def enrolled_activities
        Registration.where(student_id: id).where(status: 1)
    end



end
