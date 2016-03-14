class Feedback < ActiveRecord::Base
    enum state: [ :pending, :approved, :rejected ]

    belongs_to :review
    belongs_to :user
=begin
    state:integer
=end
end
