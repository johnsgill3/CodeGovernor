## Code Reviewer Design

### Events
The following events need to be handled:

Name | Description
---- | ------------
issue_comment | Any time an Issue or Pull Request is commented on.
pull_request | Any time a Pull Request is assigned, unassigned, labeled, unlabeled, opened, closed, reopened, or synchronized (updated due to a new push in the branch that the pull request is tracking).
status | Any time a Repository has a status update from the API

### Event Actions
1. pull_request[opened]
    * Apply Label 'CR: Not Completed'
    * Record `payload['number']`
    * Record `payload['pull_request']['user']['login']`
    * Request `payload['pullrequest']['_links']['commits']`
        * Record `payload['sha']`
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
    * Mark Pull Request as no longer tracked
1. pull_request[reopened]
    * TODO
1. issue_comment
    * Check if `payload['issue']['pull_request]` data exists
    * Check if `payload['issue']['number']` is tracked Pull Request
    * Record `payload['issue']['user']['login']`
    * Check if `payload['comment']['body']` Contains `KEYWORD_STRING`
    * Check if all Reviewers commented
        * Update all commit status 'success'
        * Apply Label 'CR: Completed'

### Scopes Required
1. `repo:`
1. `admin:repo_hook`
1.

### Menus
1. Repositories (Enable/Disable) - octokit.all_repositories()
    * Enable Disable WebHook for service - octokit.create_hook()
    * Branches (Enable/Disable) - octokit.protect_branch()
1. Files (add/remove manually)
1. File Owners (update)
1. FileTypes (add/update)
1. Users (add/remove)
1. Display Files

### Record Types
1. Repository
    - name:string
    - enabled:boolean
1. Branch
    - name:string
    - enabled:boolean
1. User
    - name:string
    - email:string
1. File
    - name:string
    - directory:string
    - ?
1. Pull_Request
    - number:integer
    - ?
1. Approval
1. Commit
    - sha:string
1. FileType
    - extension:string

#### Relations
Rails supports the following relationships. Go through each record type and mark down the associations between them.
```ruby
belongs_to
has_one
has_many
has_many :through
has_one :through
has_and_belongs_to_many
```
``` ruby
class Repository  < ActiveRecord::Base
    has_many :branches
    has_many :files
    has_many :users, through: :files
    has_many :file_types, through: :files
    has_many :pull_requests
    has_many :commits, through: :pull_requests
    has_many :approvals, through: :pull_requests
end

class Branch < ActiveRecord::Base
    belongs_to :repository
end

class File  < ActiveRecord::Base
    belongs_to :repository
    has_and_belongs_to_many :users
    has_one :file_type
end

class FileType < ActiveRecord::Base
    has_many :files
end

class User  < ActiveRecord::Base
    has_and_belongs_to_many :repositories
    has_and_belongs_to_many :files
end

class Pull_Request  < ActiveRecord::Base
    belongs_to :repository
    has_many :commits
    has_one :user
    has_many :approvals
end

class Commit  < ActiveRecord::Base
    belongs_to :pull_request
end

class Approval  < ActiveRecord::Base
    belongs_to :user
    belongs_to :pull_request
end
```

### Sample Queries
```SQL
SELECT COUNT(*)
FROM Approvals a, Repositories r, Pull_Requests pr
WHERE a.r_id=r.id
AND a.pr_id=pr.id

SELECT UNIQUE f.Name
    CASE WHEN @user=f.Primary THEN u.Name
    ELSE f.Primary
    END
FROM Files f, Users u
WHERE f.
```

### TODO Items
1. pull_request[reopened]
1. File Owner History
1. Organizations/Teams
1. Re-Reviews?
