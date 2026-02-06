# Continuous Claude

> A persistent, learning, multi-agent development environment built on Claude Code

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange.svg)](https://claude.ai/code)
[![Skills](https://img.shields.io/badge/Skills-109-green.svg)](#skills-system)
[![Agents](https://img.shields.io/badge/Agents-32-purple.svg)](#agents-system)
[![Hooks](https://img.shields.io/badge/Hooks-30-blue.svg)](#hooks-system)

**Continuous Claude** transforms Claude Code into a continuously learning system that maintains context across sessions, orchestrates specialized agents, and eliminates wasting tokens through intelligent code analysis.

## Table of Contents

- [Why Continuous Claude?](#why-continuous-claude)
- [Design Principles](#design-principles)
- [How to Talk to Claude](#how-to-talk-to-claude)
<<<<<<< HEAD
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Core Systems](#core-systems)
  - [Skills (109)](#skills-system)
  - [Agents (32)](#agents-system)
  - [Hooks (30)](#hooks-system)
  - [TLDR Code Analysis](#tldr-code-analysis)
  - [Memory System](#memory-system)
  - [Continuity System](#continuity-system)
  - [Math System](#math-system)
- [Workflows](#workflows)
- [Installation](#installation)
- [Updating](#updating)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
=======
- [Skills vs Agents](#skills-vs-agents)
- [MCP Code Execution](#mcp-code-execution)
- [Continuity System](#continuity-system)
- [Hooks System](#hooks-system)
- [Notifications](#notifications) (Windows Toast, Telegram)
- [Reasoning History](#reasoning-history)
- [Braintrust Session Tracing](#braintrust-session-tracing-optional) + [Compound Learnings](#compound-learnings)
- [Artifact Index](#artifact-index) (handoff search, outcome tracking)
- [TDD Workflow](#tdd-workflow)
- [Code Quality (qlty)](#code-quality-qlty)
- [Directory Structure](#directory-structure)
- [Environment Variables](#environment-variables)
- [Glossary](#glossary)
- [Troubleshooting](#troubleshooting)
- [Acknowledgments](#acknowledgments)

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

---

## Why Continuous Claude?

Claude Code has a **compaction problem**: when context fills up, the system compacts your conversation, losing nuanced understanding and decisions made during the session.

**Continuous Claude solves this with:**

| Problem | Solution |
|---------|----------|
| Context loss on compaction | YAML handoffs - more token-efficient transfer |
| Starting fresh each session | Memory system recalls + daemon auto-extracts learnings |
| Reading entire files burns tokens | 5-layer code analysis + semantic index |
| Complex tasks need coordination | Meta-skills orchestrate agent workflows |
| Repeating workflows manually | 109 skills with natural language triggers |

**The mantra: Compound, don't compact.** Extract learnings automatically, then start fresh with full context.

### Why "Continuous"? Why "Compounding"?

The name is a pun. **Continuous** because Claude maintains state across sessions. **Compounding** because each session makes the system smarter—learnings accumulate like compound interest.

---

## Design Principles

An agent is five things: **Prompt + Tools + Context + Memory + Model**.

| Component | What We Optimize |
|-----------|------------------|
| **Prompt** | Skills inject relevant context; hooks add system reminders |
| **Tools** | TLDR reduces tokens; agents parallelize work |
| **Context** | Not just *what* Claude knows, but *how* it's provided |
| **Memory** | Daemon extracts learnings; recall surfaces them |
| **Model** | Becomes swappable when the other four are solid |

### Anti-Complexity

We resist plugin sprawl. Every MCP, subscription, and tool you add promises improvement but risks breaking context, tools, or prompts through clashes.

**Our approach:**

- **Time, not money** — No required paid services. Perplexity and NIA are optional, high-value-per-token.
- **Learn, don't accumulate** — A system that learns handles edge cases better than one that collects plugins.
- **Shift-left validation** — Hooks run pyright/ruff after edits, catching errors before tests.

The failure modes of complex systems are structurally invisible until they happen. A learning, context-efficient system doesn't prevent all failures—but it recovers and improves.

---

## How to Talk to Claude

**You don't need to memorize slash commands.** Just describe what you want naturally.

### The Skill Activation System

When you send a message, a hook injects context that tells **Claude** which skills and agents are relevant. Claude infers from a rule-based system and decides which tools to use.

```
> "Fix the login bug in auth.py"

🎯 SKILL ACTIVATION CHECK
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️ CRITICAL SKILLS (REQUIRED):
  → create_handoff

📚 RECOMMENDED SKILLS:
  → fix
  → debug

🤖 RECOMMENDED AGENTS (token-efficient):
  → debug-agent
  → scout

ACTION: Use Skill tool BEFORE responding
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Priority Levels

| Level | Meaning |
|-------|---------|
| ⚠️ **CRITICAL** | Must use (e.g., handoffs before ending session) |
| 📚 **RECOMMENDED** | Should use (e.g., workflow skills) |
| 💡 **SUGGESTED** | Consider using (e.g., optimization tools) |
| 📌 **OPTIONAL** | Nice to have (e.g., documentation helpers) |

### Natural Language Examples

| What You Say | What Activates |
|--------------|----------------|
| "Fix the broken login" | `/fix` workflow → debug-agent, scout |
| "Build a user dashboard" | `/build` workflow → plan-agent, kraken |
| "I want to understand this codebase" | `/explore` + scout agent |
| "What could go wrong with this plan?" | `/premortem` |
| "Help me figure out what I need" | `/discovery-interview` |
| "Done for today" | `create_handoff` (critical) |
| "Resume where we left off" | `resume_handoff` |
| "Research auth patterns" | oracle agent + perplexity |
| "Find all usages of this API" | scout agent + ast-grep |

### Why This Approach?

| Benefit | How |
|---------|-----|
| **More Discoverable** | Don't need to know commands exist |
| **Context-Aware** | System knows when you're 90% through context |
| **Reduces Cognitive Load** | Describe intent naturally, get curated suggestions |
| **Power User Friendly** | Still supports /fix, /build, etc. directly |

### Skill vs Workflow vs Agent

| Type | Purpose | Example |
|------|---------|---------|
| **Skill** | Single-purpose tool | `commit`, `tldr-code`, `qlty-check` |
| **Workflow** | Multi-step process | `/fix` (sleuth → premortem → kraken → commit) |
| **Agent** | Specialized sub-session | scout (exploration), oracle (research) |

[See detailed skill activation docs →](docs/skill-activation.md)

---

## Quick Start

### Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager
- Docker (for PostgreSQL)
- Claude Code CLI

### Installation

```bash
# Clone
git clone https://github.com/parcadei/Continuous-Claude-v3.git
cd Continuous-Claude-v3/opc

# Run setup wizard (12 steps)
uv run python -m scripts.setup.wizard
```

> **Note:** The `pyproject.toml` is in `opc/`. Always run `uv` commands from the `opc/` directory.

### What the Wizard Does

| Step | What It Does |
|------|--------------|
| 1 | Backup existing .claude/ config (if present) |
| 2 | Check prerequisites (Docker, Python, uv) |
| 3-5 | Database + API key configuration |
| 6-7 | Start Docker stack, run migrations |
| 8 | Install Claude Code integration (32 agents, 109 skills, 30 hooks) |
| 9 | Math features (SymPy, Z3, Pint - optional) |
| 10 | TLDR code analysis tool |
| 11-12 | Diagnostics tools + Loogle (optional) |

#### To Uninstall

```
cd Continuous-Claude-v3/opc
  uv run python -m scripts.setup.wizard --uninstall
```

**What it does**

1. Archives your current setup → Moves ~/.claude to ~/.claude-v3.archived.<timestamp>
2. Restores your backup → Finds the most recent ~/.claude.backup.* (created during install) and restores it
3. Preserves user data → Copies these back from the archive:

- history.jsonl (your command history)
- mcp_config.json (MCP servers)
- .env (API keys)
- projects.json (project configs)
- file-history/ directory
- projects/ directory

4. Removes CC-v3 additions → Everything else (hooks, skills, agents, rules)

**Safety Features**

- Your current setup is archived with timestamp - nothing gets deleted
- The wizard asks for confirmation before proceeding
- It restores from the backup that was made during installation
- All your Claude Code settings stay intact

### Remote Database Setup

By default, CC-v3 runs PostgreSQL locally via Docker. For remote database setups:

#### 1. Database Preparation

```bash
# Connect to your remote PostgreSQL instance
psql -h hostname -U user -d continuous_claude

# Enable pgvector extension (requires superuser or rds_superuser)
CREATE EXTENSION IF NOT EXISTS vector;

# Apply the schema (from your local clone)
psql -h hostname -U user -d continuous_claude -f docker/init-schema.sql
```

> **Managed PostgreSQL tips:**
>
> - **AWS RDS**: Add `vector` to `shared_preload_libraries` in DB Parameter Group
> - **Supabase**: Enable via Database Extensions page
> - **Azure Database**: Use Extensions pane to enable pgvector

#### 2. Connection Configuration

Set `CONTINUOUS_CLAUDE_DB_URL` in `~/.claude/settings.json`:

```json
{
  "env": {
    "CONTINUOUS_CLAUDE_DB_URL": "postgresql://user:password@hostname:5432/continuous_claude"
  }
}
```

Or export before running Claude:

```bash
export CONTINUOUS_CLAUDE_DB_URL="postgresql://user:password@hostname:5432/continuous_claude"
claude
```

See `.env.example` for all available environment variables.

### First Session

```bash
# Start Claude Code
claude

# Try a workflow
> /workflow
```

### First Session Commands

| Command | What it does |
|---------|--------------|
| `/workflow` | Goal-based routing (Research/Plan/Build/Fix) |
| `/fix bug <description>` | Investigate and fix a bug |
| `/build greenfield <feature>` | Build a new feature from scratch |
| `/explore` | Understand the codebase |
| `/premortem` | Risk analysis before implementation |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CONTINUOUS CLAUDE                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │   Skills    │    │   Agents    │    │    Hooks    │             │
│  │   (109)     │───▶│    (32)     │◀───│    (30)     │             │
│  └─────────────┘    └─────────────┘    └─────────────┘             │
│         │                  │                  │                     │
│         ▼                  ▼                  ▼                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     TLDR Code Analysis                       │   │
│  │   L1:AST → L2:CallGraph → L3:CFG → L4:DFG → L5:Slicing      │   │
│  │                    (95% token savings)                       │   │
│  └─────────────────────────────────────────────────────────────┘   │
│         │                  │                  │                     │
│         ▼                  ▼                  ▼                     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │   Memory    │    │ Continuity  │    │ Coordination│             │
│  │   System    │    │   Ledgers   │    │    Layer    │             │
│  └─────────────┘    └─────────────┘    └─────────────┘             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Data Flow: Session Lifecycle

```
SessionStart                    Working                      SessionEnd
    │                              │                             │
    ▼                              ▼                             ▼
┌─────────┐                  ┌─────────┐                   ┌─────────┐
│  Load   │                  │  Track  │                   │  Save   │
│ context │─────────────────▶│ changes │──────────────────▶│  state  │
└─────────┘                  └─────────┘                   └─────────┘
    │                              │                             │
    ├── Continuity ledger          ├── File claims               ├── Handoff
    ├── Memory recall              ├── TLDR indexing             ├── Learnings
    └── Symbol index               └── Blackboard                └── Outcome
                                         │
                                         ▼
                                    ┌─────────┐
                                    │ /clear  │
                                    │ Fresh   │
                                    │ context │
                                    └─────────┘
```

### The Continuity Loop (Detailed)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            THE CONTINUITY LOOP                              │
└─────────────────────────────────────────────────────────────────────────────┘

  1. SESSION START                     2. WORKING
  ┌────────────────────┐               ┌────────────────────┐
  │                    │               │                    │
  │  Ledger loaded ────┼──▶ Context    │  PostToolUse ──────┼──▶ Index handoffs
  │  Handoff loaded    │               │  UserPrompt ───────┼──▶ Skill hints
  │  Memory recalled   │               │  Edit tracking ────┼──▶ Dirty flag++
  │  TLDR cache warmed │               │  SubagentStop ─────┼──▶ Agent reports
  │                    │               │                    │
  └────────────────────┘               └────────────────────┘
           │                                    │
           │                                    ▼
           │                           ┌────────────────────┐
           │                           │ 3. PRE-COMPACT     │
           │                           │                    │
           │                           │  Auto-handoff ─────┼──▶ thoughts/shared/
           │                           │  (YAML format)     │    handoffs/*.yaml
           │                           │  Dirty > 20? ──────┼──▶ TLDR re-index
           │                           │                    │
           │                           └────────────────────┘
           │                                    │
           │                                    ▼
           │                           ┌────────────────────┐
           │                           │ 4. SESSION END     │
           │                           │                    │
           │                           │  Stale heartbeat ──┼──▶ Daemon wakes
           │                           │  Daemon spawns ────┼──▶ Headless Claude
           │                           │  Thinking blocks ──┼──▶ archival_memory
           │                           │                    │
           │                           └────────────────────┘
           │                                    │
           │                                    │
           └──────────────◀────── /clear ◀──────┘
                          Fresh context + state preserved
```

### Workflow Chains

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           META-SKILL WORKFLOWS                              │
└─────────────────────────────────────────────────────────────────────────────┘

  /fix bug                              /build greenfield
  ─────────                             ─────────────────
  ┌──────────┐  ┌──────────┐            ┌──────────┐  ┌──────────┐
  │  sleuth  │─▶│ premortem│            │discovery │─▶│plan-agent│
  │(diagnose)│  │  (risk)  │            │(clarify) │  │ (design) │
  └──────────┘  └────┬─────┘            └──────────┘  └────┬─────┘
                     │                                      │
                     ▼                                      ▼
              ┌──────────┐                          ┌──────────┐
              │  kraken  │                          │ validate │
              │  (fix)   │                          │ (check)  │
              └────┬─────┘                          └────┬─────┘
                   │                                      │
                   ▼                                      ▼
              ┌──────────┐                          ┌──────────┐
              │  arbiter │                          │  kraken  │
              │ (test)   │                          │(implement│
              └────┬─────┘                          └────┬─────┘
                   │                                      │
                   ▼                                      ▼
              ┌──────────┐                          ┌──────────┐
              │  commit  │                          │  commit  │
              └──────────┘                          └──────────┘


  /tdd                                  /refactor
  ────                                  ─────────
  ┌──────────┐  ┌──────────┐            ┌──────────┐  ┌──────────┐
  │plan-agent│─▶│  arbiter │            │ phoenix  │─▶│  warden  │
  │ (design) │  │(tests 🔴)│            │(analyze) │  │ (review) │
  └──────────┘  └────┬─────┘            └──────────┘  └────┬─────┘
                     │                                      │
                     ▼                                      ▼
              ┌──────────┐                          ┌──────────┐
              │  kraken  │                          │  kraken  │
              │(code 🟢) │                          │(transform│
              └────┬─────┘                          └────┬─────┘
                   │                                      │
                   ▼                                      ▼
              ┌──────────┐                          ┌──────────┐
              │  arbiter │                          │  judge   │
              │(verify ✓)│                          │ (review) │
              └──────────┘                          └──────────┘
```

### Data Layer Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER ARCHITECTURE                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  TLDR 5-LAYER CODE ANALYSIS              SEMANTIC INDEX                     │
│  ┌────────────────────────┐              ┌────────────────────────┐         │
│  │ L1: AST (~500 tok)     │              │ BGE-large-en-v1.5      │         │
│  │     └── Functions,     │              │ ├── All 5 layers       │         │
│  │         classes, sigs  │              │ ├── 10 lines context   │         │
│  │                        │              │ └── FAISS index        │         │
│  │ L2: Call Graph (+440)  │              │                        │         │
│  │     └── Cross-file     │──────────────│ Query: "auth logic"    │         │
│  │         dependencies   │              │ Returns: ranked funcs  │         │
│  │                        │              └────────────────────────┘         │
│  │ L3: CFG (+110 tok)     │                                                 │
│  │     └── Control flow   │                                                 │
│  │                        │              MEMORY (PostgreSQL+pgvector)       │
│  │ L4: DFG (+130 tok)     │              ┌────────────────────────┐         │
│  │     └── Data flow      │              │ sessions (heartbeat)   │         │
│  │                        │              │ file_claims (locks)    │         │
│  │ L5: PDG (+150 tok)     │              │ archival_memory (BGE)  │         │
│  │     └── Slicing        │              │ handoffs (embeddings)  │         │
│  └────────────────────────┘              └────────────────────────┘         │
│         ~1,200 tokens                                                       │
│         vs 23,000 raw                                                       │
│         = 95% savings                    FILE SYSTEM                        │
│                                          ┌────────────────────────┐         │
│                                          │ thoughts/              │         │
│                                          │ ├── ledgers/           │         │
│                                          │ │   └── CONTINUITY_*.md│         │
│                                          │ └── shared/            │         │
│                                          │     ├── handoffs/*.yaml│         │
│                                          │     └── plans/*.md     │         │
│                                          │                        │         │
│                                          │ .tldr/                 │         │
│                                          │ └── (daemon cache)     │         │
│                                          └────────────────────────┘         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Core Systems

### Skills System

Skills are modular capabilities triggered by natural language. Located in `.claude/skills/`.

#### Meta-Skills (Workflow Orchestrators)

| Meta-Skill | Chain | Use When |
|------------|-------|----------|
| `/workflow` | Router → appropriate workflow | Don't know where to start |
| `/build` | discovery → plan → validate → implement → commit | Building features |
| `/fix` | sleuth → premortem → kraken → test → commit | Fixing bugs |
| `/tdd` | plan → arbiter (tests) → kraken (implement) → arbiter | Test-first development |
| `/refactor` | phoenix → plan → kraken → reviewer → arbiter | Safe code transformation |
| `/review` | parallel specialized reviews → synthesis | Code review |
| `/explore` | scout (quick/deep/architecture) | Understand codebase |
| `/security` | vulnerability scan → verification | Security audits |
| `/release` | audit → E2E → review → changelog | Ship releases |

#### Meta-Skill Reference

<<<<<<< HEAD
Each meta-skill supports modes, scopes, and flags. Type the skill alone (e.g., `/build`) to get an interactive question flow
=======

**Why this works:**

- Ledgers are lossless - you control what's saved
- Fresh context = full signal
- Agents spawn with clean context, not degraded summaries

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

**`/build <mode> [options] [description]`**

| Mode | Chain | Use For |
|------|-------|---------|
| `greenfield` | discovery → plan → validate → implement → commit → PR | New feature from scratch |
| `brownfield` | onboard → research → plan → validate → implement | Feature in existing codebase |
| `tdd` | plan → test-first → implement | Test-driven development |
| `refactor` | impact analysis → plan → TDD → implement | Safe refactoring |

<<<<<<< HEAD

| Option | Effect |
|--------|--------|
| `--skip-discovery` | Skip interview phase (have clear spec) |
| `--skip-validate` | Skip plan validation |
| `--skip-commit` | Don't auto-commit |
| `--skip-pr` | Don't create PR description |
| `--parallel` | Run research agents in parallel |
=======
**Which option?**

- Just trying it on ONE project? → Start with Option 1
- Want it on ALL your projects? → Do Option 2 (global), then Option 3 (per-project)

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

**`/fix <scope> [options] [description]`**

<<<<<<< HEAD
| Scope | Chain | Use For |
=======

```bash
# Clone
git clone https://github.com/parcadei/claude-continuity-kit.git
cd claude-continuity-kit

# Install Python deps
uv sync

# Configure (optional - add API keys for extra features)
cp .env.example .env

# Start
claude
```

**Works immediately** - hooks are pre-bundled, no `npm install` needed.

### Option 2: Install Globally (Use in Any Project)

```bash
# After cloning and syncing
./install-global.sh
```

**What it does:**

```
┌─────────────────────────────────────────────────────────────┐
│  Continuous Claude - Global Installation                    │
└─────────────────────────────────────────────────────────────┘

This will install to: ~/.claude

⚠️  WARNING: The following will be REPLACED:
   • ~/.claude/skills/     (all skills)
   • ~/.claude/agents/     (all agents)
   • ~/.claude/rules/      (all rules)
   • ~/.claude/hooks/      (all hooks)
   • ~/.claude/settings.json (backup created)

✓ PRESERVED (not touched):
   • ~/.claude/.env
   • ~/.claude/cache/
   • ~/.claude/state/

📦 A full backup will be created at ~/.claude-backup-<timestamp>

Continue with installation? [y/N] y

Installing Continuous Claude to ~/.claude...

✓ uv installed (Python package manager)
✓ qlty installed (code quality toolkit)
Installing MCP runtime package globally...
✓ MCP commands installed: mcp-exec, mcp-generate, mcp-discover

Creating full backup at ~/.claude-backup-20251225_043445...
Backup complete. To restore: rm -rf ~/.claude && mv ~/.claude-backup-<timestamp> ~/.claude

Copying skills...
Copying agents...
Copying rules...
Copying hooks...
Copying scripts...
Copying plugins...
Installing settings.json...
Creating .env template...

Installation complete!
```

**Global MCP cleanup (optional):**

If you have MCP servers defined globally in `~/.claude.json`, the script detects them:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  GLOBAL MCP SERVERS DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Found 9 global MCP servers in ~/.claude.json:
  • agi-memory
  • ast-grep
  • beads
  • firecrawl
  • github
  ...

These servers are inherited by ALL projects and can cause
skills to use unexpected tools (e.g., /onboard using 'beads').

Recommended: Remove global MCP servers and configure them
per-project in each project's .mcp.json instead.

Remove global MCP servers from ~/.claude.json? [y/N] y
Backup created: ~/.claude.json.backup.<timestamp>
✓ Removed global MCP servers

To restore: cp ~/.claude.json.backup.<timestamp> ~/.claude.json
```

**Why remove global MCP?** Global MCP servers are inherited by ALL projects. This can cause unexpected behavior where skills use random tools instead of following their instructions. Best practice: configure MCP servers per-project in `.mcp.json`.

### Option 3: Initialize a New Project

After global install, set up any project for full continuity support:

```bash
cd your-project
~/.claude/scripts/init-project.sh
```

**What it does:**

```
┌─────────────────────────────────────────────────────────────┐
│  Continuous Claude - Project Initialization                 │
└─────────────────────────────────────────────────────────────┘

This will create:
  • thoughts/ledgers/     - Continuity ledgers
  • thoughts/shared/      - Plans and handoffs
  • .claude/cache/        - Artifact Index database

Project: /path/to/your-project

Continue? [y/N] y

Creating directories...
✓ thoughts/ledgers/
✓ thoughts/shared/handoffs/
✓ thoughts/shared/plans/
✓ .claude/cache/artifact-index/

Initializing Artifact Index database...
✓ Created context.db with FTS5 schema

Adding to .gitignore...
✓ Added .claude/cache/ to .gitignore

Project initialized! You can now:
  • Use /continuity_ledger to save session state
  • Use /create_handoff to create session handoffs
  • Use /onboard to analyze the codebase
```

This creates:

- `thoughts/` - Plans, handoffs, ledgers (gitignored)
- `.claude/cache/artifact-index/` - Local search database (SQLite + FTS5)
- Adds `.claude/cache/` to `.gitignore`

**For brownfield projects**, run `/onboard` after initialization to analyze the codebase and create an initial ledger.

### What's Optional?

All external services are optional. Without API keys:

- **Continuity system**: Works (no external deps)
- **TDD workflow**: Works (no external deps)
- **Session tracing**: Disabled (needs BRAINTRUST_API_KEY)
- **Web search**: Disabled (needs PERPLEXITY_API_KEY)
- **Code search**: Falls back to grep (MORPH_API_KEY speeds it up)

See `.env.example` for the full list of optional services.

---

## How to Talk to Claude

This kit responds to natural language triggers. Say certain phrases and Claude activates the right skill or spawns an agent.

### Session Management

| Say This | What Happens |
|----------|--------------|
| "save state", "update ledger", "before clear" | Updates continuity ledger, preserves state for `/clear` |
| "done for today", "wrap up", "create handoff" | Creates detailed handoff doc for next session |
| "resume work", "continue from handoff", "pick up where" | Loads handoff, analyzes context, continues |

### Onboarding (New Projects)

| Say This | What Happens |
|----------|--------------|
| "onboard", "get familiar", "analyze this project" | Runs **/onboard** skill - analyzes codebase, creates initial ledger |
| "explore codebase", "understand the code", "what does this do" | Spawns **rp-explorer** for token-efficient exploration |

**The `/onboard` skill** is designed for brownfield projects (existing codebases). It:

1. **Checks prerequisites** - Verifies `thoughts/` structure exists (run `init-project.sh` first)
2. **Analyzes codebase** - Uses RepoPrompt if available, falls back to bash commands:
   - `rp-cli -e 'tree'` - Directory structure
   - `rp-cli -e 'builder "understand the codebase"'` - AI-powered file selection
   - `rp-cli -e 'structure .'` - Code signatures (token-efficient)
3. **Detects tech stack** - Language, framework, database, testing, CI/CD
4. **Asks your goal** - Feature work, bug fixes, refactoring, or learning
5. **Creates continuity ledger** - At `thoughts/ledgers/CONTINUITY_CLAUDE-<project>.md`

**Example workflow:**

```bash
# 1. Initialize project structure
~/.claude/scripts/init-project.sh

# 2. Start Claude and onboard
claude
> /onboard
```

### Planning & Implementation

| Say This | What Happens |
|----------|--------------|
| "create plan", "design", "architect", "greenfield" | Spawns **plan-agent** to create implementation plan |
| "validate plan", "before implementing", "ready to implement" | Spawns **validate-agent** (RAG-judge + WebSearch) |
| "implement plan", "execute plan", "run the plan" | Spawns **implement_plan** with agent orchestration |
| "verify implementation", "did it work", "check code" | Runs **validate_plan** to verify against plan |

**The 3-step flow:**

```
1. plan-agent     → Creates plan in thoughts/shared/plans/
2. validate-agent → RAG-judge (past precedent) + WebSearch (best practices)
3. implement_plan → Executes with task agents, creates handoffs
```

### Code Quality

| Say This | What Happens |
|----------|--------------|
| "implement", "add feature", "fix bug", "refactor" | **TDD workflow** activates - write failing test first |
| "lint", "code quality", "auto-fix", "check code" | Runs **qlty-check** (70+ linters, auto-fix) |
| "commit", "push", "save changes" | Runs **commit** skill (removes Claude attribution) |
| "describe pr", "create pr" | Generates PR description from changes |

### Codebase Exploration

| Say This | What Happens |
|----------|--------------|
| "brownfield", "existing codebase", "repoprompt" | Spawns **rp-explorer** - uses RepoPrompt for token-efficient exploration |
| "how does X work", "trace", "data flow", "deep dive" | Spawns **codebase-analyzer** for detailed analysis |
| "find files", "where are", "which files handle" | Spawns **codebase-locator** (super grep/glob) |
| "find examples", "similar pattern", "how do we do X" | Spawns **codebase-pattern-finder** |
| "explore", "get familiar", "overview" | Spawns **explore** agent with configurable depth |

**rp-explorer uses RepoPrompt tools** (requires Pro license - $14.99/mo or $349 lifetime):

- **Context Builder** - Deep AI-powered exploration (async, 30s-5min)
- **Codemaps** - Function/class signatures without full file content (10x fewer tokens)
- **Slices** - Read specific line ranges, not whole files
- **Search** - Pattern matching with context lines
- **Workspaces** - Switch between projects

*Free tier available with basic features (32k token limit, no MCP server)*

### Research

| Say This | What Happens |
|----------|--------------|
| "research", "investigate", "find out", "best practices" | Spawns **research-agent** (uses MCP tools) |
| "research repo", "analyze this repo", "clone and analyze" | Spawns **repo-research-analyst** |
| "docs", "documentation", "library docs", "API reference" | Runs **nia-docs** for library documentation |
| "web search", "look up", "latest", "current info" | Runs **perplexity-search** for web research |

### Debugging

| Say This | What Happens |
|----------|--------------|
| "debug", "investigate issue", "why is it broken" | Spawns **debug-agent** (logs, code search, git history) |
| "not working", "error", "failing", "what's wrong" | Same - triggers debug-agent |

### Code Search

| Say This | What Happens |
|----------|--------------|
| "search code", "grep", "find in code", "find text" | Runs **morph-search** (20x faster than grep) |
| "ast", "find all calls", "refactor", "codemod" | Runs **ast-grep-find** (structural search) |
| "search github", "find repo", "github issue" | Runs **github-search** |

### Learning & Insights

| Say This | What Happens |
|----------|--------------|
| "compound learnings", "turn learnings into rules" | Runs **compound-learnings** - transforms session learnings into skills/rules |
| "analyze session", "what happened", "session insights" | Runs **braintrust-analyze** to review traces |
| "recall", "what was tried", "past reasoning" | Searches **reasoning history** |

### Hook Development

| Say This | What Happens |
|----------|--------------|
| "create hook", "write hook", "hook for" | Loads **hook-developer** skill - complete reference for all 10 hook types |
| "hook schema", "hook input", "hook output" | Same - shows input/output schemas, matchers, testing patterns |
| "debug hook", "hook not working", "hook failing" | Runs **debug-hooks** skill - systematic debugging workflow |

**The `/hook-developer` skill** is a comprehensive reference covering:

- All 10 Claude Code hook types (PreToolUse, PostToolUse, SessionStart, etc.)
- Input/output JSON schemas for each hook
- Matcher patterns and registration in settings.json
- Shell wrapper → TypeScript handler pattern
- Testing commands for manual hook validation

### Other

| Say This | What Happens |
|----------|--------------|
| "scrape", "fetch url", "crawl" | Runs **firecrawl-scrape** |
| "create skill", "skill triggers", "skill system" | Runs **skill-developer** meta-skill |
| "codebase structure", "file tree", "signatures" | Runs **repoprompt** for code maps |

---

## Skills vs Agents

**Skills** run in current context. Quick, focused, minimal token overhead.

**Agents** spawn with fresh context. Use for complex tasks that would degrade in a compacted context. They return a summary and optionally create handoffs.

### When to Use Agents

- Brownfield exploration → `rp-explorer` first
- Multi-step research → `research-agent`
- Complex debugging → `debug-agent`
- Implementation with handoffs → `implement_plan`

### Agent Orchestration

For large implementations, `implement_plan` spawns task agents:

```
implement_plan (orchestrator)
    ├── task-agent (task 1) → handoff-01.md
    ├── task-agent (task 2) → handoff-02.md
    └── task-agent (task 3) → handoff-03.md
```

Each task agent:

1. Reads previous handoff
2. Does its work with TDD
3. Creates handoff for next agent
4. Returns summary to orchestrator

---

## MCP Code Execution

Tools are executed via scripts, not loaded into context. This saves tokens.

```bash
# Example: run a script
uv run python -m runtime.harness scripts/qlty_check.py --fix

# Available scripts
ls scripts/
```

### Adding MCP Servers

1. Edit `mcp_config.json` (or `.mcp.json`)
2. Add API keys to `.env`
3. Run `uv run mcp-generate`

```json
{
  "mcpServers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "my-mcp-server"],
      "env": { "API_KEY": "${MY_API_KEY}" }
    }
  }
}
```

### Developing Custom MCP Scripts

After running `install-global.sh`, you can create and run MCP scripts from any project:

```bash
# Global commands available everywhere
mcp-exec scripts/my_script.py      # Run a script
mcp-generate                        # Generate wrappers for configured servers
```

**Config Merging:** Global config (`~/.claude/mcp_config.json`) is merged with project config (`.mcp.json` or `mcp_config.json`). Project settings override global for same-named servers.

**Creating a new script:**

```python
# scripts/my_tool.py
"""
USAGE: uv run python -m runtime.harness scripts/my_tool.py --query "search term"
"""
import argparse
from runtime.mcp_client import call_mcp_tool

async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", required=True)
    args = parser.parse_args()

    # Tool format: serverName__toolName
    result = await call_mcp_tool("my-server__search", {"query": args.query})
    print(result)

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

**Creating a skill wrapper:**

```bash
mkdir -p .claude/skills/my-tool
cat > .claude/skills/my-tool/SKILL.md << 'EOF'
---
name: my-tool
description: Search with my tool
---
# My Tool

uv run python -m runtime.harness scripts/my_tool.py --query "your query"
EOF
```

**Adding skill triggers for auto-activation:**

```json
// .claude/skills/skill-rules.json
{
  "skills": {
    "my-tool": {
      "type": "domain",
      "enforcement": "suggest",
      "priority": "high",
      "description": "Search with my tool",
      "promptTriggers": {
        "keywords": ["my-tool", "search with tool"],
        "intentPatterns": ["(search|find).*?with.*?tool"]
      }
    }
  }
}
```

**Enforcement levels:**

- `suggest` - Skill appears as suggestion (most common)
- `block` - Requires skill before proceeding (guardrail)
- `warn` - Shows warning but allows proceeding

**Priority levels:** `critical` > `high` > `medium` > `low`

#### Agent Integration

Agents can reference your scripts for complex workflows. Example from `.claude/agents/research-agent.md`:

##### Step 3: Research with MCP Tools

###### For External Knowledge

```bash
# Documentation search (Nia)
uv run python -m runtime.harness scripts/nia_docs.py --query "your query"

# Web research (Perplexity)
uv run python -m runtime.harness scripts/perplexity_search.py --query "your query"
```

###### For Codebase Knowledge

```bash
# Fast code search (Morph)
uv run python -m runtime.harness scripts/morph_search.py --query "pattern" --path "."
```

Agents use MCP scripts to:

- Perform research across multiple sources
- Investigate issues with codebase search
- Apply fixes using fast editing tools
- Gather information for analysis

See `.claude/agents/research-agent.md` and `.claude/agents/debug-agent.md` for complete examples.

#### Full Pattern: MCP Server → Scripts → Skills → Agents

The complete integration flow:

```
1. MCP Server Configuration
   ↓ (mcp_config.json or .mcp.json)

2. Script Creation
   ↓ (scripts/my_tool.py with CLI args)

3. Skill Wrapper
   ↓ (.claude/skills/my-tool/SKILL.md)

4. Skill Triggers
   ↓ (.claude/skills/skill-rules.json)

5. Agent Integration (optional)
   ↓ (.claude/agents/my-agent.md references the script)

6. Auto-activation
   → User types trigger keyword → Skill suggests → Script executes
```

**Real-world example:** `morph-search`

1. **Server:** `morph` MCP server in `mcp_config.json`
2. **Script:** `scripts/morph_search.py` with `--query`, `--path` args
3. **Skill:** `.claude/skills/morph-search/SKILL.md` documents usage
4. **Triggers:** `.claude/skills/skill-rules.json` activates on "search code", "fast search"
5. **Agents:** `research-agent.md` and `debug-agent.md` use for codebase search
6. **Activation:** User says "search code for error handling" → auto-suggests

**Key benefits:**

- **Progressive disclosure:** 110 tokens (99.6% reduction) vs full tool schemas
- **Reusability:** Scripts work for agents, skills, and direct execution
- **Auto-discovery:** skill-rules.json enables context-aware suggestions
- **Flexibility:** Change parameters via CLI, no code edits needed

---

## Continuity System

### Ledger (within session)

Before running `/clear`:

```
"Update the ledger, I'm about to clear"
```

Creates/updates `CONTINUITY_CLAUDE-<session>.md` with:

- Goal and constraints
- What's done, what's next
- Key decisions
- Working files

After `/clear`, the ledger loads automatically.

### Handoff (between sessions)

When done for the day:

```
"Create a handoff, I'm done for today"
```

Creates `thoughts/handoffs/<session>/handoff-<timestamp>.md` with:

- Detailed context
- Recent changes with file:line references
- Learnings and patterns
- Next steps

Next session:

```
"Resume from handoff"
```

---

## Hooks System

Hooks are the backbone of continuity. They intercept Claude Code lifecycle events and automate state preservation.

### StatusLine (Context Indicator)

The colored status bar shows context usage in real-time:

```
45.2K 23% | main U:3 | ✓ Fixed auth → Add tests
 ↑     ↑      ↑   ↑        ↑           ↑
 │     │      │   │        │           └── Current focus (from ledger)
 │     │      │   │        └── Last completed item
 │     │      │   └── Uncommitted changes (Staged/Unstaged/Added)
 │     │      └── Git branch
 │     └── Context percentage used
 └── Token count
```

**Color coding:**

| Color | Range | Meaning |
>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)
|-------|-------|---------|
| `bug` | debug → implement → test → commit | General bug fix |
| `hook` | debug-hooks → hook-developer → implement → test | Hook issues |
| `deps` | preflight → oracle → plan → implement → qlty | Dependency errors |
| `pr-comments` | github-search → research → plan → implement → commit | PR feedback |

| Option | Effect |
|--------|--------|
| `--no-test` | Skip regression test |
| `--dry-run` | Diagnose only, don't fix |
| `--no-commit` | Don't auto-commit |

**`/explore <depth> [options]`**

| Depth | Time | What It Does |
|-------|------|--------------|
| `quick` | ~1 min | tldr tree + structure overview |
| `deep` | ~5 min | onboard + tldr + research + documentation |
| `architecture` | ~3 min | tldr arch + call graph + layers |

| Option | Effect |
|--------|--------|
| `--focus "area"` | Focus on specific area (e.g., `--focus "auth"`) |
| `--output handoff` | Create handoff for implementation |
| `--output doc` | Create documentation file |
| `--entry "func"` | Start from specific entry point |

**`/tdd`, `/refactor`, `/review`, `/security`, `/release`**

<<<<<<< HEAD
These follow their defined chains without mode flags. Just run
=======

**What it does:**

1. Finds most recent `CONTINUITY_CLAUDE-*.md` ledger
2. Extracts Goal and current focus ("Now:")
3. Finds latest handoff (task-*.md or auto-handoff-*.md)
4. Injects ledger + handoff into system context

**Result:** After `/clear`, Claude immediately knows:

- What you're working on
- What's done vs pending
- Recent decisions and learnings

### PreCompact Hook

Runs: Before any compaction

**Auto-compact (trigger: auto):**

1. Parses transcript to extract tool calls and responses
2. Generates detailed `auto-handoff-<timestamp>.md` with:
   - Files modified
   - Recent tool outputs
   - Current work state
3. Saves to `thoughts/handoffs/<session>/`

**Manual compact (trigger: manual):**

- Blocks compaction
- Prompts you to run `/continuity_ledger` first

### UserPromptSubmit Hook

Runs: Every message you send

**Two functions:**

1. **Skill activation** - Scans your message for keywords defined in `skill-rules.json`. Shows relevant skills:

   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   🎯 SKILL ACTIVATION CHECK
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   ⚠️ CRITICAL SKILLS (REQUIRED):
     → create_handoff

   📚 RECOMMENDED SKILLS:
     → commit
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

2. **Context warnings** - Reads context % and shows tiered warnings:
   - 70%: `Consider handoff when you reach a stopping point.`
   - 80%: `Recommend: /create_handoff then /clear soon`
   - 90%: `CONTEXT CRITICAL: Run /create_handoff NOW!`

### TypeScript Preflight Hook (PreToolUse)

Runs: Before Edit/Write on `.ts` or `.tsx` files

**What it does:**

1. Runs `tsc --noEmit` on the file being edited
2. If type errors exist, blocks the edit and shows errors to Claude
3. Claude fixes the issues before proceeding

**Why this matters:** Catches type errors early, before they compound across multiple edits. Claude sees the errors in context and can fix them immediately.

**Example output when blocked:**

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

```
/tdd "implement retry logic"
/refactor "extract auth module"
/review                           # reviews current changes
/security "authentication code"
/release v1.2.0
```

#### Key Skills (High-Value Tools)

**Planning & Risk**

- **premortem**: TIGERS & ELEPHANTS risk analysis - use before any significant implementation
- **discovery-interview**: Transform vague ideas into detailed specs

**Context Management**

- **create_handoff**: Capture session state for transfer
- **resume_handoff**: Resume from handoff with context
- **continuity_ledger**: Track state within session

**Code Analysis (95% Token Savings)**

- **tldr-code**: Call graph, CFG, DFG, slicing
- **ast-grep-find**: Structural code search
- **morph-search**: Fast text search (20x faster than grep)

**Research**

- **perplexity-search**: AI-powered web search
- **nia-docs**: Library documentation search
- **github-search**: Search GitHub code/issues/PRs

**Quality**

- **qlty-check**: 70+ linters, auto-fix
- **braintrust-analyze**: Session analysis, replay, and debugging failed sessions

**Math & Formal Proofs**

- **math**: Unified computation (SymPy, Z3, Pint) — one entry point for all math
- **prove**: Lean4 theorem proving with 5-phase workflow (Research → Design → Test → Implement → Verify)
- **pint-compute**: Unit-aware arithmetic and conversions
- **shapely-compute**: Computational geometry

The `/prove` skill enables machine-verified proofs without learning Lean syntax. Used to create the first Lean formalization of Sylvester-Gallai theorem.

#### The Thought Process

```
What do I want to do?
├── Don't know → /workflow (guided router)
├── Building → /build greenfield or brownfield
├── Fixing → /fix bug
├── Understanding → /explore
├── Planning → premortem first, then plan-agent
├── Researching → oracle or perplexity-search
├── Reviewing → /review
├── Proving → /prove (Lean4 formal verification)
├── Computing → /math (SymPy, Z3, Pint)
└── Shipping → /release
```

[See detailed skills breakdown →](docs/skills/)

---

### Agents System

**For developers** who want to modify hooks:

```bash
cd .claude/hooks
vim src/session-start-continuity.ts  # Edit source
./build.sh                            # Rebuild dist/
```

**Note on latency:** Some hooks (especially `SessionEnd` and `Stop`) may add 1-3 seconds of latency as they finalize traces and extract learnings. This is expected - the hooks run fire-and-forget processes that don't block the next session.

Hooks receive JSON input and return JSON output:

```typescript
// Input varies by event type
interface SessionStartInput {
  source: 'startup' | 'resume' | 'clear' | 'compact';
  session_id: string;
}

// Output controls behavior (varies by hook type)
interface HookOutput {
  continue?: boolean;             // true to proceed (default)
  decision?: 'block';             // Block stops the action (PreToolUse only)
  reason?: string;                // Shown when blocking
  hookSpecificOutput?: {          // Injected into context
    additionalContext: string;
  };
}
```

### Registering Hooks

Hooks are configured in `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "$CLAUDE_PROJECT_DIR/.claude/scripts/status.sh"
  },
  "hooks": {
    "SessionStart": [{
      "matcher": "clear",
      "hooks": [{
        "type": "command",
        "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start-continuity.sh"
      }]
    }]
  }
}
```

**Matcher patterns:** Use `|` for multiple triggers: `"Edit|Write|Bash"`

---

## Notifications

Get notified when Claude completes tasks or needs your attention. Two isolated notification channels:

### Windows Toast (WSL)

Desktop notifications via BurntToast PowerShell module.

**Requires:**

- WSL environment with `powershell.exe` accessible
- BurntToast module: `powershell.exe -Command "Install-Module -Name BurntToast -Force"`

**Location:** `~/.claude/hooks/show-toast.sh`

**Features:**

- Custom Claude icon (`~/.claude/cctoast-wsl/assets/claude.png`)
- Path caching for performance
- Automatic WSL → Windows path conversion

### Telegram Bot

Remote notifications via Telegram Bot API. Get notifications on your phone/desktop Telegram client.

**Setup:**

1. Create bot via [@BotFather](https://t.me/botfather) → get `TELEGRAM_BOT_TOKEN`
2. Get your chat ID via [@userinfobot](https://t.me/userinfobot) → get `TELEGRAM_CHAT_ID`
3. Add to `~/.claude/.env`:

```bash
TELEGRAM_ENABLED=true
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

**Location:** `.claude/hooks/send-telegram.sh`

### Hook Events

Both notifications trigger on:

| Event | Message |
|-------|---------|
| **Notification** | "Waiting for your response" |
| **Stop** | "Task completed" |

### Manual Usage

```bash
# Windows Toast
~/.claude/hooks/show-toast.sh --title "Test" --message "Hello"

# Telegram
.claude/hooks/send-telegram.sh --title "Test" --message "Hello"

# Debug mode
TELEGRAM_DEBUG=1 .claude/hooks/send-telegram.sh --stop-hook
CCTOAST_DEBUG=1 ~/.claude/hooks/show-toast.sh --notification-hook
```

### Architecture

```
Hook Event (Notification/Stop)
    ├── show-toast.sh      → Windows Desktop (BurntToast/PowerShell)
    └── send-telegram.sh   → Telegram Bot API (curl)
```

Both channels are isolated - disabling one doesn't affect the other. Errors are logged silently to avoid disrupting Claude.

---

## Reasoning History

Agents are specialized AI workers spawned via the Task tool. Located in `.claude/agents/`.

#### Agent Categories (32 active)

> **Note:** There are likely too many agents—consolidation is a v4 goal. Use what fits your workflow.

**Orchestrators (2)**

- **maestro**: Multi-agent coordination with patterns (Pipeline, Swarm, Jury)
- **kraken**: TDD implementation agent with checkpoint/resume support

**Planners (4)**

- **architect**: Feature planning + API integration
- **phoenix**: Refactoring + framework migration planning
- **plan-agent**: Lightweight planning with research/MCP tools
- **validate-agent**: Validate plans against best practices

<<<<<<< HEAD
**Explorers (4)**

- **scout**: Codebase exploration (use instead of Explore)
- **oracle**: External research (web, docs, APIs)
- **pathfinder**: External repository analysis
- **research-codebase**: Document codebase as-is
=======
**Example:**

```
"recall what was tried for authentication bugs"
→ Searches .git/claude/commits/*/reasoning.md
→ Returns: "In commit abc123, tried X but failed because Y, fixed with Z"
```

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

**Implementers (3)**

- **kraken**: TDD implementation with strict test-first workflow
- **spark**: Lightweight fixes and quick tweaks
- **agentica-agent**: Build Python agents using Agentica SDK

**Debuggers (3)**

- **sleuth**: General bug investigation and root cause
- **debug-agent**: Issue investigation via logs/code search
- **profiler**: Performance profiling and race conditions

**Validators (2)** - arbiter, atlas

**Reviewers (6)** - critic, judge, surveyor, liaison, plan-reviewer, review-agent

**Specialized (8)** - aegis, herald, scribe, chronicler, session-analyst, braintrust-analyst, memory-extractor, onboard

#### Common Workflows

| Workflow | Agent Chain |
|----------|-------------|
| Feature | architect → plan-reviewer → kraken → review-agent → arbiter |
| Refactoring | phoenix → plan-reviewer → kraken → judge → arbiter |
| Bug Fix | sleuth → spark/kraken → arbiter → scribe |

[See detailed agent guide →](docs/agents/)

---

### Hooks System

Hooks intercept Claude Code at lifecycle points. Located in `.claude/hooks/`.

#### Hook Events (30 hooks total)

| Event | Key Hooks | Purpose |
|-------|-----------|---------|
| **SessionStart** | session-start-continuity, session-register, braintrust-tracing | Load context, register session |
| **PreToolUse** | tldr-read-enforcer, smart-search-router, tldr-context-inject, file-claims | Token savings, search routing |
| **PostToolUse** | post-edit-diagnostics, handoff-index, post-edit-notify | Validation, indexing |
| **PreCompact** | pre-compact-continuity | Auto-save before compaction |
| **UserPromptSubmit** | skill-activation-prompt, memory-awareness | Skill hints, memory recall |
| **SubagentStop** | subagent-stop-continuity | Save agent state |
| **SessionEnd** | session-end-cleanup, session-outcome | Cleanup, extract learnings |

#### Key Hooks

| Hook | Purpose |
|------|---------|
| **tldr-context-inject** | Adds code analysis to agent prompts |
| **smart-search-router** | Routes grep to AST-grep when appropriate |
| **post-edit-diagnostics** | Runs pyright/ruff after edits |
| **memory-awareness** | Surfaces relevant learnings |

[See all 30 hooks →](docs/hooks/)

---

### TLDR Code Analysis

TLDR provides token-efficient code summaries through 5 analysis layers.

<<<<<<< HEAD

#### The 5-Layer Stack

=======
2. **Add to environment:**

   ```bash
   echo 'BRAINTRUST_API_KEY="sk-..."' >> ~/.claude/.env
   ```

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

| Layer | Name | What it provides | Tokens |
|-------|------|------------------|--------|
| **L1** | AST | Functions, classes, signatures | ~500 tokens |
| **L2** | Call Graph | Who calls what (cross-file) | +440 tokens |
| **L3** | CFG | Control flow, complexity | +110 tokens |
| **L4** | DFG | Data flow, variable tracking | +130 tokens |
| **L5** | PDG | Program slicing, impact analysis | +150 tokens |

**Total: ~1,200 tokens vs 23,000 raw = 95% savings**

#### CLI Commands

```bash
# Structure analysis
tldr tree src/                      # File tree
tldr structure src/ --lang python   # Code structure (codemaps)

# Search and extraction
tldr search "process_data" src/     # Find code
tldr context process_data --project src/ --depth 2  # LLM-ready context

# Flow analysis
tldr cfg src/main.py main           # Control flow graph
tldr dfg src/main.py main           # Data flow graph
tldr slice src/main.py main 42      # What affects line 42?

# Codebase analysis
tldr impact process_data src/       # Who calls this function?
tldr dead src/                      # Find unreachable code
tldr arch src/                      # Detect architectural layers

# Semantic search (natural language)
tldr daemon semantic "find authentication logic"
```

#### Semantic Index

Beyond structural analysis, TLDR builds a **semantic index** of your codebase:

- **Natural language queries** — Ask "where is error handling?" instead of grepping
- **Auto-rebuild** — Dirty flag hook tracks file changes; index rebuilds after N edits
- **Selective indexing** — Use `.tldrignore` to control what gets indexed

```bash
# .tldrignore example
__pycache__/
*.test.py
node_modules/
.venv/
```

The semantic index uses all 5 layers plus 10 lines of surrounding code context—not just docstrings.

#### Hook Integration

TLDR is automatically integrated via hooks:

- **tldr-read-enforcer**: Returns L1+L2+L3 instead of full file reads
- **smart-search-router**: Routes Grep to `tldr search`
- **post-tool-use-tracker**: Updates indexes when files change

[See TLDR documentation →](opc/packages/tldr-code/)

---

### Memory System

Cross-session learning powered by PostgreSQL + pgvector.

#### How It Works

```
Session ends → Database detects stale heartbeat (>5 min)
            → Daemon spawns headless Claude (Sonnet)
            → Analyzes thinking blocks from session
            → Extracts learnings to archival_memory
            → Next session recalls relevant learnings
```

The key insight: **thinking blocks contain the real reasoning**—not just what Claude did, but why. The daemon extracts this automatically.

#### Conversational Interface

| What You Say | What Happens |
|--------------|--------------|
| "Remember that auth uses JWT" | Stores learning with context |
| "Recall authentication patterns" | Searches memory, surfaces matches |
| "What did we decide about X?" | Implicit recall via memory-awareness hook |

#### Database Schema (4 tables)

| Table | Purpose |
|-------|---------|
| **sessions** | Cross-terminal awareness |
| **file_claims** | Cross-terminal file locking |
| **archival_memory** | Long-term learnings with BGE embeddings |
| **handoffs** | Session handoffs with embeddings |

#### Recall Commands

```bash
# Recall learnings (hybrid text + vector search)
cd opc && uv run python scripts/core/recall_learnings.py \
    --query "authentication patterns"

# Store a learning explicitly
cd opc && uv run python scripts/core/store_learning.py \
    --session-id "my-session" \
    --type WORKING_SOLUTION \
    --content "What I learned" \
    --confidence high
```

#### Automatic Memory

The **memory-awareness** hook surfaces relevant learnings when you send a message. You'll see `MEMORY MATCH` indicators—Claude can use these without you asking.

---

### Continuity System

Preserve state across context clears and sessions.

#### Continuity Ledger

Within-session state tracking. Location: `thoughts/ledgers/CONTINUITY_<topic>.md`

```markdown
# Session: feature-x
Updated: 2026-01-08

## Goal
Implement feature X with proper error handling

## Completed
- [x] Designed API schema
- [x] Implemented core logic

## In Progress
- [ ] Add error handling

## Blockers
- Need clarification on retry policy
```

#### Handoffs

Between-session knowledge transfer. Location: `thoughts/shared/handoffs/<session>/`

```yaml
---
date: 2026-01-08T15:26:01+0000
session_name: feature-x
status: complete
---

# Handoff: Feature X Implementation

## Task(s)
| Task | Status |
|------|--------|
| Design API | Completed |
| Implement core | Completed |
| Error handling | Pending |

## Next Steps
1. Add retry logic to API calls
2. Write integration tests
```

<<<<<<< HEAD

#### Commands

=======
This enables:

- **Trace → Handoff** correlation (what work produced this handoff?)
- **Session family queries** (all handoffs from session X)
- **RAG-enhanced judging** (Artifact Index precedent for plan validation)

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

| Command | Effect |
|---------|--------|
| "save state" | Updates continuity ledger |
| "done for today" / `/handoff` | Creates handoff document |
| "resume work" | Loads latest handoff |

---

### Math System

Two capabilities: **computation** (SymPy, Z3, Pint) and **formal verification** (Lean4 + Mathlib).

#### The Stack

| Tool | Purpose | Example |
|------|---------|---------|
| **SymPy** | Symbolic math | Solve equations, integrals, matrix operations |
| **Z3** | Constraint solving | Prove inequalities, SAT problems |
| **Pint** | Unit conversion | Convert miles to km, dimensional analysis |
| **Lean4** | Formal proofs | Machine-verified theorems |
| **Mathlib** | 100K+ theorems | Pre-formalized lemmas to build on |
| **Loogle** | Type-aware search | Find Mathlib lemmas by signature |

#### Two Entry Points

| Skill | Use When |
|-------|----------|
| `/math` | Computing, solving, calculating |
| `/prove` | Formal verification, machine-checked proofs |

#### /math Examples

```bash
# Solve equation
"Solve x² - 4 = 0"  →  x = ±2

# Compute eigenvalues
"Eigenvalues of [[2,1],[1,2]]"  →  {1: 1, 3: 1}

# Prove inequality
"Is x² + y² ≥ 2xy always true?"  →  PROVED (equals (x-y)²)

# Convert units
"26.2 miles to km"  →  42.16 km
```

#### /prove - Formal Verification

5-phase workflow for machine-verified proofs:

```
📚 RESEARCH → 🏗️ DESIGN → 🧪 TEST → ⚙️ IMPLEMENT → ✅ VERIFY
```

1. **Research**: Search Mathlib with Loogle, find proof strategy
2. **Design**: Create skeleton with `sorry` placeholders
3. **Test**: Search for counterexamples before proving
4. **Implement**: Fill sorries with compiler-in-the-loop feedback
5. **Verify**: Audit axioms, confirm zero sorries

```
/prove every group homomorphism preserves identity
/prove continuous functions on compact sets are uniformly continuous
```

**Achievement**: Used to create the first Lean formalization of the Sylvester-Gallai theorem.

#### Prerequisites (Optional)

Math features require installation via wizard step 9:

```bash
# Installed automatically by wizard
uv pip install sympy z3-solver pint shapely

# Lean4 (for /prove)
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
```

---

## Workflows

### /workflow - Goal-Based Router

```
> /workflow

? What's your goal?
  ○ Research - Understand codebase/docs
  ○ Plan - Design implementation approach
  ○ Build - Implement features
  ○ Fix - Investigate and resolve issues
```

### /fix - Bug Resolution

```bash
/fix bug "login fails silently"
```

**Chain:** sleuth → [checkpoint] → [premortem] → kraken → test → commit

| Scope | What it does |
|-------|--------------|
| `bug` | General bug investigation |
| `hook` | Hook-specific debugging |
| `deps` | Dependency issues |
| `pr-comments` | Address PR feedback |

### /build - Feature Development

```bash
/build greenfield "user dashboard"
```

**Chain:** discovery → plan → validate → implement → commit → PR

| Mode | What it does |
|------|--------------|
| `greenfield` | New feature from scratch |
| `brownfield` | Modify existing codebase |
| `tdd` | Test-first development |
| `refactor` | Safe code transformation |

### /premortem - Risk Analysis

```bash
/premortem deep thoughts/shared/plans/feature-x.md
```

**Output:**

- **TIGERS**: Clear threats (HIGH/MEDIUM/LOW severity)
- **ELEPHANTS**: Unspoken concerns

Blocks on HIGH severity until user accepts/mitigates risks.

---

## Installation

### Full Installation (Recommended)

```bash
# Clone
git clone https://github.com/parcadei/continuous-claude.git
cd continuous-claude/opc

# Run the setup wizard
uv run python -m scripts.setup.wizard
```

The wizard walks you through all configuration options interactively.

## Updating

Pull latest changes and sync your installation:

```bash
cd continuous-claude/opc
uv run python -m scripts.setup.update
```

This will:

- Pull latest from GitHub
- Update hooks, skills, rules, agents
- Upgrade TLDR if installed
- Rebuild TypeScript hooks if changed

### What Gets Installed

| Component | Location |
|-----------|----------|
| Agents (32) | ~/.claude/agents/ |
| Skills (109) | ~/.claude/skills/ |
| Hooks (30) | ~/.claude/hooks/ |
| Rules | ~/.claude/rules/ |
| Scripts | ~/.claude/scripts/ |
| PostgreSQL | Docker container |

### Installation Mode: Copy vs Symlink

The wizard offers two installation modes:

| Mode | How It Works | Best For |
|------|--------------|----------|
| **Copy** (default) | Copies files from repo to `~/.claude/` | End users, stable setup |
| **Symlink** | Creates symlinks to repo files | Contributors, development |

#### Copy Mode (Default)

Files are copied from `continuous-claude/.claude/` to `~/.claude/`. Changes you make in `~/.claude/` are **local only** and will be overwritten on next update.

```text
continuous-claude/.claude/  ──COPY──>  ~/.claude/
     (source)                          (user config)
```

**Pros:** Stable, isolated from repo changes
**Cons:** Local changes lost on update, manual sync needed

#### Symlink Mode (Recommended for Contributors)

Creates symlinks so `~/.claude/` points directly to repo files. Changes in either location affect the same files.

```text
~/.claude/rules  ──SYMLINK──>  continuous-claude/.claude/rules
~/.claude/skills ──SYMLINK──>  continuous-claude/.claude/skills
~/.claude/hooks  ──SYMLINK──>  continuous-claude/.claude/hooks
~/.claude/agents ──SYMLINK──>  continuous-claude/.claude/agents
```

**Pros:**

- Changes auto-sync to repo (can `git commit` improvements)
- No re-installation needed after `git pull`
- Contribute back easily

**Cons:**

- Breaking changes in repo affect your setup immediately
- Need to manage git workflow

#### Switching to Symlink Mode

If you installed with copy mode and want to switch:

```bash
# Backup current config
mkdir -p ~/.claude/backups/$(date +%Y%m%d)
cp -r ~/.claude/{rules,skills,hooks,agents} ~/.claude/backups/$(date +%Y%m%d)/

# Verify backup succeeded before proceeding
ls -la ~/.claude/backups/$(date +%Y%m%d)/

# Remove copies (only after verifying backup above)
rm -rf ~/.claude/{rules,skills,hooks,agents}

# Create symlinks (adjust path to your repo location)
REPO="$HOME/continuous-claude"  # or wherever you cloned
ln -s "$REPO/.claude/rules" ~/.claude/rules
ln -s "$REPO/.claude/skills" ~/.claude/skills
ln -s "$REPO/.claude/hooks" ~/.claude/hooks
ln -s "$REPO/.claude/agents" ~/.claude/agents

# Verify
ls -la ~/.claude | grep -E "rules|skills|hooks|agents"
```

**Windows users:** Use PowerShell (as Administrator or with Developer Mode enabled):

```powershell
# Enable Developer Mode first (Settings → Privacy & security → For developers)
# Or run PowerShell as Administrator

# Backup current config
$BackupDir = "$HOME\.claude\backups\$(Get-Date -Format 'yyyyMMdd')"
New-Item -ItemType Directory -Path $BackupDir -Force
Copy-Item -Recurse "$HOME\.claude\rules","$HOME\.claude\skills","$HOME\.claude\hooks","$HOME\.claude\agents" $BackupDir

# Verify backup succeeded before proceeding
Get-ChildItem $BackupDir

# Remove copies (only after verifying backup above)
Remove-Item -Recurse "$HOME\.claude\rules","$HOME\.claude\skills","$HOME\.claude\hooks","$HOME\.claude\agents"

# Create symlinks (adjust path to your repo location)
$REPO = "$HOME\continuous-claude"  # or wherever you cloned
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\rules" -Target "$REPO\.claude\rules"
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\skills" -Target "$REPO\.claude\skills"
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\hooks" -Target "$REPO\.claude\hooks"
New-Item -ItemType SymbolicLink -Path "$HOME\.claude\agents" -Target "$REPO\.claude\agents"

# Verify
Get-ChildItem "$HOME\.claude" | Where-Object { $_.LinkType -eq "SymbolicLink" }
```

### For Brownfield Projects

After installation, start Claude and run:

```
> /onboard
```

This analyzes the codebase and creates an initial continuity ledger.

---

## Configuration

### .claude/settings.json

Central configuration for hooks, tools, and workflows.

<<<<<<< HEAD
=======

Remove or comment out the Braintrust hooks in `.claude/settings.json`:

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

```json
{
  "hooks": {
    "SessionStart": [...],
    "PreToolUse": [...],
    "PostToolUse": [...],
    "UserPromptSubmit": [...]
  }
}
```

### .claude/skills/skill-rules.json

Skill activation triggers.

```json
{
  "rules": [
    {
      "skill": "fix",
      "keywords": ["fix this", "broken", "not working"],
      "intentPatterns": ["fix.*(bug|issue|error)"]
    }
  ]
}
```

### Environment Variables

| Variable | Purpose | Required |
|----------|---------|----------|
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `BRAINTRUST_API_KEY` | Session tracing | No |
| `PERPLEXITY_API_KEY` | Web search | No |
| `NIA_API_KEY` | Documentation search | No |
| `CLAUDE_OPC_DIR` | Path to CC's opc/ directory (set by wizard) | Auto |
| `CLAUDE_PROJECT_DIR` | Current project directory (set by SessionStart hook) | Auto |

<<<<<<< HEAD
Services without API keys still work:

- Continuity system (ledgers, handoffs)
- TLDR code analysis
- Local git operations
- TDD workflow
=======

## Artifact Index

A local SQLite database that indexes handoffs and plans for fast search.

### What It Does

- **Indexes handoffs** with full-text search (FTS5)
- **Tracks session outcomes** (SUCCEEDED, PARTIAL, FAILED)
- **Links to Braintrust traces** for correlation
- **Surfaces unmarked handoffs** at session start

### How It Works

```
1. Create handoff → PostToolUse hook indexes it immediately
2. Session ends → Prompts you to mark outcome
3. Next session → SessionStart surfaces unmarked handoffs
4. Mark outcomes → Improves future session recommendations
```

### Marking Outcomes

After completing work, mark the outcome:

```bash
# List unmarked handoffs
uv run python scripts/artifact_query.py --unmarked

# Mark an outcome
uv run python scripts/artifact_mark.py \
  --handoff abc123 \
  --outcome SUCCEEDED
```

**Outcomes:** SUCCEEDED | PARTIAL_PLUS | PARTIAL_MINUS | FAILED

### Querying the Index

```bash
# Search handoffs by content
uv run python scripts/artifact_query.py --search "authentication bug"

# Get session history
uv run python scripts/artifact_query.py --session open-source-release
```

---

## TDD Workflow

When you say "implement", "add feature", or "fix bug", TDD activates:

```
1. RED    - Write failing test first
2. GREEN  - Minimal code to pass
3. REFACTOR - Clean up, tests stay green
```

**The rule:** No production code without a failing test.

If you write code first, the skill prompts you to delete it and start with a test.

---

## Code Quality (qlty)

**Automatically installed** by `install-global.sh`. The `.qlty/` config is included in this repo, so no `qlty init` needed.

Manual install (if needed):

```bash
curl -fsSL https://qlty.sh/install.sh | bash
```

Use it:

```
"lint my code"
"check code quality"
"auto-fix issues"
```

Or directly:

```bash
qlty check --fix
qlty fmt
qlty metrics
```

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

---

## Directory Structure

```
continuous-claude/
├── .claude/
│   ├── agents/           # 32 specialized AI agents
│   ├── hooks/            # 30 lifecycle hooks
│   │   ├── src/          # TypeScript source
│   │   └── dist/         # Compiled JavaScript
│   ├── skills/           # 109 modular capabilities
│   ├── rules/            # System policies
│   ├── scripts/          # Python utilities
│   └── settings.json     # Hook configuration
├── opc/
│   ├── packages/
│   │   └── tldr-code/    # 5-layer code analysis
│   ├── scripts/
│   │   ├── setup/        # Wizard, Docker, integration
│   │   └── core/         # recall_learnings, store_learning
│   └── docker/
│       └── init-schema.sql  # 4-table PostgreSQL schema
├── thoughts/
│   ├── ledgers/          # Continuity ledgers (CONTINUITY_*.md)
│   └── shared/
│       ├── handoffs/     # Session handoffs (*.yaml)
│       └── plans/        # Implementation plans
└── docs/                 # Documentation
```

---

## Contributing

<<<<<<< HEAD
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:

- Adding new skills
- Creating agents
- Developing hooks
- Extending TLDR
=======
Add to `~/.claude/.env`:

```bash
# Session tracing (optional)
BRAINTRUST_API_KEY="sk-..."

# MCP services (optional)
GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."
PERPLEXITY_API_KEY="pplx-..."
FIRECRAWL_API_KEY="fc-..."
MORPH_API_KEY="sk-..."
NIA_API_KEY="nk_..."

# Telegram notifications (optional)
TELEGRAM_ENABLED=true
TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"
```

Services without API keys still work:

- `git` - local git operations
- `ast-grep` - structural code search
- `qlty` - code quality (auto-installed by `install-global.sh`)

License-based (no API key, requires purchase):

- `repoprompt` - codebase maps (Free tier: basic features; Pro: MCP tools, CodeMaps)

---

## Glossary

| Term | Definition |
|------|------------|
| Session | A single Claude Code conversation (from start to /clear or exit) |
| Ledger | In-session state file (`CONTINUITY_CLAUDE-*.md`) that survives /clear |
| Handoff | End-of-session document for transferring work to a new session |
| Outcome | Session result marker: SUCCEEDED, PARTIAL_PLUS, PARTIAL_MINUS, FAILED |
| Span | Braintrust trace unit - a turn or tool call within a session |
| Artifact Index | SQLite database indexing handoffs, plans, and ledgers for RAG queries |

---

## Troubleshooting

**"MCP server not configured"**

- Check `mcp_config.json` exists
- Run `uv run mcp-generate`
- Verify `.env` has required keys

**Skills not working**

- Run via harness: `uv run python -m runtime.harness scripts/...`
- Not directly: `python scripts/...`

**Ledger not loading**

- Check `CONTINUITY_CLAUDE-*.md` exists
- Verify hooks are registered in `.claude/settings.json`
- Make hooks executable: `chmod +x .claude/hooks/*.sh`

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

---

## Acknowledgments

### Patterns & Architecture

- **[@numman-ali](https://github.com/numman-ali)** - Continuity ledger pattern
- **[Anthropic](https://anthropic.com)** - Claude Code and "Code Execution with MCP"
- **[obra/superpowers](https://github.com/obra/superpowers)** - Agent orchestration patterns
- **[EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin)** - Compound engineering workflow
- **[yoloshii/mcp-code-execution-enhanced](https://github.com/yoloshii/mcp-code-execution-enhanced)** - Enhanced MCP execution
- **[HumanLayer](https://github.com/humanlayer/humanlayer)** - Agent patterns

### Tools & Services

<<<<<<< HEAD

- **[uv](https://github.com/astral-sh/uv)** - Python packaging
- **[tree-sitter](https://tree-sitter.github.io/)** - Code parsing
=======

>>>>>>> fcfe8ae (Fork customizations: global install, Telegram, Toast, Russian keywords)

- **[Braintrust](https://braintrust.dev)** - LLM evaluation, logging, and session tracing
- **[qlty](https://github.com/qltysh/qlty)** - Universal code quality CLI (70+ linters)
- **[ast-grep](https://github.com/ast-grep/ast-grep)** - AST-based code search and refactoring
- **[Nia](https://trynia.ai)** - Library documentation search
- **[Morph](https://www.morphllm.com)** - WarpGrep fast code search
- **[Firecrawl](https://www.firecrawl.dev)** - Web scraping API
- **[RepoPrompt](https://repoprompt.com)** - Token-efficient codebase maps

---

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=parcadei/Continuous-Claude-v2&type=timeline)](https://star-history.com/#parcadei/Continuous-Claude-v2&Date)

---

## License

[MIT](LICENSE) - Use freely, contribute back.

---

**Continuous Claude**: Not just a coding assistant—a persistent, learning, multi-agent development environment that gets smarter with every session.
