---
name: nia-docs
description: Search library documentation and code examples via Nia
allowed-tools: [Bash, Read]
---

# Nia Documentation Search

Search across 3000+ packages (npm, PyPI, Crates, Go) and indexed sources for documentation and code examples.

## Usage

### Semantic search in a package
```bash
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package fastapi --query "dependency injection"
```

### Search with specific registry
```bash
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package react --registry npm --query "hooks patterns"
```

### Grep search for specific patterns
```bash
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package sqlalchemy --grep "session.execute"
```

### Universal search across indexed sources
```bash
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --search "error handling middleware"
```

## Options

| Option | Description |
|--------|-------------|
| `--package` | Package name to search in |
| `--registry` | Registry: npm, py_pi, crates, go_modules (default: npm) |
| `--query` | Semantic search query |
| `--grep` | Regex pattern to search |
| `--search` | Universal search across all indexed sources |
| `--limit` | Max results (default: 5) |

## Examples

```bash
# Python library usage
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package pydantic --registry py_pi --query "validators"

# React patterns
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package react --query "useEffect cleanup"

# Find specific function usage
mcp-exec $HOME/.claude/scripts/nia_docs.py \
  --package express --grep "app.use"
```

Requires `NIA_API_KEY` in environment or `nia` server in mcp_config.json.
