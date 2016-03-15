require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
    test 'belongs to repository' do
        300.times do |r|
            review = Review.find_by(pr: r)
            assert_not_nil(review, "Could not find review #{r}")
            assert_not_nil(review.repository, "Could not find repository for review #{review.id} - #{review.pr}")
        end
    end

    test 'has files' do
        300.times do |r|
            review = Review.find_by(pr: r)
            assert_not_nil(review, "Could not find review #{r}")
            assert_not_empty(review.g_files, "Could not find files for review #{review.id} - #{review.pr}")
        end
    end

    test 'has feedback' do
        300.times do |r|
            review = Review.find_by(pr: r)
            assert_not_nil(review, "Could not find review #{r}")
            assert_not_empty(review.feedbacks, "Could not find any feedback for review #{review.id} - #{review.pr}")
        end
    end

    test 'state is valid' do
        300.times do |r|
            review = Review.find_by(pr: r)
            assert_not_nil(review, "Could not find review #{r}")
            assert(review.state.to_i >= 0 && review.state.to_i <= 2, "Invalid state for review #{review.id} - #{review.pr}")
        end
    end
end
