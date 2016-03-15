class AddReferencesToSchema < ActiveRecord::Migration
    def change
        # Repository References
        create_join_table :repositories, :users do |t|
          # t.index [:repository_id, :user_id]
          # t.index [:user_id, :repository_id]
        end

        # GFile References
        add_reference :g_files, :repository, index: true, foreign_key: true
        add_reference :g_files, :user, index: true, foreign_key: true

        create_join_table :g_files, :reviews do |t|
          # t.index [:repository_id, :user_id]
          # t.index [:user_id, :repository_id]
        end

        # User References
        # See Repository Above

        # Review References
        add_reference :reviews, :repository, index: true, foreign_key: true

        # Feedback References
        add_reference :feedbacks, :review, index: true, foreign_key: true
        add_reference :feedbacks, :user, index: true, foreign_key: true
    end
end
