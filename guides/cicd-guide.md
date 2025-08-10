# Git CI/CD Integration Guide 🚀

Automate your Git workflows with Continuous Integration and Continuous Deployment.

## Table of Contents
1. [CI/CD Fundamentals](#cicd-fundamentals)
2. [GitHub Actions](#github-actions)
3. [GitLab CI/CD](#gitlab-cicd)
4. [Jenkins Integration](#jenkins-integration)
5. [Advanced Automation](#advanced-automation)
6. [Deployment Strategies](#deployment-strategies)
7. [Security & Best Practices](#security--best-practices)

---

## CI/CD Fundamentals

### Git Events That Trigger CI/CD

```yaml
# Common triggers
- push to branch
- pull request opened/updated
- tag created
- release published
- schedule (cron)
- manual trigger
- webhook
```

### Git Information in CI/CD

```bash
# Environment variables available in most CI systems
$GIT_COMMIT      # Current commit SHA
$GIT_BRANCH      # Current branch name
$GIT_TAG         # Current tag (if any)
$GIT_AUTHOR      # Commit author
$GIT_MESSAGE     # Commit message
$GIT_PREVIOUS    # Previous commit SHA
```

## GitHub Actions

### Basic Workflow

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  
jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0  # Fetch all history for all tags and branches
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Run linter
        run: npm run lint
```

### Advanced GitHub Actions

#### Matrix Testing

```yaml
name: Matrix CI

on: [push, pull_request]

jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node: [16, 18, 20]
        exclude:
          - os: windows-latest
            node: 16
    
    runs-on: ${{ matrix.os }}
    
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node }}
      - run: npm test
```

#### Conditional Workflows

```yaml
name: Conditional Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    if: contains(github.event.head_commit.message, '[deploy]')
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Deploy to production
        if: github.ref == 'refs/heads/main'
        run: ./deploy-prod.sh
      
      - name: Deploy to staging
        if: github.ref == 'refs/heads/develop'
        run: ./deploy-staging.sh
```

#### Semantic Versioning

```yaml
name: Release

on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Semantic Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: |
          npm install -g semantic-release
          semantic-release
```

#### Auto-merge Dependabot

```yaml
name: Auto-merge Dependabot

on: pull_request

permissions:
  contents: write
  pull-requests: write

jobs:
  dependabot:
    runs-on: ubuntu-latest
    if: ${{ github.actor == 'dependabot[bot]' }}
    
    steps:
      - name: Enable auto-merge
        run: gh pr merge --auto --merge "$PR_URL"
        env:
          PR_URL: ${{ github.event.pull_request.html_url }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### GitHub Actions for Git Operations

```yaml
name: Git Automation

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday

jobs:
  cleanup:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Delete merged branches
        run: |
          git fetch --prune
          git branch -r --merged | 
            grep -v main | 
            sed 's/origin\///' | 
            xargs -n 1 git push --delete origin
      
      - name: Create changelog
        run: |
          git log --pretty=format:"- %s (%h)" --since="1 week ago" > CHANGELOG_WEEKLY.md
          git add CHANGELOG_WEEKLY.md
          git commit -m "chore: update weekly changelog"
          git push
```

## GitLab CI/CD

### Basic Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

variables:
  NODE_VERSION: "18"

before_script:
  - apt-get update -qq && apt-get install -y nodejs npm
  - npm ci --cache .npm --prefer-offline

build:
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week

test:
  stage: test
  script:
    - npm test
  coverage: '/Coverage: \d+\.\d+%/'

deploy:
  stage: deploy
  script:
    - npm run deploy
  only:
    - main
  environment:
    name: production
    url: https://example.com
```

### GitLab Advanced Features

#### Merge Request Pipelines

```yaml
# Only run on merge requests
test:mr:
  stage: test
  script:
    - npm test
  only:
    - merge_requests

# Different pipeline for main branch
deploy:production:
  stage: deploy
  script:
    - ./deploy-prod.sh
  only:
    - main
  when: manual
```

#### Dynamic Environments

```yaml
deploy:review:
  stage: deploy
  script:
    - echo "Deploy to review app"
    - ./deploy-review.sh $CI_COMMIT_REF_NAME
  environment:
    name: review/$CI_COMMIT_REF_NAME
    url: https://$CI_COMMIT_REF_NAME.example.com
    on_stop: stop:review
  only:
    - branches
  except:
    - main

stop:review:
  stage: deploy
  script:
    - ./stop-review.sh $CI_COMMIT_REF_NAME
  environment:
    name: review/$CI_COMMIT_REF_NAME
    action: stop
  when: manual
```

#### GitLab Git Automation

```yaml
# Auto-tag releases
tag:release:
  stage: deploy
  script:
    - |
      VERSION=$(cat package.json | grep version | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g' | tr -d '[[:space:]]')
      git config user.email "ci@example.com"
      git config user.name "GitLab CI"
      git tag -a v$VERSION -m "Release version $VERSION"
      git push origin v$VERSION
  only:
    - main
  except:
    - tags
```

## Jenkins Integration

### Jenkinsfile (Declarative)

```groovy
pipeline {
    agent any
    
    environment {
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        GIT_BRANCH_NAME = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git submodule update --init --recursive'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm ci'
                sh 'npm run build'
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh './deploy.sh'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            slackSend(
                color: 'good',
                message: "Build Successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
            )
        }
        failure {
            slackSend(
                color: 'danger',
                message: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
            )
        }
    }
}
```

### Jenkins Multibranch Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    stages {
        stage('Branch Specific') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh 'npm run deploy:prod'
                    } else if (env.BRANCH_NAME == 'develop') {
                        sh 'npm run deploy:staging'
                    } else if (env.BRANCH_NAME.startsWith('feature/')) {
                        sh 'npm run deploy:preview'
                    }
                }
            }
        }
    }
}
```

## Advanced Automation

### Git Hooks in CI/CD

```yaml
# Pre-commit checks in CI
name: Pre-commit Checks

on: [push, pull_request]

jobs:
  pre-commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
      - uses: pre-commit/action@v3.0.0
```

### Automated Changelog Generation

```yaml
# .github/workflows/changelog.yml
name: Changelog

on:
  push:
    tags:
      - 'v*'

jobs:
  changelog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      
      - name: Generate changelog
        run: |
          npm install -g conventional-changelog-cli
          conventional-changelog -p angular -i CHANGELOG.md -s
      
      - name: Commit changelog
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add CHANGELOG.md
          git commit -m "docs: update changelog for ${{ github.ref_name }}"
          git push
```

### Automated Dependency Updates

```yaml
# Renovate bot configuration
# renovate.json
{
  "extends": ["config:base"],
  "packageRules": [
    {
      "updateTypes": ["minor", "patch"],
      "automerge": true
    },
    {
      "depTypeList": ["devDependencies"],
      "automerge": true
    }
  ],
  "schedule": ["before 3am on Monday"],
  "timezone": "America/New_York",
  "labels": ["dependencies"],
  "assignees": ["teamlead"],
  "reviewers": ["team:frontend"]
}
```

### Automated Release Notes

```javascript
// .releaserc.js (semantic-release config)
module.exports = {
  branches: ['main'],
  plugins: [
    '@semantic-release/commit-analyzer',
    '@semantic-release/release-notes-generator',
    '@semantic-release/changelog',
    '@semantic-release/npm',
    ['@semantic-release/git', {
      assets: ['CHANGELOG.md', 'package.json'],
      message: 'chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}'
    }],
    '@semantic-release/github'
  ]
};
```

## Deployment Strategies

### Blue-Green Deployment

```yaml
# GitHub Actions blue-green deployment
deploy:
  runs-on: ubuntu-latest
  steps:
    - name: Deploy to Green
      run: |
        ./deploy.sh green
        ./health-check.sh green
    
    - name: Switch Traffic
      run: |
        ./switch-traffic.sh green
    
    - name: Cleanup Blue
      run: |
        sleep 300  # Wait 5 minutes
        ./cleanup.sh blue
```

### Canary Deployment

```yaml
# Progressive rollout
deploy:
  runs-on: ubuntu-latest
  steps:
    - name: Deploy Canary (10%)
      run: |
        ./deploy-canary.sh 10
        sleep 600  # Monitor for 10 minutes
    
    - name: Increase Traffic (50%)
      run: |
        ./deploy-canary.sh 50
        sleep 600
    
    - name: Full Rollout (100%)
      run: |
        ./deploy-canary.sh 100
```

### GitOps with ArgoCD

```yaml
# Update manifests for ArgoCD
name: GitOps Update

on:
  push:
    tags: ['v*']

jobs:
  update-manifests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          repository: org/k8s-manifests
          token: ${{ secrets.MANIFEST_TOKEN }}
      
      - name: Update image tag
        run: |
          sed -i "s|image: .*|image: myapp:${{ github.ref_name }}|" k8s/deployment.yaml
      
      - name: Commit and push
        run: |
          git config user.name "GitHub Actions"
          git config user.email "actions@github.com"
          git add .
          git commit -m "Update image to ${{ github.ref_name }}"
          git push
```

## Security & Best Practices

### Secret Management

```yaml
# GitHub Actions secrets
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  API_KEY: ${{ secrets.API_KEY }}

# GitLab CI variables
variables:
  DATABASE_URL: $CI_DATABASE_URL  # Set in GitLab UI

# Jenkins credentials
withCredentials([
    string(credentialsId: 'api-key', variable: 'API_KEY')
]) {
    sh 'deploy.sh'
}
```

### Security Scanning

```yaml
# Security scanning workflow
name: Security

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
      
      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      
      - name: GitLeaks
        uses: zricethezav/gitleaks-action@master
```

### Branch Protection via CI

```yaml
# Enforce branch protection
name: Branch Protection

on:
  pull_request:
    branches: [main]

jobs:
  protect:
    runs-on: ubuntu-latest
    steps:
      - name: Check PR size
        run: |
          if [ $(git diff --stat origin/main..HEAD | wc -l) -gt 500 ]; then
            echo "PR too large. Please split into smaller PRs."
            exit 1
          fi
      
      - name: Check commit messages
        run: |
          git log --format=%s origin/main..HEAD | while read commit; do
            if ! echo "$commit" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'; then
              echo "Invalid commit message: $commit"
              exit 1
            fi
          done
```

## CI/CD Best Practices

### 1. Pipeline as Code
```yaml
# Store all CI/CD config in repository
.github/workflows/
.gitlab-ci.yml
Jenkinsfile
azure-pipelines.yml
```

### 2. Fast Feedback
```yaml
# Run quick checks first
stages:
  - lint      # Fast
  - build     # Medium
  - test      # Slow
  - deploy    # Manual
```

### 3. Caching
```yaml
# Cache dependencies
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

### 4. Parallel Execution
```yaml
# Run tests in parallel
test:
  parallel:
    matrix:
      - TEST_SUITE: [unit, integration, e2e]
```

### 5. Fail Fast
```yaml
# Stop on first failure
strategy:
  fail-fast: true
  matrix:
    test: [test1, test2, test3]
```

## Monitoring & Observability

### CI/CD Metrics

```yaml
# Track deployment frequency
- name: Record deployment
  run: |
    curl -X POST https://metrics.example.com/deployments \
      -d '{
        "timestamp": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
        "commit": "'$GITHUB_SHA'",
        "branch": "'$GITHUB_REF'",
        "status": "success"
      }'
```

### Status Badges

```markdown
<!-- README.md -->
![Build Status](https://github.com/org/repo/workflows/CI/badge.svg)
![Coverage](https://codecov.io/gh/org/repo/branch/main/graph/badge.svg)
![License](https://img.shields.io/github/license/org/repo)
```

## Troubleshooting CI/CD

### Debug Mode

```yaml
# GitHub Actions debug
- name: Debug
  run: |
    echo "Event: ${{ github.event_name }}"
    echo "Ref: ${{ github.ref }}"
    echo "SHA: ${{ github.sha }}"
    echo "Actor: ${{ github.actor }}"
    cat $GITHUB_EVENT_PATH

# Enable debug logging
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

### Common Issues

```yaml
# Issue: Shallow clone missing history
- uses: actions/checkout@v3
  with:
    fetch-depth: 0  # Fetch all history

# Issue: No Git user configured
- run: |
    git config --global user.email "ci@example.com"
    git config --global user.name "CI Bot"

# Issue: Permission denied pushing
- uses: actions/checkout@v3
  with:
    token: ${{ secrets.PAT }}  # Use Personal Access Token
```

---

🚀 **You're now equipped to automate your Git workflows!** CI/CD integration with Git enables faster, more reliable software delivery.

Check out our [Team Guide](team-guide.md) for collaboration best practices or explore [Resources](../resources/) for more tools!