class Activity < ApplicationRecord
    enum :day, %i[Monday Tuesday Wednesday Thursday Friday]

end
