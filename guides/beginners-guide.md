# Git for Beginners 🌱

Welcome to Git! This guide will take you from zero to confident in version control.

## Table of Contents
1. [What is Git?](#what-is-git)
2. [Why Use Git?](#why-use-git)
3. [Installation](#installation)
4. [First Steps](#first-steps)
5. [Basic Workflow](#basic-workflow)
6. [Common Scenarios](#common-scenarios)
7. [Next Steps](#next-steps)

---

## What is Git?

Git is a **version control system** - think of it as a time machine for your code:
- 📸 Takes snapshots of your project at different points
- ↩️ Lets you go back to any previous version
- 👥 Allows multiple people to work on the same project
- 🔀 Merges everyone's changes together intelligently

### Git vs GitHub
- **Git** = The version control system (tool on your computer)
- **GitHub** = A website that hosts Git repositories (like Google Drive for Git)

## Why Use Git?

### Without Git 😰
```
project_final.doc
project_final_v2.doc
project_final_v2_ACTUALLY_FINAL.doc
project_final_v2_ACTUALLY_FINAL_fixed.doc
project_final_v2_ACTUALLY_FINAL_fixed_johns_edits.doc
```

### With Git 😎
```
project.doc (with complete history of all changes)
```

## Installation

### Windows
1. Download from [git-scm.com](https://git-scm.com/download/win)
2. Run installer (keep default settings)
3. Open "Git Bash" to use Git

### macOS
```bash
# If you have Homebrew:
brew install git

# Or download from git-scm.com
```

### Linux
```bash
# Ubuntu/Debian:
sudo apt-get install git

# Fedora:
sudo dnf install git
```

### Verify Installation
```bash
git --version
# Should show: git version 2.x.x
```

## First Steps

### 1. Configure Your Identity
Git needs to know who you are:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. Create Your First Repository

```bash
# Create a new folder for your project
mkdir my-first-project
cd my-first-project

# Initialize Git in this folder
git init

# You should see: "Initialized empty Git repository..."
```

### 3. Check Status
```bash
git status
# Shows: "On branch main" and "nothing to commit"
```

## Basic Workflow

The Git workflow has three main stages:

```
Working Directory → Staging Area → Repository
     (Edit)           (Add)         (Commit)
```

### Step-by-Step Example

#### 1. Create a File
```bash
echo "# My First Project" > README.md
```

#### 2. Check What Changed
```bash
git status
# Shows: "Untracked files: README.md"
```

#### 3. Stage the File
```bash
git add README.md
# Or stage everything: git add .
```

#### 4. Commit Your Changes
```bash
git commit -m "Add README file"
# The -m flag adds a message describing what you did
```

#### 5. View History
```bash
git log
# Shows your commit with its unique ID, author, date, and message
```

## Common Scenarios

### Scenario 1: "I Made a Mistake!"

#### Undo Changes to a File (Before Staging)
```bash
# You edited file.txt but want to undo
git restore file.txt
```

#### Unstage a File (After git add)
```bash
git restore --staged file.txt
```

#### Undo Last Commit (Keep Changes)
```bash
git reset --soft HEAD~1
```

### Scenario 2: "I Want to Try Something"

Use branches to experiment safely:

```bash
# Create and switch to new branch
git checkout -b experiment

# Make your changes
echo "Experimental feature" > experiment.txt
git add .
git commit -m "Add experimental feature"

# If you like it, merge back:
git checkout main
git merge experiment

# If you don't like it, just delete:
git checkout main
git branch -d experiment
```

### Scenario 3: "Working with GitHub"

#### Clone an Existing Project
```bash
git clone https://github.com/username/repository.git
cd repository
```

#### Connect Local Repo to GitHub
1. Create repository on GitHub (don't initialize with README)
2. Connect your local repo:

```bash
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

#### Get Updates from GitHub
```bash
git pull
```

#### Send Your Changes to GitHub
```bash
git push
```

## Visual Git Workflow

```
┌─────────────────────────────────────────────────┐
│                 LOCAL COMPUTER                   │
│                                                  │
│  ┌─────────────┐  git add   ┌──────────────┐   │
│  │   Working   │ ─────────> │   Staging    │   │
│  │  Directory  │             │     Area     │   │
│  └─────────────┘             └──────────────┘   │
│         ↑                           │            │
│         │                    git commit          │
│     git restore                     ↓            │
│         │                    ┌──────────────┐   │
│         └─────────────────── │  Repository  │   │
│                              │   (.git)     │   │
│                              └──────────────┘   │
│                                     ↑            │
└─────────────────────────────────────│────────────┘
                                      │
                              git push/pull
                                      │
                                      ↓
                            ┌──────────────────┐
                            │     GITHUB       │
                            │  Remote Server   │
                            └──────────────────┘
```

## Essential Commands Cheat Sheet

| Command | What it does | When to use |
|---------|--------------|-------------|
| `git init` | Start tracking a project | Once, when starting |
| `git status` | See what's changed | Frequently! |
| `git add .` | Stage all changes | Before committing |
| `git commit -m "message"` | Save a snapshot | After making changes |
| `git log` | See history | To review commits |
| `git diff` | See exact changes | Before staging |
| `git branch` | List branches | To see branches |
| `git checkout -b name` | Create & switch branch | To start new feature |
| `git merge branch` | Combine branches | To integrate changes |
| `git clone url` | Copy remote repo | To get existing project |
| `git push` | Upload to remote | To share changes |
| `git pull` | Download from remote | To get updates |

## Common Mistakes & Solutions

### Mistake 1: "I committed to the wrong branch!"
```bash
# If you haven't pushed yet:
git reset HEAD~1  # Undo last commit
git stash         # Save changes temporarily
git checkout correct-branch
git stash pop     # Restore changes
git add .
git commit -m "message"
```

### Mistake 2: "My commit message has a typo!"
```bash
# If it's the last commit and not pushed:
git commit --amend -m "Corrected message"
```

### Mistake 3: "I forgot to add a file to my commit!"
```bash
# Add the forgotten file
git add forgotten-file.txt
# Amend the last commit to include it
git commit --amend --no-edit
```

### Mistake 4: "Git says I have conflicts!"
Don't panic! This happens when two people change the same part of a file:

1. Open the conflicted file
2. Look for markers like:
```
<<<<<<< HEAD
Your version
=======
Their version
>>>>>>> branch-name
```
3. Decide what to keep, remove the markers
4. Save, add, and commit:
```bash
git add conflicted-file.txt
git commit -m "Resolve conflict"
```

## Best Practices for Beginners

### ✅ DO:
- **Commit often** - Small, frequent commits are better than huge ones
- **Write clear messages** - "Fix login bug" not "Fixed stuff"
- **Pull before push** - Always get latest changes before sharing yours
- **Use branches** - Keep experiments separate from stable code
- **Check status frequently** - `git status` is your friend

### ❌ DON'T:
- **Don't commit passwords** - Keep sensitive data out of Git
- **Don't force push** - Unless you really know what you're doing
- **Don't panic** - Almost everything in Git can be undone
- **Don't commit generated files** - Use .gitignore for build outputs
- **Don't work directly on main** - Use branches for new features

## .gitignore File

Create a `.gitignore` file to tell Git what to ignore:

```bash
# .gitignore example
# Ignore all .log files
*.log

# Ignore the build directory
/build

# Ignore OS files
.DS_Store
Thumbs.db

# Ignore IDE files
.vscode/
.idea/

# Ignore dependencies
node_modules/
vendor/
```

## Getting Help

### Built-in Help
```bash
git help <command>
git <command> --help
# Example: git help commit
```

### Quick Help
```bash
git <command> -h
# Example: git commit -h
```

### Online Resources
- Ask on [Stack Overflow](https://stackoverflow.com/questions/tagged/git)
- Check [Oh Shit, Git!?!](https://ohshitgit.com/) for fixes
- Read the [Pro Git Book](https://git-scm.com/book) (free!)

## Practice Exercises

### Exercise 1: Your First Repo
1. Create a folder called `learning-git`
2. Initialize Git
3. Create a file called `notes.txt`
4. Add your name to the file
5. Commit with message "Add my name"
6. Add your favorite color
7. Commit with message "Add favorite color"
8. View the log to see both commits

### Exercise 2: Branching
1. Create a branch called `feature`
2. Switch to it
3. Create a file called `feature.txt`
4. Commit it
5. Switch back to main
6. Merge the feature branch
7. Delete the feature branch

### Exercise 3: Time Travel
1. Make 3 different commits
2. Use `git log` to see history
3. Go back to the second commit
4. Create a branch from there
5. Make a different change
6. See how history diverged

## Next Steps

You now know enough Git to:
- ✅ Track your projects
- ✅ Experiment safely with branches
- ✅ Collaborate on GitHub
- ✅ Fix common mistakes

### Level Up Your Skills:
1. **Practice Daily** - Use Git for all your projects
2. **Learn More Commands** - Check out our [Intermediate Guide](intermediate-guide.md)
3. **Contribute to Open Source** - Find beginner-friendly projects on GitHub
4. **Use a GUI Tool** - Try GitKraken or GitHub Desktop for visual learning
5. **Read Pro Git Chapters 1-3** - Solidify your understanding

### What You'll Learn Next:
- Interactive rebasing
- Cherry-picking commits
- Stashing changes
- Advanced merging strategies
- Git hooks and automation
- Submodules and subtrees

## Quick Reference Card

Print this and keep it handy:

```
SETUP
  git config --global user.name "Name"
  git config --global user.email "email"

START
  git init                  Start tracking
  git clone <url>          Copy existing repo

STAGE & COMMIT
  git status               What's changed?
  git add <file>          Stage specific file
  git add .               Stage everything
  git commit -m "msg"     Save snapshot

BRANCH & MERGE
  git branch              List branches
  git branch <name>       Create branch
  git checkout <name>     Switch branch
  git merge <branch>      Combine branches

REMOTE
  git remote -v           Show remotes
  git push                Upload changes
  git pull                Download changes

UNDO
  git restore <file>      Discard changes
  git reset HEAD~1        Undo last commit
```

---

🎉 **Congratulations!** You're no longer a Git beginner! Keep practicing, and remember: everyone makes mistakes with Git - that's how we learn!

Need more help? Check our [FAQ](../faq.md) or dive into the [exercises](../exercises/)!