# Git Hands-On Exercises 🏋️‍♀️

Practice makes perfect! These exercises will help you master Git through real-world scenarios.

## Setup

Before starting, run the playground setup script:
```bash
../scripts/setup-playground.sh
```

This creates a safe environment for practicing Git commands without affecting real projects.

---

## 🌱 Beginner Exercises

### Exercise 1: First Repository
**Goal:** Create your first Git repository and make commits

1. Create a new directory called `my-first-repo`
2. Initialize it as a Git repository
3. Create a file called `README.md` with your name
4. Stage and commit the file with message "Initial commit"
5. Create a `.gitignore` file that ignores `*.log` files
6. Make another commit

<details>
<summary>Solution</summary>

```bash
mkdir my-first-repo
cd my-first-repo
git init
echo "# My Repository by [Your Name]" > README.md
git add README.md
git commit -m "Initial commit"
echo "*.log" > .gitignore
git add .gitignore
git commit -m "Add gitignore"
```
</details>

### Exercise 2: Branching Basics
**Goal:** Learn to create and manage branches

1. Create a new branch called `feature-1`
2. Switch to that branch
3. Create a file called `feature.txt`
4. Commit the file
5. Switch back to main/master
6. Merge the feature branch

<details>
<summary>Solution</summary>

```bash
git branch feature-1
git checkout feature-1
# Or in one command: git checkout -b feature-1
echo "My new feature" > feature.txt
git add feature.txt
git commit -m "Add feature"
git checkout main  # or master
git merge feature-1
```
</details>

### Exercise 3: Remote Repository
**Goal:** Work with remote repositories

1. Create a repository on GitHub (via web interface)
2. Add it as a remote to your local repository
3. Push your local commits
4. Make a change on GitHub (via web)
5. Pull the changes locally

<details>
<summary>Solution</summary>

```bash
git remote add origin https://github.com/yourusername/repo-name.git
git push -u origin main
# After making changes on GitHub:
git pull origin main
```
</details>

---

## 🚀 Intermediate Exercises

### Exercise 4: Handling Merge Conflicts
**Goal:** Learn to resolve merge conflicts

Setup:
```bash
git checkout -b conflict-branch-1
echo "Line 1: Version A" > conflict.txt
git add conflict.txt && git commit -m "Add version A"
git checkout main
git checkout -b conflict-branch-2
echo "Line 1: Version B" > conflict.txt
git add conflict.txt && git commit -m "Add version B"
git checkout main
git merge conflict-branch-1
git merge conflict-branch-2  # This will conflict!
```

Now resolve the conflict and complete the merge.

<details>
<summary>Solution</summary>

```bash
# Open conflict.txt in your editor
# You'll see:
# <<<<<<< HEAD
# Line 1: Version A
# =======
# Line 1: Version B
# >>>>>>> conflict-branch-2

# Edit to keep what you want, e.g.:
echo "Line 1: Version A and B merged" > conflict.txt

# Then:
git add conflict.txt
git commit -m "Resolve merge conflict"
```
</details>

### Exercise 5: Interactive Rebase
**Goal:** Clean up commit history

Setup:
```bash
echo "Feature start" > feature.txt && git add . && git commit -m "WIP: Start feature"
echo "Feature middle" >> feature.txt && git add . && git commit -m "WIP: Continue feature"
echo "Feature done" >> feature.txt && git add . && git commit -m "WIP: Finish feature"
```

Now squash these three commits into one clean commit.

<details>
<summary>Solution</summary>

```bash
git rebase -i HEAD~3
# In the editor, change:
# pick abc1234 WIP: Start feature
# squash def5678 WIP: Continue feature
# squash ghi9012 WIP: Finish feature

# Save and exit, then write a new commit message:
# "Implement complete feature"
```
</details>

### Exercise 6: Stashing Work
**Goal:** Use stash to save work temporarily

1. Make some changes to files but don't commit
2. Stash the changes with a message
3. Switch branches and do other work
4. Come back and apply your stashed changes
5. List all stashes and clean up

<details>
<summary>Solution</summary>

```bash
echo "Uncommitted work" >> README.md
git stash save "WIP: Updating README"
git checkout other-branch
# Do some work...
git checkout main
git stash list
git stash apply stash@{0}
# Or just: git stash pop
git stash drop stash@{0}
```
</details>

---

## 🎓 Advanced Exercises

### Exercise 7: Bisecting to Find Bugs
**Goal:** Use git bisect to find when a bug was introduced

