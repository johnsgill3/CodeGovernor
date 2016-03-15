require 'test_helper'

class GFileTest < ActiveSupport::TestCase
    test 'has repository' do
        1500.times do |f|
            file = g_files("file_#{f}".to_sym)
            assert_not_nil(file, "Could not find file #{f}")
            assert_not_nil(file.repository, "Could not find repository for file #{file.name}")
        end
    end

    test 'has user' do
        1500.times do |f|
            file = g_files("file_#{f}".to_sym)
            assert_not_nil(file, "Could not find file #{f}")
            assert_not_nil(file.user, "Could not find user for file #{file.name}")
        end
    end

    test 'has reviews' do
        1500.times do |f|
            file = g_files("file_#{f}".to_sym)
            assert_not_nil(file, "Could not find file #{f}")
            assert_not_empty(file.reviews, "Could not find any reviews for file #{file.name}")
        end
    end
end
