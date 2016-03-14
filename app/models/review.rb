class Review < ActiveRecord::Base
    enum state: [ :pending, :approved, :rejected ]

    belongs_to :repository
    has_and_belongs_to_many :gfiles
    has_many :feedbacks, dependent: :destroy
=begin
    pr:integer:index
    state:integer
=end
end
