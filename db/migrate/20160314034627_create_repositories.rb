class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :ghid
      t.boolean :enabled
      t.string :secret_key
    end
    add_index :repositories, :ghid
  end
end
