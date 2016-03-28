require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
    test 'belongs to repository' do
        Review.all.each do |review|
            assert_not_nil(review.repository, "Could not find repository for review #{review.id} - #{review.pr}")
        end
    end

    test 'has files' do
        Review.all.each do |review|
            assert_not_empty(review.g_files, "Could not find files for review #{review.id} - #{review.pr}")
        end
    end

    test 'has feedback' do
        Review.all.each do |review|
            assert_not_empty(review.feedbacks, "Could not find any feedback for review #{review.id} - #{review.pr}")
        end
    end

    test 'state is valid' do
        Review.all.each do |review|
            assert(review.state.to_i >= 0 && review.state.to_i <= 2, "Invalid state for review #{review.id} - #{review.pr}")
        end
    end

    test 'valid' do
        Review.all.each do |review|
            assert(review.valid?, "Invalid review #{review.id}" + review.errors.messages.to_json)
        end
    end

    # Write tests for CRUD actions
    test 'create' do
        # Generate random associations
        prng = Random.new
        repo = repositories("repo_#{prng.rand(10)}".to_sym)
        files = (1..prng.rand(1..5)).map { |_| g_files("file_#{prng.rand(300)}".to_sym) }

        # Test create via parameters
        reviewP = Review.new(pr: 990,
                             state: :pending,
                             g_files: files,
                             repository: repo)
        assert_not_nil(reviewP, 'Could not create review via parameters')
        assert(reviewP.valid?, "Invalid review #{reviewP.id} - #{reviewP.pr}\n" + reviewP.errors.messages.to_json)
        assert(reviewP.save!, "Could not save review #{reviewP.id} - #{reviewP.pr}")

        # Test create via attributes
        reviewA = Review.new
        reviewA.pr = 991
        reviewA.state = :pending
        reviewA.g_files = files
        reviewA.repository = repo
        assert_not_nil(reviewA, 'Could not create review via parameters')
        assert(reviewA.valid?, "Invalid review #{reviewA.id} - #{reviewA.pr}\n" + reviewA.errors.messages.to_json)
        assert(reviewA.save!, "Could not save review #{reviewA.id} - #{reviewA.pr}")

        # Test create via hash
        reviewH_param = {
            pr: 992,
            state: :pending,
            g_files: files,
            repository: repo }
        reviewH = Review.new(reviewH_param)
        assert_not_nil(reviewH, 'Could not create review via parameters')
        assert(reviewH.valid?, "Invalid review #{reviewH.id} - #{reviewH.pr}\n" + reviewH.errors.messages.to_json)
        assert(reviewH.save!, "Could not save review #{reviewH.id} - #{reviewH.pr}")

        # Test create via block
        reviewB = Review.new do |r|
            r.pr = 993
            r.state = :pending
            r.g_files = files
            r.repository = repo
        end
        assert_not_nil(reviewB, 'Could not create review via parameters')
        assert(reviewB.valid?, "Invalid review #{reviewB.id} - #{reviewB.pr}\n" + reviewB.errors.messages.to_json)
        assert(reviewB.save!, "Could not save review #{reviewB.id} - #{reviewB.pr}")
    end

    test 'update' do
        # Test Single update via attribute
        review = reviews(:review_0)
        assert_not_nil(review, 'Could not find review review_0')
        review.pending!
        assert(review.valid?, "Invalid review #{review.id} - #{review.pr}" + review.errors.messages.to_json)
        assert(review.save!, "Could not save review #{review.id} - #{review.pr}")

        # Test Update All
        assert_equal(Review.all.length, Review.update_all(state: :pending), 'Update did not update correct number of reviews')

        # Test Update via hash
        reviews(:review_1).update(state: :rejected)
    end

    test 'read' do
        Review.all.each do |r|
            review = Review.find_by(pr: r.pr)
            assert_not_nil(review, "Could not find review #{r.id} - #{r.pr}")
        end
    end

    test 'delete' do
        review = reviews(:review_0)
        assert_not_nil(review, 'Could not find review review_0')
        assert(review.destroy, 'Could not destroy review review_0')
    end
end
