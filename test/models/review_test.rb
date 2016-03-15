require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
    test 'belongs to repository' do
        200.times do |r|
            puts "Review #{r} belongs to repository #{Review.find_by(pr: r).repository.ghid}"
        end
    end
end
