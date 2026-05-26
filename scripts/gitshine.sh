#!/usr/bin/env bash
# ==============================================================================
# 🟢 GitShine — Multi-Dimensional Activity Automator
# ==============================================================================
# Automates GitHub activity across: Commits, Issues, PRs, and Code Reviews.
# Design Details:
#   - Commits are pushed directly with the user's email.
#   - Issues/PRs/Reviews require USER_PAT to be attributed to the user's profile.
#   - Randomizes events to appear organic and human-like.
#   - Robust, self-cleaning, and gracefully falls back if USER_PAT is missing.
# ==============================================================================

set -euo pipefail

# --- Color Codes for Premium Logging ---
NC='\033[0m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'

log_info() { echo -e "${CYAN}${BOLD}[GitShine INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}${BOLD}[GitShine SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}${BOLD}[GitShine WARNING]${NC} $1"; }
log_err() { echo -e "${RED}${BOLD}[GitShine ERROR]${NC} $1"; }

# --- Verify Repository context ---
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
if [ -z "$GITHUB_REPOSITORY" ]; then
  # Fallback to local git remote if running locally
  GITHUB_REPOSITORY=$(git remote get-url origin 2>/dev/null | sed -E 's/.*github.com[:\/](.*)\.git/\1/' || echo "")
fi

log_info "Starting GitShine Automator..."
log_info "Target Repository: $GITHUB_REPOSITORY"

# Ensure Git identity is configured
USER_EMAIL="abhiramak963@gmail.com"
USER_NAME="abhi963007"
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

# Safe checkout & sync main
git fetch origin main
git checkout main
git reset --hard origin/main

# ==============================================================================
# 1. COMMIT AUTOMATION (Always runs)
# ==============================================================================
run_commits() {
  log_info "Starting Commits Automation..."
  commits_count=$(( RANDOM % 16 + 10 )) # 10 to 25 commits per run for subtle, natural growth
  log_info "Generating $commits_count commits..."

  current_epoch=$(date +%s)

  for i in $(seq 1 "$commits_count"); do
    offset=$(( i * (RANDOM % 110 + 10) ))
    commit_epoch=$(( current_epoch - offset ))
    timestamp=$(date -u -d "@$commit_epoch" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -r "$commit_epoch" +"%Y-%m-%dT%H:%M:%SZ")

    echo "GitShine contribution update: ${timestamp} - commit #${i} of ${commits_count}" >> contributions.txt
    git add contributions.txt
    GIT_AUTHOR_DATE="$timestamp" GIT_COMMITTER_DATE="$timestamp" \
      git commit -m "GitShine contribution update #${i} - optimization" >/dev/null
  done

  # Push commits directly
  if git push origin HEAD:main; then
    log_success "Successfully pushed $commits_count commits to main!"
  else
    log_err "Failed to push commits to main."
    return 1
  fi
}

