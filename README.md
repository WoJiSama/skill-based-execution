# skill-based-execution (SBE)

Stateless, portable execution discipline — the third layer of the skill-based-architecture (SBA) family.

```text
SBA  (upstream)              embeds skill architecture INTO a repository
 └─ chaos / chaos-web        per-product downstreams, assembled by aii into product workspaces
 └─ SBE  (this repo)         carries SBA's execution discipline WITH the agent, into any project
```

SBA 把架构装进仓库；SBE 把执行纪律装进 skill 本身，随人走而不是随仓库走。装一次（`~/.agents/skills/`），在**任何**没有自有 skill 架构的项目里生效：一次性任务、不归你管/不能重构结构的仓库、还没做 SBA 迁移的项目。

## What it carries / what it deliberately dropped

**Carried** (generic skeleton from SBA templates):

- Task routing: `fix-bug` / `change-managed` / `refactor-fanout` / `define-requirement` / `plan-feature` / `receiving-review` / `other`
- Task Execution Protocol: Task Classifier, Task Anchor, Presentation Gate, Anchor Checkpoint, User Decision Drift Gate, Native Plan boundary
- Task Closure Protocol: trigger policy, fresh fitted evidence, delivery verification, rationalizations-to-reject, lightweight AAR
- Protocol blocks: change-contract, source-localization, ambiguous-request-gate, user-decision-drift, reboot-check, external-delivery-verification

**Dropped by design** (this is the "另一个方向"):

- Memory machinery: read ledgers (读账本), session-memory files, SessionStart hooks, compaction-recovery state, memory routing, knowledge reconciliation (`rule-update/`), `update-rules`
- Embedding machinery: thin shells / harness registration, routing generation, materializer phases, domain routing, per-project code-facts layers, aii assembly / path resolution

SBE is stateless: task state lives only in the current Session's Task Anchor and native Plan; lessons are reported to the user at Closure, never written into the target project. **A project that routes the task through its own skill always wins; SBE defers.**

## Install

```bash
bash scripts/install.sh            # symlink ~/.agents/skills/skill-based-execution -> this repo
bash scripts/install.sh --copy     # if your tool cannot follow symlinks
```

## Upstream tracking

`.upstream-sync` records the SBA commit SBE was last synced from; `workflows/update-upstream.md` owns the refresh procedure; `sync-manifest.yaml` records each file as `vendor` (byte-identical) / `adapted` (semantic) / `local`. Upstream mechanisms concerning removed machinery are understood, then consciously not adopted.

## Layout

```text
SKILL.md            entry: coarse activation + boundaries (dual budget)
routing.yaml        canonical task routes (always_read stays empty)
rules/              agent-behavior (defaults), change-discipline (mutation safety)
workflows/          task-execution / task-closure + task workflows + update-upstream
protocol-blocks/    shared gates consumed by workflows
scripts/            smoke-test.sh (structure), check-conformance.sh (anchors), upstream-status.sh (behind-check), install.sh
conformance.yaml    behavior anchors this skill must keep
```

## Validate

```bash
bash scripts/smoke-test.sh
bash scripts/check-conformance.sh
```
