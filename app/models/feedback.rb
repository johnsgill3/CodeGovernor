class Feedback < ActiveRecord::Base
    enum state: [ :pending, :approved, :rejected ]

    belongs_to :review
    belongs_to :user
=begin
    state:integer
    review_id:integer
    user_id:integer
=end
end
