## Code Ownership Design

### Events
The following events need to be handled:

Name | Description
---- | ------------
commit_comment | Any time a Commit is commented on.
issue_comment | Any time an Issue or Pull Request is commented on.
pull_request_review_comment | Any time a comment is created on a portion of the unified diff of a pull request (the Files Changed tab).
pull_request | Any time a Pull Request is assigned, unassigned, labeled, unlabeled, opened, closed, reopened, or synchronized (updated due to a new push in the branch that the pull request is tracking).
status | Any time a Repository has a status update from the API

### Event Flows
1. pull_request[opened]
    * Record `payload['number']`
    * Record `payload['pull_request']['user']['login']`
    * Request `payload['pullrequest']['_links']['commits']`
        * Record initial `payload['sha']`
    * Generate List of Reviewers
        * Post to Pull Request
1. pull_request[synchronized] (updated)
    * Request `payload['pullrequest']['_links']['commits']`
        * Record new `payload['sha']`
    * Generate updated list of Reviewers
        * Post to Pull Request
1. pull_request[closed]
    * Add any new files from commits to DB
    * Set Primary Owner to Pull Request author
1. pull_request_review_comment
    * Check if `payload['pull_request']['number']` is tracked Pull Request
    * Record `payload['comment']['user']['login']`
    * Check if all Reviewers commented
        * Update status ('pending', 'success')
1. commit_comment
    * Check if `payload['comment']['commit_id']` is tracked
    * Record `payload['comment']['user']['login']`
    * Check if all Reviewers commented
        * Update status ('pending', 'success')
1. issue_comment
    * Check if `payload['issue']['pull_request]` data exists
    * Check if `payload['issue']['number']` is tracked Pull Request
    * Record `payload['issue']['user']['login']`
    * Check if all Reviewers commented
        * Update status ('pending', 'success')

### Edit Menus
1. File Owners (update)
1. Files (add/remove manually)
1. Users (add/remove)
1. Display Files

### Record Types
1. User
    - Name
    - Email
1. Files
    - Name
    - Full Path
    - Owners (Users)
    - Primary (User)

1. Pull Requests
1. Comments
1. Commits
    - ID
1. Repositories

#### Relations
Repositories have:
    - Files
    - Users
    - Pull Requests
    - Commits
    - Comments

Files have Owners

### Other Ideas
- Branch limiting (Status Checks)
- File Owner History ?
- Repo/Product Scoping (WebHook)
- Filetype Support
- Users Enable/Disabled for Repo
    * API to Create WebHook

### Future work
- Organizations/Teams
