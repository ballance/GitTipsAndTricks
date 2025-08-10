#!/bin/bash

# Git Playground Setup Script
# Creates a safe environment for practicing Git commands

set -e  # Exit on error

echo "🎮 Git Playground Setup Script"
echo "=============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: Git is not installed!${NC}"
    echo "Please install Git first: https://git-scm.com/downloads"
    exit 1
fi

# Get Git version
GIT_VERSION=$(git --version)
echo -e "${GREEN}✓ Found $GIT_VERSION${NC}"
echo ""

# Create playground directory
PLAYGROUND_DIR="$HOME/git-playground"
if [ -d "$PLAYGROUND_DIR" ]; then
    echo -e "${YELLOW}Warning: Playground directory already exists at $PLAYGROUND_DIR${NC}"
    read -p "Do you want to delete it and start fresh? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$PLAYGROUND_DIR"
        echo -e "${GREEN}✓ Removed old playground${NC}"
    else
        echo "Exiting without changes."
        exit 0
    fi
fi

echo "Creating Git playground at: $PLAYGROUND_DIR"
mkdir -p "$PLAYGROUND_DIR"
cd "$PLAYGROUND_DIR"

# Function to create a sample repository
create_sample_repo() {
    local repo_name=$1
    local description=$2
    
    echo ""
    echo -e "${GREEN}Creating repository: $repo_name${NC}"
    echo "  $description"
    
    mkdir -p "$repo_name"
    cd "$repo_name"
    git init --quiet
    
    # Create initial structure
    echo "# $repo_name" > README.md
    echo "This is a playground repository for practicing Git." >> README.md
    echo "" >> README.md
    echo "Created: $(date)" >> README.md
    
    # Create .gitignore
    cat > .gitignore << EOF
# IDE files
.vscode/
.idea/
*.swp
*.swo
.DS_Store

# Build files
build/
dist/
*.log
node_modules/
__pycache__/
*.pyc
EOF
    
    git add .
    git commit -m "Initial commit" --quiet
    
    cd ..
}

# Create multiple sample repositories
create_sample_repo "learn-basics" "For practicing basic Git commands"
create_sample_repo "branch-practice" "For practicing branching and merging"
create_sample_repo "conflict-resolution" "For practicing merge conflict resolution"
create_sample_repo "collaboration-sim" "For simulating team collaboration"

# Create a more complex repository with history
echo ""
echo -e "${GREEN}Creating repository: complex-history${NC}"
echo "  Repository with complex commit history for advanced exercises"

mkdir -p "complex-history"
cd "complex-history"
git init --quiet

# Create multiple files and commits to build history
echo "# Complex History Repo" > README.md
git add README.md
git commit -m "Initial commit" --quiet

# Create feature branch with commits
git checkout -b feature-1 --quiet
echo "Feature 1 content" > feature1.txt
git add feature1.txt
git commit -m "Add feature 1" --quiet

echo "Feature 1 enhancement" >> feature1.txt
git add feature1.txt
git commit -m "Enhance feature 1" --quiet

# Create another feature branch from main
git checkout main --quiet
git checkout -b feature-2 --quiet
echo "Feature 2 content" > feature2.txt
git add feature2.txt
git commit -m "Add feature 2" --quiet

# Create a bugfix branch
git checkout main --quiet
git checkout -b bugfix --quiet
echo "Bug fix content" > bugfix.txt
git add bugfix.txt
git commit -m "Fix critical bug" --quiet

# Merge some branches
git checkout main --quiet
git merge feature-1 --no-ff -m "Merge feature-1 into main" --quiet
git merge bugfix --no-ff -m "Merge bugfix into main" --quiet

# Create tags
git tag -a v1.0 -m "Version 1.0 release" --quiet
git tag -a v1.1 -m "Version 1.1 with bugfix" --quiet

cd ..

# Create a repository for bisect practice
echo ""
echo -e "${GREEN}Creating repository: bisect-practice${NC}"
echo "  Repository for practicing git bisect"

mkdir -p "bisect-practice"
cd "bisect-practice"
git init --quiet

# Create a series of commits, one will have a "bug"
echo "STATUS: OK" > app.js
git add app.js
git commit -m "Initial working version" --quiet

for i in {1..10}; do
    echo "Feature $i" > "feature$i.txt"
    git add "feature$i.txt"
    git commit -m "Add feature $i" --quiet
done

# Introduce the "bug"
echo "STATUS: ERROR" > app.js
git add app.js
git commit -m "Update app status" --quiet

for i in {11..20}; do
    echo "Feature $i" > "feature$i.txt"
    git add "feature$i.txt"
    git commit -m "Add feature $i" --quiet
done

cd ..

# Create useful Git aliases
echo ""
echo -e "${GREEN}Setting up useful Git aliases...${NC}"

git config --global alias.st "status -sb"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.visual "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
git config --global alias.contrib "shortlog --summary --numbered"

echo "✓ Aliases configured:"
echo "  - git st      → status -sb"
echo "  - git co      → checkout"
echo "  - git br      → branch"
echo "  - git ci      → commit"
echo "  - git unstage → reset HEAD --"
echo "  - git last    → log -1 HEAD"
echo "  - git visual  → graphical log view"
echo "  - git contrib → contributor statistics"

# Create a cheat sheet
echo ""
echo -e "${GREEN}Creating Git cheat sheet...${NC}"

cat > "$PLAYGROUND_DIR/GIT_CHEATSHEET.md" << 'EOF'
# Git Cheat Sheet 📝

## Essential Commands

