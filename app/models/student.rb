class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations
    belongs_to :user

    # Do we want to add validations?

    def enrolled_activities
        #Registration.where(student_id: id).where(status: :Enrolled)
        activities.joins(:registrations).merge(Registration.enrolled)
    end

    def waitlisted_activities
        #Registration.where(student_id: id).where(status: :Waitlist)
        activities.joins(:registrations).merge(Registration.waitlist)
    end

    def self.by_search_string(search)
        search_terms = search.split
        if search_terms.length == 1
            Student.where("firstname LIKE ?", "%#{search}%").or(Student.where("lastname LIKE ?", "%#{search}%"))
        else
            Student.where("firstname LIKE ?", "%#{search_terms[0]}%").and(Student.where("lastname LIKE ?", "%#{search_terms[1]}%"))
        end
    end
      

end