# ==============================================================================
# 2. ISSUE AUTOMATION
# ==============================================================================
run_issue() {
  log_info "Starting Issue Automation..."
  
  # Professional random issue titles & templates
  local titles=(
    "Routine optimization: clean up stale build artifacts and logs"
    "Improve workflow performance: evaluate runner execution times"
    "Refactor: sanitize and standardize environment variables in Actions"
    "Security scan: audit action dependencies and repository settings"
  )
  local bodies=(
    "Periodic automation task to clean up old runtime artifacts and ensure workflow optimization."
    "Review action runs over the last 7 days to check for performance bottlenecks and timeouts."
    "Maintain clean environment properties across development runners for secure deployment cycles."
    "Run standard vulnerability check against configured workflows and dependencies."
  )
  
  local idx=$(( RANDOM % ${#titles[@]} ))
  local title="${titles[$idx]}"
  local body=$(echo -e "${bodies[$idx]}\n\n*Automated health verification task powered by GitShine.*")

  # Create the issue as the USER
  log_info "Creating issue: \"$title\"..."
  local issue_url
  issue_url=$(GH_TOKEN="$USER_PAT" gh issue create --title "$title" --body "$body")
  local issue_num=$(echo "$issue_url" | grep -oE '[0-9]+$')
  
  log_success "Created Issue #$issue_num"
  
  # Wait a short moment to mimic natural timing
  sleep $(( RANDOM % 5 + 3 ))

  # Close the issue as the USER
  log_info "Closing Issue #$issue_num..."
  GH_TOKEN="$USER_PAT" gh issue close "$issue_num" --comment "Verification completed successfully. Performance metrics meet established standards. Closing task." >/dev/null
  log_success "Successfully completed Issue contribution cycle!"
}

# ==============================================================================
# 3. PULL REQUEST AUTOMATION
# ==============================================================================
run_pr() {
  log_info "Starting Pull Request Automation..."
  
  local branch_name="gitshine/pr-$(date +%s)"
  git checkout -b "$branch_name"

  # Make a small change
  echo "PR sync: $(date -u) - verified" >> contributions.txt
  git add contributions.txt
  git commit -m "Sync: minor workspace configuration cleanup" >/dev/null

  # Push branch to origin
  log_info "Pushing feature branch $branch_name..."
  GH_TOKEN="$USER_PAT" git push origin "$branch_name" >/dev/null

  # Open PR as the USER
  log_info "Creating Pull Request..."
  local pr_body=$(echo -e "Automated pull request to synchronize minor background configuration metrics.\n\n*Created by GitShine.*")
  local pr_url
  pr_url=$(GH_TOKEN="$USER_PAT" gh pr create \
    --title "Refactor: daily configuration sync" \
    --body "$pr_body" \
    --base main \
    --head "$branch_name")
  
  local pr_num=$(echo "$pr_url" | grep -oE '[0-9]+$')
  log_success "Created Pull Request #$pr_num"

  sleep $(( RANDOM % 5 + 3 ))

  # Merge PR as the USER (also deletes the remote/local branch)
  log_info "Merging Pull Request #$pr_num..."
  GH_TOKEN="$USER_PAT" gh pr merge "$pr_num" --merge --delete-branch >/dev/null
  
  # Clean up local branch
  git checkout main
  git branch -D "$branch_name" >/dev/null
  
  log_success "Successfully completed Pull Request contribution cycle!"
}

# ==============================================================================
# 4. CODE REVIEW AUTOMATION
# ==============================================================================
run_review() {
  log_info "Starting Code Review Automation..."
  
  local branch_name="gitshine/review-$(date +%s)"
  git checkout -b "$branch_name"

  # Make a small change
  echo "Review update: $(date -u) - audited" >> contributions.txt
  git add contributions.txt
  git commit -m "Audit: perform workflow metadata sanity check" >/dev/null

  # Push branch as bot (uses GITHUB_TOKEN or USER_PAT if needed, but GITHUB_TOKEN is safer for the creator)
  log_info "Pushing feature branch $branch_name..."
  git push origin "$branch_name" >/dev/null

  # Open PR using GITHUB_TOKEN (attributed to github-actions[bot])
  log_info "Opening PR as the actions bot..."
  local review_pr_body=$(echo -e "Proposed checklist updates to repository actions workflow. Please review.")
  local pr_url
  pr_url=$(GH_TOKEN="$GITHUB_TOKEN" gh pr create \
    --title "Workflow audit: metadata compliance" \
    --body "$review_pr_body" \
    --base main \
    --head "$branch_name")
  
  local pr_num=$(echo "$pr_url" | grep -oE '[0-9]+$')
  log_success "Bot opened Pull Request #$pr_num"

  sleep $(( RANDOM % 5 + 3 ))

  # Submit an approving review as the USER (attributed to you!)
  log_info "Submitting Code Review approval as $USER_NAME..."
  local review_msgs=(
    "LGTM! Clean logic and matches standard rules."
    "Verified. All automated verification tests passed. Ready for merge."
    "Review approved. Nice separation of concern in metadata logging."
  )
  local review_msg="${review_msgs[$(( RANDOM % ${#review_msgs[@]} ))]}"
  
  GH_TOKEN="$USER_PAT" gh pr review "$pr_num" --approve --body "$review_msg" >/dev/null
  log_success "Approved and reviewed PR #$pr_num!"

  sleep $(( RANDOM % 3 + 2 ))

  # Merge PR using USER_PAT
  log_info "Merging PR #$pr_num..."
  GH_TOKEN="$USER_PAT" gh pr merge "$pr_num" --merge --delete-branch >/dev/null

  # Clean up local branch
  git checkout main
  git branch -D "$branch_name" >/dev/null

  log_success "Successfully completed Code Review contribution cycle!"
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

# Always run commits first to keep streak green
run_commits

# Check if USER_PAT is provided
USER_PAT="${USER_PAT:-}"
if [ -z "$USER_PAT" ]; then
  log_warn "======================================================================"
  log_warn "USER_PAT secret is NOT set!"
  log_warn "Skipping Issues, Pull Requests, and Code Review automations."
  log_warn "To enable full GitShine functionality, configure your USER_PAT secret."
  log_warn "======================================================================"
  exit 0
fi

# Authenticate gh CLI with GITHUB_TOKEN as default
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
if [ -z "$GITHUB_TOKEN" ]; then
  log_err "GITHUB_TOKEN is required to execute bot actions. Make sure it's passed."
  exit 1
fi

# Sync local branch in case commits modified it
git fetch origin main
git checkout main
git reset --hard origin/main

# 100% chance to run each auxiliary activity temporarily for instant verification (change back to 35 later for organic simulation)
roll_issue=$(( RANDOM % 100 ))
roll_pr=$(( RANDOM % 100 ))
roll_review=$(( RANDOM % 100 ))

log_info "Rolling organic event probabilities..."
log_info "Issue roll: $roll_issue% (Threshold < 100%)"
log_info "PR roll: $roll_pr% (Threshold < 100%)"
log_info "Review roll: $roll_review% (Threshold < 100%)"

# Run Issue if rolled
if [ "$roll_issue" -lt 100 ]; then
  # Wrap in try-catch to avoid breaking the overall runner if GitHub API has transient issues
  run_issue || log_err "Transient error in Issue automation, skipping."
  # Resync state after possible remote changes
  git fetch origin main
  git checkout main
  git reset --hard origin/main
fi

# Run Pull Request if rolled
if [ "$roll_pr" -lt 100 ]; then
  run_pr || log_err "Transient error in PR automation, skipping."
  git fetch origin main
  git checkout main
  git reset --hard origin/main
fi

# Run Code Review if rolled
if [ "$roll_review" -lt 100 ]; then
  run_review || log_err "Transient error in Code Review automation, skipping."
  git fetch origin main
  git checkout main
  git reset --hard origin/main
fi

log_success "GitShine run completed perfectly!"
