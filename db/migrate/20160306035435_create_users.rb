class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :uid, null: false
            t.string :name
            t.string :nickname
            t.string :email
            t.string :token
        end
        add_index :users, :uid
    end
end
