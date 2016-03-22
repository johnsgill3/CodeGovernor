require 'test_helper'

class RepositoriesHelperTest < ActionView::TestCase
    include RepositoriesHelper

    test 'add repository' do
        user = users("user_#{Random.new.rand(100)}".to_sym)
        RepositoriesHelper.add_repository(9999, user)
    end
end
