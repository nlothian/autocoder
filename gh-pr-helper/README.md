# GitHub PR Comment Formatter

A command-line tool that fetches GitHub PR comments and formats them in markdown suitable for AI coding agents.

## Prerequisites

- Python 3.12+
- [GitHub CLI (`gh`)](https://cli.github.com/) installed and authenticated

## Installation

```bash
# Clone or navigate to this directory
cd gh-pr-helper

# Make the script executable (if not already)
chmod +x gh-pr-helper

# Optionally, add to your PATH for easier access
# ln -s $(pwd)/gh-pr-helper /usr/local/bin/gh-pr-helper
```

No additional dependencies needed - uses only Python standard library.

## Usage

The tool supports two input formats:

### Option 1: PR Path (recommended)

```bash
./gh-pr-helper nlothian/Vibe-Prolog/pull/10
```

### Option 2: Separate Arguments

```bash
./gh-pr-helper --owner nlothian --repo Vibe-Prolog --pr 10
```

### Examples

```bash
# Fetch comments from a PR
./gh-pr-helper nlothian/Vibe-Prolog/pull/10

# Save output to a file
./gh-pr-helper nlothian/Vibe-Prolog/pull/10 > pr-comments.md

# Use with separate arguments
./gh-pr-helper --owner nlothian --repo Vibe-Prolog --pr 10

# If added to PATH, you can run it from anywhere
gh-pr-helper nlothian/Vibe-Prolog/pull/10
```

## Output Format

The tool outputs markdown in two sections:

### 1. General PR Comments
Comments posted on the PR itself (not tied to specific code lines)

### 2. Inline Code Review Comments
Comments on specific lines in the diff, organized by:
- **File path**: Comments grouped by the file they refer to
- **Line numbers**: Each comment shows which line(s) it references
- **Code context**: The diff hunk showing the relevant code
- **Comment text**: The actual review comment

Example output:
```markdown
# PR Comments: nlothian/Vibe-Prolog#10

## General PR Comments

### @reviewer
Overall this looks good, but please address the inline comments below.

## Inline Code Review Comments

### File: `src/main.py`

#### Line 42 (@reviewer)

**Code context:**
```diff
@@ -40,7 +40,7 @@
 def process_data():
-    return old_implementation()
+    return new_implementation()
```

**Comment:**
Consider adding error handling here for edge cases.
```

## What's Included/Excluded

**Included** (useful for AI agents):
- General PR comments (overall feedback)
- Inline review comments on specific code lines
- File paths
- Line numbers
- Code context (diff hunks)
- Comment text
- Commenter username

**Excluded** (not useful for addressing comments):
- User IDs and avatar URLs
- Timestamps
- HTML URLs
- Node IDs
- Reaction counts

## License

MIT
