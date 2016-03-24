class Review < ActiveRecord::Base
    enum state: [:pending, :approved, :rejected]

    belongs_to :repository, validate: true
    has_and_belongs_to_many :g_files
    has_many :feedbacks,
             dependent: :destroy,
             inverse_of: :review

    validates :g_files, presence: true
    #     pr:integer:index
    #     state:integer
    #     repository_id:integer
end
