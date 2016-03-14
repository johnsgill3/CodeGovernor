class AddReferencesToSchema < ActiveRecord::Migration
    def change
        # Repository References
        create_table :repository_users, id: false do |t|
            t.integer :repositories_id
            t.integer :users_id
        end
        add_index :repository_users, :repositories_id
        add_index :repository_users, :users_id

        # GFile References
        add_reference :g_files, :repository, index: true, foreign_key: true
        add_reference :g_files, :user, index: true, foreign_key: true

        create_table :file_reviews, id: false do |t|
            t.integer :g_files_id
            t.integer :reviews_id
        end
        add_index :file_reviews, :g_files_id
        add_index :file_reviews, :reviews_id

        # User References
        # See Repository Above

        # Review References
        add_reference :reviews, :repository, index: true, foreign_key: true

        # Feedback References
        add_reference :feedbacks, :review, index: true, foreign_key: true
        add_reference :feedbacks, :user, index: true, foreign_key: true
    end
end
