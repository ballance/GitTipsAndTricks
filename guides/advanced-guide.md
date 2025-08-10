# Advanced Git Techniques 🎓

Master-level Git techniques for power users and professionals.

## Table of Contents
1. [Git Internals](#git-internals)
2. [Advanced Rebasing](#advanced-rebasing)
3. [Reflog Mastery](#reflog-mastery)
4. [Advanced Merging](#advanced-merging)
5. [Performance Optimization](#performance-optimization)
6. [Advanced Workflows](#advanced-workflows)
7. [Automation & Hooks](#automation--hooks)
8. [Troubleshooting](#troubleshooting)

---

## Git Internals

### Understanding Git Objects

Git stores everything as objects in `.git/objects/`:

```bash
# See object types
git cat-file -t <hash>  # blob, tree, commit, tag

# See object contents
git cat-file -p <hash>

# Inspect objects
find .git/objects -type f | head -5
```

### The Three Trees

```
Working Directory ← Index (Staging) ← HEAD
                 ↑                  ↑
            git add            git commit
```

### Plumbing vs Porcelain Commands

```bash
# Porcelain (user-friendly)
git log

# Plumbing (low-level)
git rev-list --all
git ls-tree HEAD
git write-tree
git commit-tree
```

### Pack Files & Optimization

```bash
# See repository size
git count-objects -vH

# Garbage collection
git gc --aggressive --prune=now

# Repack objects
git repack -a -d -f --depth=250 --window=250
```

## Advanced Rebasing

### Interactive Rebase Techniques

```bash
# Rebase last N commits
git rebase -i HEAD~N

# Rebase onto different branch
git rebase --onto target-branch source-branch topic-branch

# Preserve merge commits
git rebase -i --preserve-merges master

# Autosquash commits
git commit --fixup=<commit>
git rebase -i --autosquash
```

### Rebase Commands
- `pick` - use commit
- `reword` - use commit, edit message
- `edit` - use commit, stop for amending
- `squash` - use commit, meld into previous
- `fixup` - like squash, discard message
- `exec` - run command
- `drop` - remove commit

### Advanced Rebase Example

```bash
# Split a commit
git rebase -i HEAD~3
# Mark commit as 'edit'
git reset HEAD^
git add -p  # Stage partial changes
git commit -m "First part"
git add .
git commit -m "Second part"
git rebase --continue
```

### Rebase with Exec

```bash
# Run tests after each commit
git rebase -i --exec "npm test" HEAD~5

# Format code during rebase
git rebase -i --exec "prettier --write ." HEAD~3
```

## Reflog Mastery

### Understanding Reflog

```bash
# View reflog
git reflog
git reflog show HEAD
git reflog show branch-name

# Detailed reflog
git reflog --date=iso
git reflog --all

# Expire reflog entries
git reflog expire --expire=30.days --all
```

### Recovery Patterns

```bash
# Recover deleted branch
git reflog | grep "branch-name"
git checkout -b recovered-branch HEAD@{n}

# Undo destructive operation
git reset --hard HEAD@{1}

# Find lost commits
git fsck --full --no-reflogs --unreachable --lost-found
```

### Time-based Recovery

```bash
# Go back in time
git checkout HEAD@{yesterday}
git checkout HEAD@{2.hours.ago}
git checkout HEAD@{2021-01-01}

# Diff with past state
git diff HEAD@{1.week.ago} HEAD
```

## Advanced Merging

### Merge Strategies

```bash
# Recursive (default)
git merge -s recursive branch

# Ours - keep our version
git merge -s ours branch

# Octopus - merge multiple branches
git merge branch1 branch2 branch3

# Subtree
git merge -s subtree branch
```

### Merge Options

```bash
# No fast-forward
git merge --no-ff feature

# Squash merge
git merge --squash feature

# Merge with custom message
git merge feature -m "Custom merge message"

# Abort merge
git merge --abort
```

### Advanced Conflict Resolution

```bash
# Use theirs for specific files
git checkout --theirs path/to/file
git add path/to/file

# Use ours for specific files
git checkout --ours path/to/file

# Merge individual hunks
git checkout -p branch file

# Three-way merge tool
git mergetool --tool=vimdiff
```

### Rerere (Reuse Recorded Resolution)

```bash
# Enable rerere
git config --global rerere.enabled true

# View rerere status
git rerere status

# Forget recorded resolution
git rerere forget path/to/file

# Manually train rerere
git rerere
```

## Performance Optimization

### Large Repository Management

```bash
# Shallow clone
git clone --depth 1 <url>

# Partial clone
git clone --filter=blob:none <url>

# Sparse checkout
git sparse-checkout init --cone
git sparse-checkout set dir1 dir2

# Single branch clone
git clone --single-branch --branch main <url>
```

### Git LFS (Large File Storage)

```bash
# Track large files
git lfs track "*.psd"
git lfs track "assets/**/*.mp4"

# View tracked patterns
git lfs track

# Migrate existing files
git lfs migrate import --include="*.zip" --everything

# Fetch LFS objects
git lfs fetch --all
```

### Performance Tuning

```bash
# Increase buffer size
git config --global http.postBuffer 524288000

# Enable parallel index
git config --global core.preloadindex true

# Multi-threaded operations
git config --global pack.threads 0
git config --global index.threads 0

# Filesystem monitor
git config core.fsmonitor true
```

## Advanced Workflows

### Worktrees

```bash
# Add worktree
git worktree add ../project-hotfix hotfix-branch

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../project-hotfix

# Prune worktree info
git worktree prune
```

### Submodules

```bash
# Add submodule
git submodule add <url> path/to/submodule

# Initialize and update
git submodule update --init --recursive

# Update to latest
git submodule update --remote --merge

# Foreach command
git submodule foreach 'git pull origin main'

# Remove submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
```

### Subtrees

```bash
# Add subtree
git subtree add --prefix=vendor/lib <url> main --squash

# Pull updates
git subtree pull --prefix=vendor/lib <url> main --squash

# Push changes
git subtree push --prefix=vendor/lib <url> main

# Split into branch
git subtree split --prefix=vendor/lib -b lib-branch
```

### Bisect Automation

```bash
# Start bisect
git bisect start
git bisect bad HEAD
git bisect good v1.0

# Automated bisect
git bisect run npm test

# Bisect with script
cat > test.sh << 'EOF'
#!/bin/bash
make && ./test || exit 1
EOF
chmod +x test.sh
git bisect run ./test.sh

# Skip commits
git bisect skip

# Visualize bisect
git bisect visualize
```

## Automation & Hooks

### Git Hooks

```bash
# Client-side hooks location
ls .git/hooks/

# Server-side hooks
# pre-receive, update, post-receive
```

### Advanced Hook Examples

#### pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Check for debugging statements
if git diff --cached | grep -E "console\.(log|debug|info|warn|error)"; then
    echo "Remove console statements"
    exit 1
fi

# Run linter
npm run lint-staged || exit 1

# Check commit size
if [ $(git diff --cached --numstat | wc -l) -gt 100 ]; then
    echo "Large commit detected. Consider splitting."
    read -p "Continue? (y/n) " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
fi
```

#### commit-msg Hook
```bash
#!/bin/bash
# .git/hooks/commit-msg

# Enforce conventional commits
commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'
if ! grep -qE "$commit_regex" "$1"; then
    echo "Invalid commit message format!"
    echo "Format: type(scope): description"
    exit 1
fi

# Add ticket number
branch=$(git symbolic-ref --short HEAD)
ticket=$(echo "$branch" | grep -oE '[A-Z]+-[0-9]+')
if [ -n "$ticket" ] && ! grep -q "$ticket" "$1"; then
    echo "" >> "$1"
    echo "Ref: $ticket" >> "$1"
fi
```

### Git Aliases

```bash
# Complex aliases
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.undo 'reset --soft HEAD~1'

# Shell command aliases
git config --global alias.clean-branches '!git branch --merged | grep -v "main\|master" | xargs -n 1 git branch -d'

# Function aliases
git config --global alias.feature '!f() { git checkout -b feature/$1; }; f'

# Interactive add
git config --global alias.ai 'add -i'

# Pretty log
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

## Troubleshooting

### Corrupt Repository

```bash
# Check repository integrity
git fsck --full

# Recover from backup
cp -R .git .git.backup
git init
git remote add origin <url>
git fetch
git reset --hard origin/main

# Rebuild index
rm .git/index
git reset

# Fix broken HEAD
echo "ref: refs/heads/main" > .git/HEAD
```

### Advanced Cleanup

```bash
# Remove file from all history
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD

# BFG Repo Cleaner (faster alternative)
bfg --delete-files passwords.txt
bfg --replace-text passwords.txt

# Clean reflog and garbage collect
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Performance Issues

```bash
# Profile Git commands
GIT_TRACE_PERFORMANCE=1 git status

# Debug Git operations
GIT_TRACE=1 git pull

# Trace pack operations
GIT_TRACE_PACK_ACCESS=1 git log

# Monitor filesystem
GIT_TRACE_FSMONITOR=1 git status
```

## Advanced Patterns

### Monorepo Management

```bash
# Sparse checkout for monorepo
git sparse-checkout init
git sparse-checkout set apps/frontend libs/shared

# Split monorepo
git subtree split --prefix=apps/backend -b backend-only

# Filter branch for extraction
git filter-branch --subdirectory-filter apps/frontend -- --all
```

### Git Attributes

```gitattributes
# .gitattributes
*.jpg binary
*.png binary

# Custom diff drivers
*.json diff=json
*.md diff=markdown

# Clean/smudge filters
*.js filter=prettier

# Export ignore
docs/ export-ignore
tests/ export-ignore

# Merge drivers
changelog.md merge=union
```

### Custom Merge Drivers

```bash
# Configure merge driver
git config merge.ours.driver true

# In .gitattributes
database.json merge=ours

# Custom merge script
git config merge.custom.driver "custom-merge %O %A %B %L"
```

## Security Patterns

### Signed Commits

```bash
# GPG signing
git config --global user.signingkey <key-id>
git config --global commit.gpgsign true

# SSH signing (Git 2.34+)
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Verify commits
git verify-commit HEAD
git log --show-signature
```

### Protected Branches

```bash
# Pre-push hook to protect main
#!/bin/bash
protected_branch='main'
current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

if [ $protected_branch = $current_branch ]; then
    read -p "Push to main branch? (y/n) " -n 1 -r < /dev/tty
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi
```

## Pro Tips

### 1. Git Blame Enhancement
```bash
# Ignore whitespace
git blame -w file.js

# Ignore moved lines
git blame -M file.js

# Ignore copied lines
git blame -C file.js

# Show email instead of name
git blame -e file.js

# Blame range
git blame -L 10,20 file.js
```

### 2. Advanced Log Queries
```bash
# Find commits by author
git log --author="John\|Jane"

# Find commits by message
git log --grep="bugfix"

# Find commits touching function
git log -L :functionName:file.js

# Find commits by diff content
git log -S"console.log" --source --all

# Commits between dates
git log --since="2 weeks ago" --until="yesterday"
```

### 3. Advanced Stashing
```bash
# Stash with untracked files
git stash -u

# Stash individual files
git stash push -m "message" file1 file2

# Create branch from stash
git stash branch new-branch stash@{0}

# Stash interactively
git stash -p
```

## Command Reference

### Power User Commands

| Command | Purpose |
|---------|---------|
| `git update-index --assume-unchanged file` | Ignore local changes |
| `git ls-files --others --ignored --exclude-standard` | List ignored files |
| `git check-ignore -v file` | Debug .gitignore |
| `git grep "pattern" $(git rev-list --all)` | Search all history |
| `git shortlog -sn --all` | Contributor stats |
| `git for-each-ref --format='%(refname:short)'` | List all references |
| `git rev-parse HEAD` | Get commit hash |
| `git describe --tags --always` | Describe current commit |
| `git archive --format=zip HEAD > archive.zip` | Create archive |

---

🚀 **You've mastered advanced Git!** These techniques will make you incredibly efficient at version control. Remember: with great power comes great responsibility - especially when rewriting history!

Continue learning with our [Team Collaboration Guide](team-guide.md) or [CI/CD Integration Guide](cicd-guide.md).