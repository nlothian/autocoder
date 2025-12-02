# Change Tracker

Generates dated markdown change logs under `changes/` by scanning git history.
It powers the scheduled `generate-changelog.yml` workflow but can also be run
locally to capture a snapshot of recent work.

## Usage

```bash
python ai-tools/change-tracker/generate-changelog.py
```

The script automatically:

1. Finds the most recent `changes/YYYY/MM/DD-CHANGES.md` file to determine the
   last date processed.
2. Collects commit metadata and file statistics since that date.
3. Writes a new markdown file for today with commit summaries and aggregate stats.
