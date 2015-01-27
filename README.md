# GIT - Tips And Tricks

###The progression of Source Control systems
1. Local SC (RCS) [image] (http://git-scm.com/book/en/v2/book/01-introduction/images/local.png)
Slightly better than just dropping files in a folder and timestamping them.

2. Centralized SC (TFS) [image] (http://git-scm.com/book/en/v2/book/01-introduction/images/centralized.png)
Single point of integration, single point of failure

3. Distributed SC (GIT) [image] (http://git-scm.com/book/en/v2/book/01-introduction/images/distributed.png)
Fully fault tolerent, everyone has everything.

[image source] (http://git-scm.com/book/en/v2/Getting-Started-About-Version-Control)

###GIT History
GIT grew out of the community involved with Linux Kernel Development.  Prior to GIT, the community had been using a commercial product, Bitkeeper, for its Source Control solution.  In 2005 the relationship with the company that owned Bitkeeper soured, and GIT was written as its replacement.

###GIT's goals

* Speed
* Simple design
* Strong support for non-linear development (thousands of parallel branches)
* Fully distributed
* Able to handle large projects like the Linux kernel efficiently (speed and data size)

source: http://git-scm.com/book/en/v2 , pg 31.

###GIT internals
TBD...

###Commands

####`GIT INIT`
Initializes a local folder to be a GIT working folder.  Can be connected to a remote or kept just as a local code repo.

####`GIT CLONE`
Starting from scratch with an established remote repository?  GIT CLONE is your friend.

Get the url for the remote repo you would like to have locally and run `GIT CLONE <remote repo uri>`

####`GIT BRANCH`
Lorem Ipsum sit dolor amet avec qua.

####`GIT CHECKOUT`
Works for branches, individual files, commits, Pull Requests.

### GIT - Working with remotes
####`GIT FETCH`
Retrieve changes made to remote but do not merge.

####`GIT PUSH`
Commit to remote

####`GIT PULL`
GIT FETCH
GIT MERGE
   All rolled into a single step.

### GIT - History
####GIT LOG
git log --graph --pretty=oneline

####`GIT ADD`
Stages files to be committed

####`GIT COMMIT`
Commits files you have staged with `GIT ADD`

####`GIT RESET`
Change which commit HEAD points to.  Updates references in your working directory.  Does not change commits, does not rewrite history

####`GIT REBASE`
**Careful**, this rewrites history.  This is a very bad idea for any changesets that have been pushed to a shared remote repo

####"sync"
GIT doesn't have the concept of "sync" natively, per-se.  It separates sync into `PULL` `PUSH` and alternatively `PULL` into the two part process `GIT FETCH` then `GIT MERGE`

Visual Studio's GIT plug-in uses the concept of 'sync' to do `PULL` or a `PUSH` behind the scenes

##Pull Requests
Pull Requests seem to work best for requesting a merge between two branches (can be across forks) on GitHub.

Pull requests roll up all the commits between two lines of work and roll them together with the base (destination) of the merge in a single merge step.

##Editing & Merging

####`GIT DIFF`
Shows differences on the command line.  Okay with single files with few changes, but becomes unmanageable quickly with lots of changes

####`GIT DIFFTOOL`
Invoke your favorite diff tool to do the same thing as `GIT DIFF` but with a rich UX experience of your choice.  I use *DiffMerge* or *Beyond Compare 3*

###Extras

####Squishing
**Careful** squishing (rebasing) rewrite commit history)
`GIT REBASE 241D2E9 -i`

`pick dd5ccee Update README.md`
`pick 769077e Update README.md`
`pick fd1e701 Update README.md`
`pick 750648c Updated header to add spaces`
`pick ab69170 Update README.md`


##Visual Tools

####Visual Studio
What is actually going on behind the scenes?  Good way to compare files changed locally to the previous commit.

####SourceTree (Atlassian)
Crashes a lot for me.  Nice visuals when it works.

####Git for Windows
Official tool provided by the folks at GitHub.  [Read more about it from Phil Haack](http://haacked.com/archive/2012/05/21/introducing-github-for-windows.aspx/)

