# AGENTS.md - Guidelines for AI Agents

This document provides guidelines for AI agents working on this codebase.

## Project Overview

- **Project**: Ollama Proxy - A Flask-based HTTP proxy for logging and forwarding requests to an Ollama LLM server
- **Language**: Python 3.11+
- **Main entry point**: `ollama_proxy.py`

## Build, Lint, and Test Commands

### Running the Application

```bash
# Install dependencies
uv sync

# Run the proxy server
uv run ollama_proxy.py

# Or with custom environment
cp sample.env .env
# Edit .env with your TARGET_URL and TARGET_API_KEY
uv run ollama_proxy.py
```

### Docker

```bash
# Build the container
docker build -t ollama_proxy .

# Run the container
docker run -d --rm \
    -e TARGET_URL=https://openwebui.example.com/ollama \
    -e TARGET_API_KEY=MY_BEARER_KEY \
    -p 11434:11434 \
    ollama_proxy
```

### Testing

This project currently has no test suite. When adding tests:

```bash
# Install pytest (add to pyproject.toml if needed)
uv add --dev pytest pytest-cov

# Run all tests
uv run pytest

# Run a single test file
uv run pytest tests/test_ollama_proxy.py

# Run a single test function
uv run pytest tests/test_ollama_proxy.py::test_function_name -v
```

### Linting and Type Checking

```bash
# Install linting tools
uv add --dev ruff black mypy

# Run ruff (linting)
uv run ruff check .

# Run ruff with auto-fix
uv run ruff check --fix .

# Run black (formatting)
uv run black .

# Check formatting without making changes
uv run black --check .

# Run mypy (type checking)
uv run mypy .
```

## Code Style Guidelines

### Imports

- Standard library imports first
- Third-party imports second
- Local imports last
- Group with blank lines between groups
- Use absolute imports (not relative)

```python
# Correct
import datetime
import json
import os

from flask import Flask, request, Response
from icecream import ic

# Avoid: from . import module
```

### Formatting

- Line length: 88 characters (Black default)
- Use 4 spaces for indentation (no tabs)
- Use trailing commas in multi-line structures
- One blank line between top-level definitions

### Type Annotations

- Use type hints for function parameters and return types
- Use `str | None` syntax (Python 3.10+) for union types

```python
# Correct
def obfuscate_key(key: str | None, num_visible_chars: int = 4) -> str | None:
    ...

# Avoid
def obfuscate_key(key, num_visible_chars=4):
    ...
```

### Naming Conventions

- **Functions/variables**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private members**: Prefix with underscore `_private_method`
- Use descriptive, full words over abbreviations (except well-known: `url`, `api`, `id`)

### Error Handling

- Use try/except blocks sparingly and specifically
- Catch specific exceptions, not bare `Exception`
- Include context in error messages
- Let exceptions propagate when appropriate

```python
# Good
try:
    request_json = json.loads(request_body)
except json.JSONDecodeError as e:
    ic(f"Failed to decode request body: {e}")
    raise

# Avoid
try:
    request_json = json.loads(request_body)
except:  # Too broad
    pass
```

### Docstrings and Comments

- Use docstrings for public functions and classes
- Follow Google or NumPy style docstrings
- Keep comments updated or remove them
- NO comments for obvious code (the code should be self-documenting)

```python
def create_log_dir() -> str:
    """Creates a new subdirectory for each transaction."""
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    log_dir = f"logs/{timestamp}"
    os.makedirs(log_dir, exist_ok=True)
    return log_dir
```

### Logging

- Use `icecream` (`ic()`) for debug logging during development
- Consider using the standard `logging` module for production code

### Request/Response Handling

- Always handle request body safely (check for None/empty)
- Stream large responses rather than loading into memory
- Forward hop-by-hop headers appropriately
- Preserve Content-Type headers

### Testing Guidelines

- Place tests in `tests/` directory
- Name test files as `test_<module>.py`
- Use `pytest` as the test runner
- Write descriptive test names: `test_function_name_scenario_expected_result`
- Use fixtures for shared setup
- Aim for high coverage on core functionality

### File Organization

```text
llm_proxy/
├── ollama_proxy.py      # Main application
├── pyproject.toml       # Project config
├── Dockerfile           # Container definition
├── sample.env          # Environment template
├── .env                # Local env (gitignored)
├── logs/               # Request/response logs (gitignored)
├── tests/             # Test files (create if needed)
└── AGENTS.md          # This file
```

### Git Conventions

- Make atomic commits
- Use conventional commit messages: `feat:`, `fix:`, `refactor:`, `docs:`
- Never commit secrets, `.env`, or `.venv/`
- Run linting before committing

### Performance Considerations

- Use streaming for large responses (as implemented in `generate_stream()`)
- Set appropriate timeouts for external requests
- Avoid loading entire response bodies into memory when possible

## Common Tasks

### Adding a new dependency

```bash
uv add requests
uv add --dev pytest
```

### Adding a new environment variable

1. Add default value in `ollama_proxy.py` using `os.getenv("VAR_NAME", "default")`
2. Document in `sample.env`
3. Update Dockerfile if needed

### Modifying request/response flow

The main proxy logic is in the `proxy()` function in `ollama_proxy.py`. Look for:

- Request modification: lines ~86-130
- Response streaming: lines ~170-202

<!-- EOF -->
