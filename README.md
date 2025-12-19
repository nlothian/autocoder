# AI Workflow Tools

Automation helpers that wire together git, GitHub, and AI coding assistants. Each subdirectory is self-contained, depends only on the Python standard library plus CLI tools such as `gh`, `llm`, `kilocode`, `claude`, `codex`, `amp`, and `vibe`, and can be run with `uv` or as an executable script.

## Layout

- `amp/`: Headless Amp workflows for fixing issues and addressing PR comments.
- `autocoder_utils/`: Shared Python helpers used by the Kilocode, Claude, Codex, Amp, and change-tracker flows (see the Autocoder Utils section below).
- `change-tracker/`: Git changelog generator used by the scheduled workflow.
- `claude/`: Executable shims for running the Claude workflows.
- `codex/`: Executable shims for the Codex workflows.
- `gh-pr-helper/`: Formatter that fetches and prints PR review comments; consumed by the PR comment helpers.
- `kilocode/`: Scripts that orchestrate Kilocode workflows together with git and GitHub helpers.

## Requirements

Install the following CLIs and ensure they are available on `PATH`:

- `uv` (for running the tools)
- `git`
- `gh` (GitHub CLI, authenticated with the target repo)
- `llm`
- `kilocode`
- `claude`
- `codex`
- `amp`
- `vibe`

Environment variables:

- `OPENAI_API_KEY` must be set (used by `llm` and other helpers)
- Optional `LLM_MODEL` override (defaults to `gpt-5-nano`)

Repository assumptions:

- Commands run inside a git repository whose default branch is `main`
- Remote name `origin` exists (used for `git log origin/main..`)

## Running flows

Each helper exposes a console entry point that `uv` can resolve, so the simplest invocation pattern is:

```bash
uv tool run --from ./ fix-issue-with-kilocode 123
uv tool run --from ./ address-pr-comments-with-kilocode 456
uv tool run --from ./ fix-issue-with-claude 789
uv tool run --from ./ address-pr-comments-with-claude 1011
uv tool run --from ./ fix-issue-with-codex 1213
uv tool run --from ./ address-pr-comments-with-codex 1415
uv tool run --from ./ fix-issue-with-amp 1617
uv tool run --from ./ address-pr-comments-with-amp 1819
uv tool run --from ./ fix-issue-with-mistral-vibe 2021
uv tool run --from ./ address-pr-comments-with-mistral-vibe 2223
uv tool run --from ./ gh-pr-helper owner/repo/pull/42
uv tool run --from ./ generate-changelog
```

Every script also retains its executable shebang, so you may run them directly via `.//<dir>/<script>` if that is more convenient.

## Change tracker

`change-tracker/generate-changelog.py` walks git history, computes stats, and writes daily markdown entries under `changes/`. It backs the `generate-changelog.yml` GitHub Action but can also be run manually:

```bash
uv tool run --from ./ generate-changelog
```

## Kilocode tools

### `fix-issue-with-kilocode`

Given an issue number, the helper:

- fetches the issue via `gh`
- creates a branch named `fix-kilocode/<issue>`
- runs `kilocode --auto` with the issue details
- stages and commits the edits
- pushes the branch and opens a PR with `llm`-generated content

Usage:

```bash
uv tool run --from ./ fix-issue-with-kilocode 123
uvx --refresh --from ./ fix-issue-with-kilocode 123 --timeout off
.//kilocode/fix-issue-with-kilocode 123
```

### `address-pr-comments-with-kilocode`

Pulls the PR branch, gathers comments via `gh-pr-helper`, feeds them to `kilocode --auto`, stages the updates, and pushes with an AI-generated message.

```bash
uv tool run --from ./ address-pr-comments-with-kilocode 456
```

## Claude tool

### `fix-issue-with-claude`

Mirrors the Kilocode issue workflow but runs `claude` in headless mode, saving resumable session data under `paige/`.

```bash
uv tool run --from ./ fix-issue-with-claude 789
```

### `address-pr-comments-with-claude`

Condenses PR feedback, streams instructions to Claude, stages the edits, and pushes the updates.

```bash
uv tool run --from ./ address-pr-comments-with-claude 1011
```

## Amp tool

### `fix-issue-with-amp`

Runs Amp headless (`amp -x`) against the target issue, creates a `fix-amp/<issue>` branch, applies edits, runs relevant tests, and finishes with a summary.

```bash
uv tool run --from ./ fix-issue-with-amp 1617
```

### `address-pr-comments-with-amp`

Summarizes outstanding PR comments, feeds the instructions to `amp -x`, stages the resulting changes, and pushes them back to the branch.

```bash
uv tool run --from ./ address-pr-comments-with-amp 1819
```

## Mistral Vibe tool

Both Vibe workflows call `vibe --prompt "<issue or PR context>"`, so ensure the `vibe` CLI is authenticated before running them.

### `fix-issue-with-mistral-vibe`

Creates `fix-mistral-vibe/<issue>`, streams the issue text to Vibe, stages the edits, and opens a PR.

```bash
uv tool run --from ./ fix-issue-with-mistral-vibe 2021
```

### `address-pr-comments-with-mistral-vibe`

Summarizes PR comments for Vibe, runs the prompt, stages the edits, and pushes the branch.

```bash
uv tool run --from ./ address-pr-comments-with-mistral-vibe 2223
```

## Codex tools

### `fix-issue-with-codex`

Drives `codex exec --full-auto --sandbox danger-full-access -` to read the issue, edit the repository, run tests, and summarize the outcome.

```bash
uv tool run --from ./ fix-issue-with-codex 1213
```

### `address-pr-comments-with-codex`

Feeds PR comments into Codex headless mode, stages the changes, and pushes them back to the PR.

```bash
uv tool run --from ./ address-pr-comments-with-codex 1415
```

## Autocoder Utils

Provides shared helpers for the AI workflows, covering command availability, environment setup, git operations, and subprocess handling.

### Key functions

- `check_commands_available(required)`
- `ensure_env()`
- `stage_changes()`, `has_staged_changes()`, `get_repo_root()`, `get_owner_repo()`
- `run(cmd, input_text=None, capture_output=True)`

### Testing

`tests/test_autocoder_utils.py` exercises the helpers, and `tests/test_gh_pr_helper.py` covers the PR comment formatter. Run them with:

```bash
uv run pytest tests/test_autocoder_utils.py
uv run pytest tests/test_gh_pr_helper.py
```

## gh-pr-helper

Fetches review and issue comments via `gh` and formats them for the workflows. Invoke it directly when you need the comment dump:

```bash
uv tool run --from ./ gh-pr-helper owner/repo/pull/42
```
