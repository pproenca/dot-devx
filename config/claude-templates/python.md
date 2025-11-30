# CLAUDE.md

## Project Overview

[Description]

## Commands

```bash
uv sync                          # Install deps
uv run pytest                    # Run tests
uv run ruff format src/ tests/   # Format
uv run ruff check src/ --fix     # Lint
uv run mypy src/                 # Type check
```

## Architecture

- `src/` - Main package
- `tests/` - Pytest tests

## Current Focus

### Active Tasks

- [ ] [Task]

### Recent Context

[Notes]

## Notes for Claude

- Use UV for all commands (not pip)
- Prefer ruff over black/isort
- Use type hints everywhere
