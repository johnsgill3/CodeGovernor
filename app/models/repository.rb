class Repository < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_many :g_files,
        dependent: :destroy,
        inverse_of: :repository
    has_many :reviews,
        dependent: :destroy,
        inverse_of: :repository

    validates :users, presence: true
    validates :ghid, uniqueness: true
=begin
    ghid:integer:index
    enabled:boolean
    secret_key:string
=end
end
