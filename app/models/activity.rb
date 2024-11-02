class Activity < ApplicationRecord

    validates :title, presence: true
    validates :description, presence: true
    validates :spots, presence: true, numericality: {greater_than_or_equal_to: 1, less_than_or_equal_to: 35}
    validates :chaperone, presence: true
    validates :time_start, presence: true
    validates :time_end, presence: true 
    validates :time_end, comparison: {greater_than: :time_start}


    enum :day, %i[Monday Tuesday Wednesday Thursday Friday]
    enum :approval_status, %i[Approved Pending Denied]

end
