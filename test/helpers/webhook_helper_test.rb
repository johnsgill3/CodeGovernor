require 'test_helper'

class WebhookHelperTest < ActionView::TestCase
    include WebhookHelper

    test 'review override regex' do
        repo = repositories(:test_repo)
        test_string = "Made changes to the README to trigger web hookl\r\n\r\nCG_REVIEWER_OVERRIDE\r\n- dir1/README.md = @truser3\r\n* README.md = @truser4"
        WebhookHelper.get_review_overrides(test_string, repo)

        test_json = JSON.parse(File.read(File.dirname(__FILE__) + '/../mock/data/hook_pr_opened2.json'))
        WebhookHelper.get_review_overrides(test_json['pull_request']['body'], repo)
    end
end