### Setup & Config
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --list  # Show all settings
```

### Creating Repositories
```bash
git init                      # Initialize local repo
git clone <url>               # Clone remote repo
```

### Basic Workflow
```bash
git status                    # Check status
git add <file>                # Stage specific file
git add .                     # Stage all changes
git commit -m "message"       # Commit staged changes
git push                      # Push to remote
git pull                      # Pull from remote
```

### Branching & Merging
```bash
git branch                    # List branches
git branch <name>             # Create branch
git checkout <name>           # Switch branch
git checkout -b <name>        # Create & switch
git merge <branch>            # Merge branch
git branch -d <name>          # Delete branch
```

### Viewing History
```bash
git log                       # View commits
git log --oneline            # Compact view
git log --graph              # Show branch graph
git diff                     # Show unstaged changes
git diff --staged            # Show staged changes
```

### Undoing Changes
```bash
git restore <file>            # Discard changes
git restore --staged <file>   # Unstage file
git reset --soft HEAD~1       # Undo last commit, keep changes
git reset --hard HEAD~1       # Undo last commit, discard changes
git revert <commit>          # Create new commit that undoes changes
```

### Stashing
```bash
git stash                    # Stash changes
git stash list              # List stashes
git stash pop               # Apply & remove stash
git stash apply             # Apply but keep stash
```

### Remote Repositories
```bash
git remote -v               # Show remotes
git remote add <name> <url> # Add remote
git fetch                   # Download changes
git push -u origin main     # Push & set upstream
```

### Advanced
```bash
git rebase <branch>         # Rebase current branch
git cherry-pick <commit>    # Apply specific commit
git bisect start            # Start binary search
git reflog                  # Show reference log
```

## Tips & Tricks

1. **Undo `git add`**: `git reset <file>`
2. **Amend last commit**: `git commit --amend`
3. **Show branch graph**: `git log --graph --oneline --all`
4. **Clean untracked files**: `git clean -fd`
5. **Fetch all remotes**: `git fetch --all`
6. **Push all tags**: `git push --tags`
7. **Delete remote branch**: `git push origin --delete <branch>`
8. **Checkout remote branch**: `git checkout -b <branch> origin/<branch>`

## Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

Types: feat, fix, docs, style, refactor, test, chore

Example:
```
feat: add user authentication

Implemented JWT-based authentication system with
refresh tokens and password reset functionality.

Closes #123
```
EOF

# Create practice scenarios
echo ""
echo -e "${GREEN}Creating practice scenarios...${NC}"

cat > "$PLAYGROUND_DIR/PRACTICE_SCENARIOS.md" << 'EOF'
# Git Practice Scenarios 🎯

## Scenario 1: The Accidental Commit
You've accidentally committed a file with passwords. Remove it from history!

**Setup:**
```bash
cd ~/git-playground/learn-basics
echo "password=secret123" > passwords.txt
git add . && git commit -m "Add config"
```

**Goal:** Remove passwords.txt from Git history completely

## Scenario 2: The Messy History
Your feature branch has 10 messy commits. Clean it up before merging!

**Setup:**
```bash
cd ~/git-playground/branch-practice
git checkout -b messy-feature
for i in {1..10}; do
    echo "Change $i" >> feature.txt
    git add . && git commit -m "WIP $i"
done
```

**Goal:** Squash into 1-3 meaningful commits

## Scenario 3: The Conflicting Teams
Two developers changed the same file differently. Resolve the conflict!

**Setup:**
```bash
cd ~/git-playground/conflict-resolution
echo "Original content" > shared.txt
git add . && git commit -m "Add shared file"
git checkout -b dev-1
echo "Developer 1 changes" > shared.txt
git add . && git commit -m "Dev 1 changes"
git checkout main
git checkout -b dev-2
echo "Developer 2 changes" > shared.txt
git add . && git commit -m "Dev 2 changes"
git checkout main
git merge dev-1
git merge dev-2  # Conflict!
```

**Goal:** Resolve conflict keeping both changes

## Scenario 4: The Lost Commit
You deleted a branch but need a commit from it!

**Setup:**
```bash
cd ~/git-playground/collaboration-sim
git checkout -b important-feature
echo "Critical fix" > critical.txt
git add . && git commit -m "Critical fix that we need"
git checkout main
git branch -D important-feature  # Oops!
```

**Goal:** Recover the lost commit using reflog

## Scenario 5: The Time Machine
Find which commit introduced a bug using git bisect.

**Setup:** Use the bisect-practice repository

**Goal:** Find the exact commit that changed STATUS from OK to ERROR
EOF

# Final summary
echo ""
echo "=============================="
echo -e "${GREEN}✅ Git Playground Setup Complete!${NC}"
echo ""
echo "📁 Location: $PLAYGROUND_DIR"
echo ""
echo "📚 Created repositories:"
echo "  - learn-basics/         Basic Git commands"
echo "  - branch-practice/      Branching and merging"
echo "  - conflict-resolution/  Merge conflicts"
echo "  - collaboration-sim/    Team collaboration"
echo "  - complex-history/      Advanced exercises"
echo "  - bisect-practice/      Git bisect practice"
echo ""
echo "📄 Documentation:"
echo "  - GIT_CHEATSHEET.md     Quick reference"
echo "  - PRACTICE_SCENARIOS.md Practice exercises"
echo ""
echo "🚀 Get started:"
echo "  cd $PLAYGROUND_DIR"
echo "  cat PRACTICE_SCENARIOS.md"
echo ""
echo "💡 Tip: Try 'git visual' in any repo to see a graphical history!"
echo ""