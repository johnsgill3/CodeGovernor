class User < ActiveRecord::Base
    has_and_belongs_to_many :repositories
    has_many :g_files, inverse_of: :user
    has_many :feedbacks, inverse_of: :user

    validates :ghuid, uniqueness: true
=begin
    ghuid:integer:index
    nickname:string
    token:string
=end

    def self.from_omniauth(auth_hash)
        user = find_or_create_by(ghuid: auth_hash['uid'])
        user.nickname = auth_hash['info']['nickname']
        user.token = auth_hash['credentials']['token']
        user.save!
        user
    end
end
