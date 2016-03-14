class CreateGFiles < ActiveRecord::Migration
  def change
    create_table :g_files do |t|
      t.string :name
    end
    add_index :g_files, :name
  end
end
