class User < ActiveRecord::Base
=begin
    uid:string, null: false
    name:string
    nickname:string
    email:string
    token:string
=end

    class << self
        def from_omniauth(auth_hash)
            user = find_or_create_by(uid: auth_hash['uid'])
            user.name = auth_hash['info']['name']
            user.nickname = auth_hash['info']['nickname']
            user.email = auth_hash['info']['email']
            user.token = auth_hash['credentials']['token']
            user.save!
            user
        end
    end
end
