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

    def self.by_search_string(search)
        search_terms = search.split
        if search_terms.length == 1
            Student.where("firstname LIKE ?", "%#{search}%").or(Student.where("lastname LIKE ?", "%#{search}%"))
        else
            Student.where("firstname LIKE ?", "%#{search_terms[0]}%").and(Student.where("lastname LIKE ?", "%#{search_terms[1]}%"))
        end
    end


    def full_name
        firstname + ' ' + lastname
    end

end
