class Activity < ApplicationRecord

    validates :title, presence: true # i took out aproval status bc it automatically does it in create
    validates :description, presence: true
    validates :spots, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 35 }
    validates :chaperone, presence: true
    validates :time_start, presence: true
    validates :time_end, presence: true
    validates :time_end, comparison: { greater_than: :time_start }


    enum :day, %i[Monday Tuesday Wednesday Thursday Friday]
    enum :approval_status, %i[Approved Pending Denied]

    def self.by_search_string(search)
        Activity.where("description LIKE ?", "%#{search}%").or(Activity.where("title LIKE ?", "%#{search}%")).order(:day)
    end

    def self.filter_by_day(dow)
        Activity.where("day= :day", {day: Activity.days[dow]})
    end
end
