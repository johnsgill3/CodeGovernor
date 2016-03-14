class Repository < ActiveRecord::Base
    has_many :gfiles, dependent: :destroy
    has_many :users
    has_many :reviews, dependent: :destroy
=begin
    ghid:integer:index
    enabled:boolean
    secret_key:string
=end
end
