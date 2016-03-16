class Feedback < ActiveRecord::Base
    enum state: [ :pending, :approved, :rejected ]

    belongs_to :review, validate: true
    belongs_to :user, validate: true
=begin
    state:integer
    review_id:integer
    user_id:integer
=end
end
