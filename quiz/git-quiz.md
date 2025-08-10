# Git Knowledge Quiz 🎯

Test your Git knowledge with these interactive questions! Each question includes the answer and explanation.

## Beginner Level 🌱

<details>
<summary><strong>1. What command initializes a new Git repository?</strong></summary>

**Answer:** `git init`

**Explanation:** This command creates a new `.git` directory in your current folder, turning it into a Git repository.
</details>

<details>
<summary><strong>2. How do you stage all changes for commit?</strong></summary>

**Answer:** `git add .` or `git add -A`

**Explanation:** 
- `git add .` stages all changes in the current directory and subdirectories
- `git add -A` stages all changes in the entire repository
</details>

<details>
<summary><strong>3. What's the difference between `git fetch` and `git pull`?</strong></summary>

**Answer:** 
- `git fetch` downloads changes from remote but doesn't merge them
- `git pull` downloads changes AND merges them (fetch + merge)

**Explanation:** Use `fetch` when you want to review changes before integrating them. Use `pull` for a quick update.
</details>

<details>
<summary><strong>4. How do you create and switch to a new branch in one command?</strong></summary>

**Answer:** `git checkout -b branch-name` or `git switch -c branch-name`

**Explanation:** The modern `git switch -c` is preferred in Git 2.23+, as it's more intuitive than `checkout`.
</details>

<details>
<summary><strong>5. What does `git status` show you?</strong></summary>

**Answer:** The current state of your working directory and staging area

**Explanation:** It shows:
- Current branch
- Changes staged for commit
- Changes not staged
- Untracked files
- Branch synchronization status with remote
</details>

## Intermediate Level 🚀

<details>
<summary><strong>6. How do you undo the last commit but keep the changes?</strong></summary>

**Answer:** `git reset --soft HEAD~1`

**Explanation:** 
- `--soft` keeps changes in staging area
- `--mixed` (default) keeps changes but unstages them
- `--hard` discards all changes (dangerous!)
</details>

<details>
<summary><strong>7. What's the purpose of `git stash`?</strong></summary>

**Answer:** Temporarily save uncommitted changes without committing them

**Explanation:** Useful when you need to switch branches but aren't ready to commit. Use `git stash pop` to reapply changes.
</details>

<details>
<summary><strong>8. How do you view the commit history with a graph?</strong></summary>

**Answer:** `git log --graph --oneline --all`

**Explanation:** 
- `--graph` shows branch structure
- `--oneline` shows compact format
- `--all` shows all branches
</details>

<details>
<summary><strong>9. What's a "fast-forward" merge?</strong></summary>

**Answer:** A merge where Git simply moves the branch pointer forward because there's a direct linear path

**Explanation:** Occurs when the target branch hasn't diverged from the source branch. No merge commit is created.
</details>

<details>
<summary><strong>10. How do you change the message of the last commit?</strong></summary>

**Answer:** `git commit --amend -m "New message"`

**Explanation:** Only do this if you haven't pushed the commit yet! Amending rewrites history.
</details>

## Advanced Level 🎓

<details>
<summary><strong>11. What's the difference between `git rebase` and `git merge`?</strong></summary>

**Answer:** 
- `merge` creates a merge commit, preserving branch history
- `rebase` replays commits on top of another branch, creating linear history

**Explanation:** Rebase rewrites history (dangerous for shared branches), while merge preserves it.
</details>

<details>
<summary><strong>12. How do you find which commit introduced a bug using Git?</strong></summary>

**Answer:** `git bisect`

**Explanation:** Binary search through commit history:
1. `git bisect start`
2. `git bisect bad` (mark current as bad)
3. `git bisect good <commit>` (mark known good commit)
4. Git checks out commits for you to test
5. Mark each as good/bad until bug commit is found
</details>

<details>
<summary><strong>13. What's a "detached HEAD" state?</strong></summary>

**Answer:** When HEAD points directly to a commit instead of a branch

**Explanation:** Occurs when you checkout a specific commit. Any new commits will be lost when you switch branches unless you create a new branch.
</details>

