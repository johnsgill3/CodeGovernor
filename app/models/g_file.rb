class GFile < ActiveRecord::Base
    belongs_to :repository
    belongs_to :user
    has_and_belongs_to_many :reviews
=begin
    name:string:index
=end
end
