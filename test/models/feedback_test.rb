require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
    test 'belongs to review' do
        Feedback.all.each do |feedback|
            assert_not_nil(feedback.review, "Could not find review for feedback #{feedback.id}")
        end
    end

    test 'belongs to user' do
        Feedback.all.each do |feedback|
            assert_not_nil(feedback.user, "Could not find user for feedback #{feedback.id}")
        end
    end

    test 'state is valid' do
        Feedback.all.each do |feedback|
            assert(feedback.state.to_i >= 0 && feedback.state.to_i <= 2, "Invalid state for feedback #{feedback.id}")
        end
    end

    test 'valid' do
        Feedback.all.each do |feedback|
            assert(feedback.valid?, "Invalid feedback #{feedback.id}" + feedback.errors.messages.to_json)
        end
    end

    # Write tests for CRUD actions
    test 'create' do
        # Generate random associations
        prng = Random.new
        review = reviews("review_#{prng.rand(10)}".to_sym)
        user = review.g_files.first.user

        # Test create via parameters
        feedbackP = Feedback.new(state: :pending,
                                 review: review,
                                 user: user)
        assert_not_nil(feedbackP, 'Could not create feedback via parameters')
        assert(feedbackP.valid?, "Invalid feedback #{feedbackP.id}\n" + feedbackP.errors.messages.to_json)
        assert(feedbackP.save!, "Could not save feedback #{feedbackP.id}")

        # Test create via attributes
        feedbackA = Feedback.new
        feedbackA.state = :pending
        feedbackA.review = review
        feedbackA.user = user
        assert_not_nil(feedbackA, 'Could not create feedback via parameters')
        assert(feedbackA.valid?, "Invalid feedback #{feedbackA.id}\n" + feedbackA.errors.messages.to_json)
        assert(feedbackA.save!, "Could not save feedback #{feedbackA.id}")

        # Test create via hash
        feedbackH_param = {
            state: :pending,
            review: review,
            user: user }
        feedbackH = Feedback.new(feedbackH_param)
        assert_not_nil(feedbackH, 'Could not create feedback via parameters')
        assert(feedbackH.valid?, "Invalid feedback #{feedbackH.id}\n" + feedbackH.errors.messages.to_json)
        assert(feedbackH.save!, "Could not save feedback #{feedbackH.id}")

        # Test create via block
        feedbackB = Feedback.new do |f|
            f.state = :pending
            f.review = review
            f.user = user
        end
        assert_not_nil(feedbackB, 'Could not create feedback via parameters')
        assert(feedbackB.valid?, "Invalid feedback #{feedbackB.id}\n" + feedbackB.errors.messages.to_json)
        assert(feedbackB.save!, "Could not save feedback #{feedbackB.id}")
    end

    test 'update' do
        # Test Single update via attribute
        feedback = feedbacks(:feedback_0)
        assert_not_nil(feedback, 'Could not find feedback feedback_0')
        feedback.pending!
        assert(feedback.valid?, "Invalid feedback #{feedback.id}" + feedback.errors.messages.to_json)
        assert(feedback.save!, "Could not save review #{feedback.id}")

        # Test Update All
        assert_equal(Feedback.all.length, Feedback.update_all(state: :pending), 'Update did not update correct number of feedback')

        # Test Update via hash
        feedbacks(:feedback_1).update(state: :rejected)
    end

    test 'read' do
        Feedback.all.each do |f|
            feedback = Feedback.find_by(id: f.id)
            assert_not_nil(feedback, "Could not find feedback #{f.id}")
        end
    end

    test 'delete' do
        feedback = feedbacks(:feedback_0)
        assert_not_nil(feedback, 'Could not find feedback feedback_0')
        assert(feedback.destroy, 'Could not destroy feedback feedback_0')
    end
end
