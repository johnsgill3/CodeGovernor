require 'test_helper'

class FeedbackTest < ActiveSupport::TestCase
    test 'belongs to review' do
        1500.times do |f|
            feedback = feedbacks("feedback_#{f}".to_sym)
            assert_not_nil(feedback, "Could not find feedback #{f}")
            assert_not_nil(feedback.review, "Could not find review for feedback #{feedback.id}")
        end
    end

    test 'belongs to user' do
        1500.times do |f|
            feedback = feedbacks("feedback_#{f}".to_sym)
            assert_not_nil(feedback, "Could not find feedback #{f}")
            assert_not_nil(feedback.user, "Could not find user for feedback #{feedback.id}")
        end
    end

    test 'state is valid' do
        1500.times do |f|
            feedback = feedbacks("feedback_#{f}".to_sym)
            assert_not_nil(feedback, "Could not find feedback #{f}")
            assert(feedback.state.to_i >= 0 && feedback.state.to_i <= 2, "Invalid state for feedback #{feedback.id}")
        end
    end
end
