require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
    test 'has users' do
        100.times do |r|
            puts "Repository #{r} has user(s):"
            Repository.find_by(ghid: r).users.each do |u|
                puts "    #{u.nickname}"
            end
        end
    end

    test 'has files' do
        100.times do |r|
            puts "Repository #{r} has file(s):"
            Repository.find_by(ghid: r).g_files.each do |f|
                puts "    #{f.name}"
            end
        end
    end

    test 'has reviews' do
        100.times do |r|
            puts "Repository #{r} has review(s):"
            Repository.find_by(ghid: r).reviews.each do |r|
                puts "    #{r.pr} #{r.state}"
            end
        end
    end

    test 'enabled' do

    end
end
