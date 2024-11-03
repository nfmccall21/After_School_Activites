class Activity < ApplicationRecord
    enum :day, %i[Monday Tuesday Wednesday Thursday Friday]

    def self.by_search_string(search)
        Activity.where("description LIKE ?", "%#{search}%").or(Activity.where("title LIKE ?", "%#{search}%")).order(:day)
    end

    def self.filter_by_day(day)
        Activity.where("description LIKE ?", "%#{day}%").or(Activity.where("title LIKE ?", "%#{day}%")).order(:day)
    end
end
