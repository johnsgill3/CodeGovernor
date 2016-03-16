require 'test_helper'

class GFileTest < ActiveSupport::TestCase
    test 'has repository' do
        GFile.all.each do |file|
            assert_not_nil(file.repository, "Could not find repository for file #{file.id} - #{file.name}")
        end
    end

    test 'has user' do
        GFile.all.each do |file|
            assert_not_nil(file.user, "Could not find user for file #{file.id} - #{file.name}")
        end
    end

    test 'has reviews' do
        GFile.all.each do |file|
            assert_not_empty(file.reviews, "Could not find any reviews for file #{file.id} - #{file.name}")
        end
    end

    test 'valid' do
        GFile.all.each do |file|
            assert(file.valid?, "Invalid file #{file.id}"+file.errors.messages.to_json)
        end
    end

    # Write tests for CRUD actions
    test 'create' do
        # Generate random associations
        prng = Random.new
        user = users("user_#{prng.rand(100)}".to_sym)
        repo = repositories("repo_#{prng.rand(10)}".to_sym)
        reviews = (1..prng.rand(3)).map {|_| reviews("review_#{prng.rand(300)}".to_sym)}

        # Test create via parameters
        fileP = GFile.new(name: "INSTALL1.md",
                         repository: repo,
                         user: user,
                         reviews: reviews)
        assert_not_nil(fileP, "Could not create file via parameters")
        assert(fileP.valid?, "Invalid file #{fileP.name}\n"+fileP.errors.messages.to_json)
        assert(fileP.save!, "Could not save file #{fileP.name}")

        # Test create via attributes
        fileA = GFile.new
        fileA.name = "INSTALL2.md"
        fileA.repository = repo
        fileA.user = user
        fileA.reviews = reviews
        assert_not_nil(fileA, "Could not create file via attributes")
        assert(fileA.valid?, "Invalid file #{fileA.name}\n"+fileA.errors.messages.to_json)
        assert(fileA.save!, "Could not save file #{fileA.name}")

        # Test create via hash
        fileH_param = {
            name: "INSTALL3.md",
            repository: repo,
            user: user,
            reviews: reviews}
        fileH = GFile.new(fileH_param)
        assert_not_nil(fileH, "Could not create file via hash")
        assert(fileH.valid?, "Invalid file #{fileH.name}\n"+fileH.errors.messages.to_json)
        assert(fileH.save!, "Could not save file #{fileH.name}")

        # Test create via block
        fileB = GFile.new do |f|
            f.name = "INSTALL4.md"
            f.repository = repo
            f.user = user
            f.reviews = reviews
        end
        assert_not_nil(fileB, "Could not create file via block")
        assert(fileB.valid?, "Invalid file #{fileB.name}\n"+fileB.errors.messages.to_json)
        assert(fileB.save!, "Could not save file #{fileB.name}")
    end

    test 'update' do
        # Test Single update via attribute
        file = g_files(:file_0)
        assert_not_nil(file, "Could not find file #{:file_0}")
        file.name = "INSTALL.md"
        assert(file.valid?, "Invalid file #{file.id} - #{file.name}"+file.errors.messages.to_json)
        assert(file.save!, "Could not save file #{file.id} - #{file.name}")

        # Test Update via hash
        g_files(:file_1).update(name: "INSTALL.md")
    end

    test 'read' do
        GFile.all.each do |f|
            file = GFile.find_by(id: f.id)
            assert_not_nil(file, "Could not find file with id = #{f.id}")
        end
    end

    test 'delete' do
        file = g_files(:file_0)
        assert_not_nil(file, "Could not find file #{:file_0}")
        assert(file.destroy, "Could not destroy file #{:file_0}")
    end
end
