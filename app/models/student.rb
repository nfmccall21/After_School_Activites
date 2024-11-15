class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations

    def enrolled_activities
        Registration.where(student_id: id).where(status: :Enrolled)
    end

    def waitlisted_activities
        Registration.where(student_id: id).where(status: :Waitlist)
    end

    def self.by_search_string(search)
        search_terms = search.split
        Student.where("firstname LIKE ?", "%#{search[0]}%").or(Student.where("lastname LIKE ?", "%#{search[1]}%"))
    end


end
