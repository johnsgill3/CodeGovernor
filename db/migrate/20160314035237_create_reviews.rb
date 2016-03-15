class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :pr
      t.integer :state
    end
    add_index :reviews, :pr
  end
end
