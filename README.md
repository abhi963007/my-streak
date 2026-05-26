# 🟢 GitShine — Cloud Activity & Contribution Automator

A zero-maintenance GitHub contribution automator that runs **100% in the cloud** using GitHub Actions.  

Instead of just automating commits—which leaves your profile's activity overview circle 100% dominated by commits—GitShine generates a natural, highly balanced developer activity profile. It simulates real developer behaviour by organically combining:
- **Commits:** Regular commits pushed directly to `main`.
- **Issues:** Natural maintenance/health-check issues opened and closed dynamically.
- **Pull Requests:** Standard feature branches created, PRs opened, and merged automatically.
- **Code Reviews:** Bot-created PRs that you (via authentication token) approve, review, and merge!

This distributes your GitHub profile activity overview dynamically across all four quadrants (**Commits, Pull Requests, Issues, and Code Reviews**), creating a balanced, professional contribution profile.

---

## How It Works

1. A **GitHub Actions cron job** fires 6 times per day (every 4 hours, starting at 6:00 AM IST / 12:30 AM UTC).
2. A cloud Ubuntu runner checks out this repository.
3. The runner executes `scripts/gitshine.sh` which:
   - Always generates **10–25 random commits** to keep your daily streak alive.
   - Evaluates a **35% organic probability** roll for **Issues**, **Pull Requests**, and **Code Reviews**.
   - If triggered, performs the activity, registers it under your name, and cleans up after itself (deletes branches, closes issues, and merges PRs).
4. **No-leak cleanliness:** All created issues are closed, all branches are deleted, and all PRs are merged immediately to keep your repository looking spotless.
5. **Fallback Safety:** If no Personal Access Token (`USER_PAT`) is set up, the script gracefully performs **commits-only**, ensuring your green streak is never broken while waiting for setup.

---

## Setup Guide (10 minutes)

### Step 1 — Create a GitHub Repository
Go to [github.com/new](https://github.com/new) and create a **new private repository** (e.g. `my-streak`).  
**Do NOT** initialise it with a README — we will push from this local folder.

### Step 2 — Initialise & Push
Open your terminal in this folder and run:
```bash
git init
git add .
git commit -m "Initial commit — GitShine cloud activity automator"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPO>.git
git push -u origin main
```
*(Replace `<YOUR_USERNAME>` and `<YOUR_REPO>` with your actual values)*

### Step 3 — Enable Workflow Permissions
On your GitHub repository page:
1. Go to **Settings** → **Actions** → **General**.
2. Scroll down to **Workflow permissions**.
3. Select **"Read and write permissions"**.
4. Check **"Allow GitHub Actions to create and approve pull requests"**.
5. Click **Save**.

### Step 4 — Enable Multi-Dimensional Activity (Optional but Recommended)
To allow GitShine to create Issues, Pull Requests, and Code Reviews under your name, you must provide a **Personal Access Token (PAT)**. If you skip this step, it will only automate commits.

1. Go to your **GitHub Settings** → **Developer Settings** → **Personal Access Tokens** → **Fine-grained tokens**.
2. Click **Generate new token**.
3. Name it `GitShine Token`, select this repository (`my-streak`) under **Repository access**, and grant the following **Repository permissions**:
   - **Contents:** Read and Write (needed for commits & branches)
   - **Issues:** Read and Write (needed for opening & closing issues)
   - **Pull requests:** Read and Write (needed for opening, reviewing, & merging PRs)
4. Click **Generate token** and copy it.
5. Navigate to your repository settings page (**Settings** → **Secrets and variables** → **Actions**).
6. Click **New repository secret**, name it `USER_PAT`, and paste the token.

### Step 5 — Trigger a Test Run
1. Open the **Actions** tab on your repository.
2. Select **Daily Streak Keeper** from the left sidebar.
3. Click **Run workflow** → **Run workflow** (green button).
4. Let it run! Once it succeeds, check your GitHub profile! Today's square will be green, and you will see new organic contributions.

---

## Configuration

### Adjusting Organic Probability
Open `scripts/gitshine.sh` and locate the probability conditions:
```bash
if [ "$roll_issue" -lt 35 ]; then ...
```
- Change `35` to `50` for a higher frequency of activities.
- Change `35` to `10` for a much subtler, quieter profile.

### Adjusting Commits Intensity
Open `scripts/gitshine.sh` and locate:
```bash
commits_count=$(( RANDOM % 16 + 10 ))
```
- Change to generate more or fewer commits per run as desired.

---

## Showing Private Contributions on Your Profile
1. Go to your GitHub profile page.
2. Click on the **Contribution settings** dropdown (above the calendar).
3. Enable **"Private contributions"**.

Your privately-pushed commits, pull requests, issues, and reviews will now appear in your public calendar and activity breakdown chart!

---

## License
This project is for personal use. Use responsibly.