<details>
<summary><strong>14. How do you sign commits with GPG?</strong></summary>

**Answer:** 
```bash
git config --global user.signingkey <key-id>
git commit -S -m "Signed commit"
```

**Explanation:** Signed commits prove authorship and haven't been tampered with. GitHub shows a "Verified" badge.
</details>

<details>
<summary><strong>15. What's the purpose of `git reflog`?</strong></summary>

**Answer:** Shows a log of all HEAD pointer updates, even for "lost" commits

**Explanation:** Lifesaver for recovering lost commits, especially after bad rebases or resets. Works even when commits aren't in any branch.
</details>

## Expert Level 🏆

<details>
<summary><strong>16. How do you use `git cherry-pick`?</strong></summary>

**Answer:** `git cherry-pick <commit-hash>`

**Explanation:** Applies changes from a specific commit to your current branch. Useful for selective porting of fixes between branches.
</details>

<details>
<summary><strong>17. What's the three-way merge algorithm?</strong></summary>

**Answer:** Git finds a common ancestor and compares both branches against it to determine changes

**Explanation:** This allows Git to automatically resolve many conflicts by understanding what each branch changed from the common base.
</details>

<details>
<summary><strong>18. How do you work with submodules?</strong></summary>

**Answer:** 
```bash
git submodule add <url>  # Add
git submodule update --init --recursive  # Initialize
git submodule update --remote  # Update to latest
```

**Explanation:** Submodules allow you to include other Git repositories within your repository while keeping histories separate.
</details>

<details>
<summary><strong>19. What's a Git hook and name three types?</strong></summary>

**Answer:** Scripts that run automatically at certain Git events

Common hooks:
- `pre-commit` - runs before commit
- `post-merge` - runs after merge
- `pre-push` - runs before push

**Explanation:** Located in `.git/hooks/`, useful for enforcing standards, running tests, or triggering deployments.
</details>

<details>
<summary><strong>20. How do you handle large files in Git?</strong></summary>

**Answer:** Use Git LFS (Large File Storage)

```bash
git lfs track "*.psd"
git add .gitattributes
git add large-file.psd
git commit -m "Add large file"
```

**Explanation:** LFS stores file pointers in Git while actual files are stored separately, keeping repository size manageable.
</details>

## Scenario-Based Questions 🎭

<details>
<summary><strong>21. You accidentally committed sensitive data. How do you remove it from history?</strong></summary>

**Answer:** Use `git filter-branch` or BFG Repo-Cleaner

```bash
# Using BFG (recommended)
bfg --delete-files passwords.txt
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push to update remote
git push --force
```

**Explanation:** This rewrites entire history. All collaborators must re-clone. Consider rotating the exposed credentials immediately.
</details>

<details>
<summary><strong>22. How do you resolve a merge conflict?</strong></summary>

**Answer:** 
1. Open conflicted files (marked with `<<<<<<<`, `=======`, `>>>>>>>`)
2. Edit to resolve conflicts
3. Remove conflict markers
4. `git add` resolved files
5. `git commit` to complete merge

**Explanation:** You can also use `git mergetool` to launch a visual merge tool.
</details>

<details>
<summary><strong>23. Your colleague force-pushed and you lost commits. How do you recover?</strong></summary>

**Answer:** 
```bash
git reflog  # Find your lost commit
git checkout <lost-commit-hash>
git branch recovered-branch
```

**Explanation:** Reflog saves the day! It keeps a local log of all HEAD movements for 90 days by default.
</details>

---

## Your Score 📊

- **20-23 correct:** Git Master! 🏆 You have expert-level knowledge
- **15-19 correct:** Git Pro! 🌟 Strong understanding with room to grow
- **10-14 correct:** Git Competent! 💪 Solid foundation, keep learning
- **5-9 correct:** Git Learner! 📚 You know the basics, practice more
- **0-4 correct:** Git Beginner! 🌱 Keep studying, you'll get there!

## Want More Practice?

Check out the [hands-on exercises](../exercises/) to apply these concepts!