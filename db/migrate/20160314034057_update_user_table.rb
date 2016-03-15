class UpdateUserTable < ActiveRecord::Migration
  def change
      change_table :users do |t|
          t.remove :uid
          t.integer :ghuid
          t.remove :name
          t.remove :email
      end
      add_index :users, :ghuid
  end
end
