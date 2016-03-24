class GFile < ActiveRecord::Base
    belongs_to :repository, validate: true
    belongs_to :user, validate: true
    has_and_belongs_to_many :reviews
    #     name:string:index
    #     repository_id:integer
    #     user_id:integer
end
