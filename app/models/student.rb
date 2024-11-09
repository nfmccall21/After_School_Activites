class Student < ApplicationRecord

    has_many :registrations
    has_many :activities, through: :registrations



end
