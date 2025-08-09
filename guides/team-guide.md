# Git for Team Collaboration 👥

Best practices and workflows for teams using Git effectively together.

## Table of Contents
1. [Team Workflows](#team-workflows)
2. [Branching Strategies](#branching-strategies)
3. [Code Review Process](#code-review-process)
4. [Conflict Resolution](#conflict-resolution)
5. [Communication Standards](#communication-standards)
6. [Team Policies](#team-policies)
7. [Collaboration Tools](#collaboration-tools)
8. [Common Team Scenarios](#common-team-scenarios)

---

## Team Workflows

### Git Flow

Traditional workflow for teams with scheduled releases:

```
main
  ↓
develop
  ├── feature/user-auth
  ├── feature/payment
  └── feature/dashboard
  
release/1.0
  └── hotfix/critical-bug
```

#### Setup Git Flow
```bash
# Initialize git flow
git flow init

# Start feature
git flow feature start user-auth

# Finish feature
git flow feature finish user-auth

# Start release
git flow release start 1.0

# Finish release
git flow release finish 1.0
```

### GitHub Flow

Simplified workflow for continuous deployment:

```
main
  ├── feature-branch-1
  ├── feature-branch-2
  └── fix-bug-123
```

#### GitHub Flow Process
1. Create branch from main
2. Make changes
3. Open pull request
4. Code review
5. Deploy to production
6. Merge to main

### GitLab Flow

Environment-based workflow:

```
main → pre-production → production
  ↑
feature branches
```

## Branching Strategies

### Branch Naming Conventions

```bash
# Feature branches
feature/JIRA-123-user-authentication
feature/add-payment-gateway

# Bug fixes
bugfix/JIRA-456-login-error
fix/header-alignment

# Hotfixes
hotfix/critical-security-patch

# Chores
chore/update-dependencies
chore/refactor-utils

# Experiments
experiment/new-algorithm
spike/performance-testing
```

### Branch Protection Rules

```bash
# GitHub CLI example
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["continuous-integration"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":2}'
```

### Branch Policies

```yaml
# .github/branch-protection.yml
protection_rules:
  - name: main
    required_reviews: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
    required_status_checks:
      - CI/Build
      - CI/Test
      - CI/Lint
    enforce_admins: false
    restrictions:
      users: []
      teams: ["admins"]
```

## Code Review Process

### Pull Request Template

```markdown
<!-- .github/pull_request_template.md -->
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings generated

## Screenshots (if applicable)

## Related Issues
Fixes #(issue number)
```

### Code Review Checklist

#### For Reviewers
- **Functionality**: Does it work as intended?
- **Design**: Is the code well-structured?
- **Complexity**: Can it be simplified?
- **Tests**: Are there adequate tests?
- **Naming**: Are names clear and consistent?
- **Comments**: Is complex logic explained?
- **Documentation**: Are docs updated?
- **Performance**: Any performance concerns?
- **Security**: Any security issues?

### Review Comments Best Practices

```markdown
# Good Review Comments

## Suggesting improvement
```suggestion
Consider using a more descriptive variable name here:
const userData = await fetchUser(id);
```

## Asking for clarification
Could you explain why we need this timeout here? 
Is it for rate limiting or another reason?

## Praising good code
Great error handling here! This will help debugging.

## Requesting changes
This could cause a memory leak. Consider using:
```javascript
useEffect(() => {
  return () => cleanup();
}, []);
```
```

## Conflict Resolution

### Preventing Conflicts

```bash
# Regular syncing
git pull --rebase origin main

# Before starting work
git checkout main
git pull
git checkout -b feature-branch

# During long-running features
git fetch origin
git rebase origin/main
```

### Resolving Conflicts as a Team

#### Communication Protocol
1. **Notify team** when conflicts arise
2. **Collaborate** with author of conflicting code
3. **Test thoroughly** after resolution
4. **Document** resolution decisions

#### Conflict Resolution Strategies

```bash
# Strategy 1: Rebase (keeps linear history)
git checkout feature-branch
git rebase main
# Resolve conflicts
git add .
git rebase --continue

# Strategy 2: Merge (preserves branch context)
git checkout feature-branch
git merge main
# Resolve conflicts
git add .
git commit

# Strategy 3: Squash and rebase
git rebase -i main
# Squash commits first, then resolve conflicts once
```

### Using Rerere for Teams

```bash
# Enable rerere globally
git config --global rerere.enabled true

# Share rerere cache with team
# Add to .gitignore: .git/rr-cache
# Create shared rerere branch
git checkout --orphan rerere-cache
cp -r .git/rr-cache .
git add rr-cache
git commit -m "Share rerere cache"
```

## Communication Standards

### Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance

#### Examples
```bash
feat(auth): add OAuth2 integration

Implemented Google and GitHub OAuth2 providers
with automatic token refresh functionality.

Closes #234
Co-authored-by: Jane Doe <jane@example.com>
```

### Commit Message Enforcement

```bash
# commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'subject-case': [2, 'never', ['upper-case']],
    'subject-max-length': [2, 'always', 72],
    'body-max-line-length': [2, 'always', 80],
    'type-enum': [
      2,
      'always',
      ['feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore']
    ]
  }
};
```

## Team Policies

### Git Configuration Standards

```bash
# Team .gitmessage template
git config --global commit.template ~/.gitmessage

# Standard aliases for team
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'

# Rebase by default
git config --global pull.rebase true

# Auto-stash on rebase
git config --global rebase.autoStash true
```

### Team .gitignore

```gitignore
# OS Files
.DS_Store
Thumbs.db
desktop.ini

# IDE Files
.vscode/
.idea/
*.sublime-*
*.swp
*.swo

# Dependencies
node_modules/
vendor/
bower_components/

# Build outputs
dist/
build/
out/
*.log

# Environment files
.env
.env.local
.env.*.local

# Test coverage
coverage/
.nyc_output/
```

### CODEOWNERS File

```
# .github/CODEOWNERS

# Global owners
* @teamlead @senior-dev

# Frontend
/frontend/ @frontend-team
/src/components/ @ui-team
*.css @design-team
*.scss @design-team

# Backend
/backend/ @backend-team
/api/ @api-team
/database/ @database-team

# DevOps
/docker/ @devops-team
/.github/ @devops-team
/k8s/ @devops-team

# Documentation
/docs/ @docs-team
*.md @docs-team
```

## Collaboration Tools

### Git Hooks for Teams

#### Shared Hooks with Husky

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS",
      "pre-push": "npm test"
    }
  },
  "lint-staged": {
    "*.js": ["eslint --fix", "git add"],
    "*.{json,md}": ["prettier --write", "git add"]
  }
}
```

### Team Aliases

```bash
# ~/.gitconfig
[alias]
    # Team workflow
    start = "!f() { git checkout main && git pull && git checkout -b $1; }; f"
    
    # Update branch with main
    update = "!git fetch origin && git rebase origin/main"
    
    # Clean merged branches
    cleanup = "!git branch --merged | grep -v '\\*\\|main\\|develop' | xargs -n 1 git branch -d"
    
    # Show team contributions
    team = "shortlog -sn --all --no-merges"
    
    # Show recent team activity
    standup = "log --since='yesterday' --author='.*' --oneline"
    
    # Prepare for PR
    pr-ready = "!git update && git test && git lint"
```

### Integration Tools

#### Slack Integration

```yaml
# .github/workflows/slack-notify.yml
name: Slack Notification
on:
  pull_request:
    types: [opened, closed]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: 'PR ${{ github.event.pull_request.title }} was ${{ github.event.action }}'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Common Team Scenarios

### Scenario 1: Multiple People on Same Feature

```bash
# Developer A starts feature
git checkout -b feature/big-feature
git push -u origin feature/big-feature

# Developer B joins
git fetch origin
git checkout feature/big-feature

# Developer B makes changes
git add .
git commit -m "Add my part"
git pull --rebase origin feature/big-feature
git push

# Developer A gets changes
git pull --rebase
```

### Scenario 2: Emergency Hotfix Process

```bash
# 1. Create hotfix from production
git checkout production
git pull origin production
git checkout -b hotfix/critical-fix

# 2. Make fix
# ... make changes ...
git add .
git commit -m "fix: resolve critical production issue"

# 3. Test locally
npm test

# 4. Push and create PR
git push origin hotfix/critical-fix
gh pr create --base production --title "Hotfix: Critical issue"

# 5. After merge, sync with main
git checkout main
git pull origin main
git merge production
git push origin main
```

### Scenario 3: Feature Flag Workflow

```bash
# Working with feature flags
git checkout -b feature/new-feature-flagged

# Add feature behind flag
cat > feature.js << 'EOF'
if (featureFlags.newFeature) {
  // New feature code
} else {
  // Existing code
}
EOF

# Can merge to main safely
git add .
git commit -m "feat: add new feature behind flag"
git push origin feature/new-feature-flagged
```

### Scenario 4: Pair Programming

```bash
# Using Co-authored-by
git commit -m "feat: implement user authentication

Co-authored-by: Alice <alice@example.com>
Co-authored-by: Bob <bob@example.com>"

# Or use pair tool
npm install -g git-pair
git pair add alice "Alice Smith" alice@example.com
git pair add bob "Bob Jones" bob@example.com
git pair alice bob
```

## Team Metrics

### Git Statistics

```bash
# Contribution stats
git shortlog -sn --all

# Lines of code per author
git ls-files | xargs -n1 git blame --line-porcelain | grep "^author " | sort | uniq -c | sort -nr

# Commits per day of week
git log --format="%ad" --date=format:"%a" | sort | uniq -c

# Most changed files
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -20

# Commit frequency
git log --format="%ad" --date=short | uniq -c
```

## Best Practices Summary

### ✅ DO
- **Communicate** before making breaking changes
- **Pull frequently** to avoid conflicts
- **Review carefully** - you're responsible for code you approve
- **Test locally** before pushing
- **Document decisions** in commit messages
- **Use draft PRs** for work in progress
- **Tag releases** consistently

### ❌ DON'T
- **Don't force push** to shared branches
- **Don't commit directly** to main
- **Don't merge** without reviews
- **Don't ignore** CI failures
- **Don't rush** hotfixes without testing
- **Don't blame** - focus on fixing

## Team Learning Resources

### Workshops Ideas
1. **Git Basics** - For new team members
2. **Conflict Resolution** - Practice session
3. **Git Internals** - Deep dive
4. **Workflow Optimization** - Team retrospective
5. **Security Best Practices** - Secure coding

### Team Exercises

```bash
# Exercise 1: Conflict Resolution Kata
./scripts/create-conflict-exercise.sh

# Exercise 2: Rebase Practice
./scripts/create-rebase-exercise.sh

# Exercise 3: Code Review Simulation
./scripts/create-review-exercise.sh
```

---

🤝 **Great teams use great Git practices!** These collaboration techniques will help your team work more efficiently and with fewer conflicts.

Continue with our [CI/CD Integration Guide](cicd-guide.md) to automate your team workflows!