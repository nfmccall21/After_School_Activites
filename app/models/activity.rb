class Activity < ApplicationRecord
    enum :day, %i[monday tuesday wednesday thursday friday]

end
