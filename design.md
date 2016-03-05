## Code Reviewer Design

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