Setup script creates 20 commits, one of which introduces a "bug":
```bash
../scripts/create-bisect-exercise.sh
```

The bug: File `app.js` should contain "STATUS: OK" but at some point it changed to "STATUS: ERROR"

<details>
<summary>Solution</summary>

```bash
git bisect start
git bisect bad  # Current version is bad
git bisect good HEAD~20  # 20 commits ago was good

# Git will checkout commits for you to test
# For each commit, check app.js and mark:
cat app.js
# If it shows "STATUS: ERROR":
git bisect bad
# If it shows "STATUS: OK":
git bisect good

# Git will eventually identify the bad commit
git bisect reset  # Return to original HEAD
```
</details>

### Exercise 8: Cherry-Picking Commits
**Goal:** Selectively apply commits from one branch to another

Setup:
```bash
git checkout -b feature-branch
echo "Fix 1" > fix1.txt && git add . && git commit -m "Critical fix 1"
echo "Feature A" > feature-a.txt && git add . && git commit -m "Add feature A"
echo "Fix 2" > fix2.txt && git add . && git commit -m "Critical fix 2"
echo "Feature B" > feature-b.txt && git add . && git commit -m "Add feature B"
```

Task: Apply only the two "Critical fix" commits to main branch without the features.

<details>
<summary>Solution</summary>

```bash
git checkout main
git log feature-branch --oneline
# Note the commit hashes for "Critical fix 1" and "Critical fix 2"
git cherry-pick <hash-of-fix-1>
git cherry-pick <hash-of-fix-2>
```
</details>

### Exercise 9: Reflog Recovery
**Goal:** Recover "lost" commits using reflog

1. Create a branch with commits
2. Delete the branch with `git branch -D`
3. Recover the lost commits

<details>
<summary>Solution</summary>

```bash
git checkout -b important-work
echo "Important data" > important.txt
git add . && git commit -m "Add important data"
git checkout main
git branch -D important-work  # Oh no!

# Recovery:
git reflog
# Find the commit hash for "Add important data"
git checkout <commit-hash>
git checkout -b recovered-branch
```
</details>

---

## 🏆 Team Collaboration Exercises

### Exercise 10: Pull Request Workflow
**Goal:** Practice the PR workflow

1. Fork a repository
2. Clone your fork locally
3. Create a feature branch
4. Make changes and push
5. Create a pull request
6. Address review comments
7. Squash and merge

### Exercise 11: Handling Force Pushes
**Goal:** Recover from a colleague's force push

Setup: Work with a partner or simulate with two local clones
1. Both make commits
2. One person force pushes, overwriting the other's work
3. Recover the lost commits

### Exercise 12: Git Hooks
**Goal:** Implement Git hooks for code quality

Create these hooks:
1. `pre-commit`: Check for console.log statements
2. `commit-msg`: Enforce conventional commit format
3. `pre-push`: Run tests before pushing

<details>
<summary>Solution</summary>

```bash
# .git/hooks/pre-commit
#!/bin/sh
if git diff --cached --name-only | xargs grep -n "console.log"; then
    echo "Remove console.log statements before committing!"
    exit 1
fi

# .git/hooks/commit-msg
#!/bin/sh
if ! grep -qE "^(feat|fix|docs|style|refactor|test|chore):" "$1"; then
    echo "Commit message must follow conventional format!"
    exit 1
fi

# .git/hooks/pre-push
#!/bin/sh
npm test || exit 1

# Make hooks executable
chmod +x .git/hooks/*
```
</details>

---

## 📊 Progress Tracking

Track your progress by checking off completed exercises:

- [ ] Exercise 1: First Repository
- [ ] Exercise 2: Branching Basics
- [ ] Exercise 3: Remote Repository
- [ ] Exercise 4: Handling Merge Conflicts
- [ ] Exercise 5: Interactive Rebase
- [ ] Exercise 6: Stashing Work
- [ ] Exercise 7: Bisecting to Find Bugs
- [ ] Exercise 8: Cherry-Picking Commits
- [ ] Exercise 9: Reflog Recovery
- [ ] Exercise 10: Pull Request Workflow
- [ ] Exercise 11: Handling Force Pushes
- [ ] Exercise 12: Git Hooks

## Next Steps

Once you've completed these exercises:
1. Try the [Git Quiz](../quiz/git-quiz.md) to test your knowledge
2. Read the [Advanced Guide](../guides/advanced-guide.md) for deeper insights
3. Set up your own Git aliases and configurations
4. Contribute to open source projects to practice collaboration!