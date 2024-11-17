class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations
    has_and_belongs_to_many :users

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
        # search_terms = search.split
        # Student.where("firstname LIKE ?", "%#{search[0]}%").or(Student.where("lastname LIKE ?", "%#{search[1]}%"))
        search_terms = search.split

        if search_terms.size == 1
            where("firstname LIKE :term OR lastname LIKE :term", term: "%#{search_terms[0]}%")
        elsif search_terms.size > 1
            where("firstname LIKE :first AND lastname LIKE :last", first: "%#{search_terms[0]}%", last: "%#{search_terms[1]}%")
        else
            all
        end
    end

    def full_name
        "#{firstname} #{lastname}"
    end
      

end
