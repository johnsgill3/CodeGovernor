class Repository < ActiveRecord::Base
    has_many :g_files, dependent: :destroy
    has_and_belongs_to_many :users
    has_many :reviews, through: :g_files
=begin
    ghid:integer:index
    enabled:boolean
    secret_key:string
=end
end
