# 🟢 GitShine — Cloud Contribution Streak Keeper

A zero-maintenance GitHub contribution automator that runs **100% in the cloud** using GitHub Actions.  
Every day, a scheduled workflow generates **50–100 randomised commits**, keeping your profile contribution calendar permanently green — even on days you don't write a single line of code.

---

## How It Works

1. A **GitHub Actions cron job** fires once per day (default: 10:00 AM UTC / 3:30 PM IST).
2. A cloud Ubuntu runner checks out this repository.
3. A bash script picks a random number between 50 and 100, then loops that many times — each iteration appends a timestamped line to `contributions.txt` and creates a git commit.
4. All commits are pushed back to `main`, and GitHub registers them on your profile calendar.

> **Tip:** Use a **private** repository so the automation stays invisible.  
> Enable *"Private contributions"* in your GitHub profile settings to make those commits count on your public calendar.

---

## Quick Start (5 minutes)

### 1 — Create a GitHub Repository

Go to [github.com/new](https://github.com/new) and create a **new private repository** (e.g. `my-streak`).  
**Do NOT** initialise it with a README — we will push from this local folder.

### 2 — Initialise & Push

Open a terminal **in this folder** and run:

```bash
git init
git add .
git commit -m "Initial commit — GitShine cloud streak keeper"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPO>.git
git push -u origin main
```

Replace `<YOUR_USERNAME>` and `<YOUR_REPO>` with your actual values.

### 3 — Enable Workflow Write Permissions

On your GitHub repository page:

1. Go to **Settings** → **Actions** → **General**.
2. Scroll to **Workflow permissions**.
3. Select **"Read and write permissions"**.
4. Check **"Allow GitHub Actions to create and approve pull requests"**.
5. Click **Save**.

### 4 — Trigger a Test Run

1. Open the **Actions** tab on your repository.
2. Select **Daily Streak Keeper** from the left sidebar.
3. Click **Run workflow** → **Run workflow** (green button).
4. Wait ~2 minutes. Once the run succeeds, check your GitHub profile — today's square should be bright green!

From now on the workflow runs automatically every day. No further action needed.

---

## Configuration

### Change the Schedule

Edit `.github/workflows/daily-streak.yml` and modify the cron expression:

```yaml
schedule:
  - cron: '0 10 * * *'   # 10:00 AM UTC — change this
```

Useful cron examples:
| Cron Expression   | Meaning                |
|-------------------|------------------------|
| `0 10 * * *`      | Daily at 10:00 AM UTC  |
| `0 6 * * *`       | Daily at 6:00 AM UTC   |
| `30 18 * * *`     | Daily at 6:30 PM UTC   |
| `0 */6 * * *`     | Every 6 hours          |

### Change Commit Intensity

In the same file, find this line:

```bash
commits=$(( RANDOM % 51 + 50 ))
```

- `RANDOM % 51 + 50` → generates 50–100 commits.
- Change to `RANDOM % 11 + 5` for 5–15 commits (subtler).
- Change to `RANDOM % 101 + 100` for 100–200 commits (aggressive).

---

## Show Private Contributions on Your Profile

1. Go to your GitHub profile page.
2. Click on the **Contribution settings** dropdown (above the calendar).
3. Enable **"Private contributions"**.

Your privately-pushed commits will now appear as green squares on your public profile.

---

## Stopping the Automator

To pause or stop the daily runs:

1. Go to **Actions** → **Daily Streak Keeper**.
2. Click the **⋯** menu (top right).
3. Select **Disable workflow**.

You can re-enable it at any time.

---

## License

This project is for personal use. Use responsibly.
