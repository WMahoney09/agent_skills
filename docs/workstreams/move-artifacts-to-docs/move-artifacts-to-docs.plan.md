# Move Artifacts from .claude/work/ to docs/workstreams/

## Overview
Migrate all artifact storage from `.claude/work/<slug>/` to `docs/workstreams/<slug>/` across the entire skills library. This is a holistic, mechanical change: update every reference in specs, skill definitions, artifact definitions, project instructions, and memory — then migrate existing workstream directories in this repo.

## Notes
- **Out of scope:** Seeding `docs/reference/` with content; that's future work. We establish the convention only.
- **Tool-agnostic examples** in `tire-kicking/SKILL.md` mention `.cursor/work/` and `.windsurf/work/` — these become `docs/workstreams/` too, since the whole point is tool-agnostic placement.
- **No `.claude/work/` allowlist needed** in `.gitignore` after this change — the entire `.claude/` directory can be ignored cleanly.
- **Historical artifacts** inside `.claude/work/` reference the old path internally — we migrate the files but do NOT rewrite internal references in historical artifacts (they're records of past work).
- **`artifactor.md`** is referenced in MEMORY.md but doesn't exist as a skill directory — it's a memory-only reference. We update MEMORY.md to reflect the new convention.

## Progress
- [x] Phase 1: Update canonical specs
- [x] Phase 2: Update all per-skill ARTIFACT.md files
- [x] Phase 3: Update all SKILL.md files
- [x] Phase 4: Update project instructions and memory
- [x] Phase 5: Migrate existing workstreams and clean up

---

## Phase 1: Update canonical specs

### Step 1.1: Update ARTIFACT.spec.md
#### Task 1.1.1: Replace all `.claude/work/<work-item>/` references with `docs/workstreams/<work-item>/`
#### Task 1.1.2: Update the Storage Convention section prose to explain the new location and rationale
#### Task 1.1.3: Update the slug explanation — slug is now used as `docs/workstreams/<slug>/` directory name

**Critical files:** `ARTIFACT.spec.md`

---

## Phase 2: Update all per-skill ARTIFACT.md files

### Step 2.1: Update Meta storage line in all 11 ARTIFACT.md files
#### Task 2.1.1: Replace `- **Storage:** \`.claude/work/<work-item>/\` at the nearest project root` with `- **Storage:** \`docs/workstreams/<work-item>/\` at the nearest project root` in each file

#### Task 2.1.2: Update `understanding/ARTIFACT.md` specifically — it has additional references in the template (workstream slug comment) and side effects section

**Critical files:**
- `understanding/ARTIFACT.md`
- `planning/ARTIFACT.md`
- `pre-flight/ARTIFACT.md`
- `review/ARTIFACT.md`
- `triage/ARTIFACT.md`
- `estimate/ARTIFACT.md`
- `atomize/ARTIFACT.md`
- `solutioning/ARTIFACT.md`
- `reasoning/ARTIFACT.md`
- `leeroyyyyy/ARTIFACT.md`
- `tire-kicking/ARTIFACT.md`

**Not included:** `pull-request/ARTIFACT.md` — storage is `GitHub pull request (not a local file)`, no path to update.

---

## Phase 3: Update all SKILL.md files

### Step 3.1: Update artifact references in SKILL.md files
#### Task 3.1.1: `understanding/SKILL.md` — update artifact section reference
#### Task 3.1.2: `planning/SKILL.md` — update Stage 3 save location, artifacts-are-project-local bullet, and artifact section reference
#### Task 3.1.3: `solutioning/SKILL.md` — update artifact section reference
#### Task 3.1.4: `reasoning/SKILL.md` — update artifact section reference
#### Task 3.1.5: `review/SKILL.md` — update artifact section reference
#### Task 3.1.6: `triage/SKILL.md` — update artifact section reference
#### Task 3.1.7: `tire-kicking/SKILL.md` — update artifact section reference AND the tool-agnostic example paths (`.cursor/work/`, `.windsurf/work/` → `docs/workstreams/`)
#### Task 3.1.8: `leeroyyyyy/SKILL.md` — update all references (precondition, plan save location, summary artifact)
#### Task 3.1.9: `pull-request/SKILL.md` — update artifact link lookup path

### Step 3.2: Add docs/reference/ awareness to discovery skills
#### Task 3.2.1: `understanding/SKILL.md` — add note that `docs/reference/` should be consulted for existing project context if it exists
#### Task 3.2.2: Add similar awareness to recon if it references contextual lookups (verify first)

---

## Phase 4: Update project instructions and memory

### Step 4.1: Update CLAUDE.md
#### Task 4.1.1: Add a "Docs Convention" section explaining the `docs/` directory structure (`docs/workstreams/` for pipeline artifacts, `docs/reference/` for project reference material)
#### Task 4.1.2: Note that artifacts are project-local — saved to `docs/workstreams/<slug>/`, never to `.claude/work/` or home directory paths

### Step 4.2: Update MEMORY.md
#### Task 4.2.1: Update "Artifact Principles" section to reference `docs/workstreams/` instead of `.claude/work/` or `.cursor/plans/`
#### Task 4.2.2: Remove stale `artifactor.md` reference if the skill doesn't exist

### Step 4.3: Update README.md
#### Task 4.3.1: If README references artifact storage location, update it. (Based on recon, it doesn't directly — verify and update if needed.)

---

## Phase 5: Migrate existing workstreams and clean up

### Step 5.1: Move existing workstream directories
#### Task 5.1.1: `git mv .claude/work/artifact-capture-and-subagent-orchestration/ docs/workstreams/artifact-capture-and-subagent-orchestration/`
#### Task 5.1.2: `git mv .claude/work/conditional-workflow-phases/ docs/workstreams/conditional-workflow-phases/`
#### Task 5.1.3: `git mv .claude/work/rapid-rebrand/ docs/workstreams/rapid-rebrand/`
#### Task 5.1.4: `git mv .claude/work/remove-parallelism-from-skills/ docs/workstreams/remove-parallelism-from-skills/`
#### Task 5.1.5: Verify `docs/workstreams/move-artifacts-to-docs/` already exists (created during understanding)

### Step 5.2: Clean up .gitignore and old directory
#### Task 5.2.1: Update `.gitignore` — remove the `.claude/work` allowlist lines, keep `.claude/**` ignore
#### Task 5.2.2: Remove the now-empty `.claude/work/` directory

### Step 5.3: Verify migration
#### Task 5.3.1: Run `grep -r '\.claude/work' --include='*.md'` and confirm zero hits outside of `docs/workstreams/` (historical artifacts only)
#### Task 5.3.2: Confirm all 4 migrated workstream directories exist under `docs/workstreams/`

---

## Gotchas & Risks

| Risk | Mitigation |
|---|---|
| Missing a reference somewhere | Grep for `.claude/work` after all changes and verify zero hits in non-historical files |
| Historical artifacts contain old paths | Intentional — we don't rewrite history. These are records of past decisions. |
| `tire-kicking` tool-agnostic examples (`.cursor/work/`, `.windsurf/work/`) | Update to `docs/workstreams/` — the new path is tool-agnostic by design |
| Planning skill itself references the old path | Yes — it's in the loaded skill text. The on-disk file gets updated; future invocations will use the new path. |

## Success Criteria
- `grep -r '\.claude/work' --include='*.md'` returns zero hits outside of `docs/workstreams/` (historical artifacts only)
- New artifact writes go to `docs/workstreams/<slug>/` without permission prompts
- `.gitignore` is simplified to just `.claude/**`
- `CLAUDE.md` documents the `docs/` convention
- All 4 existing workstream directories live under `docs/workstreams/`
