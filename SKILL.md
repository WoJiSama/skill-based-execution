---
name: skill-based-execution
description: >
  Portable execution discipline derived from skill-based-architecture (SBA).
  Use for software development tasks in any project that has no skill
  architecture of its own: "fix a bug", "add a feature", "refactor this",
  "plan the implementation", "address the review comments", "修个 bug",
  "加个功能", "重构一下", "处理评审意见". Also use when the user names
  "skill-based-execution" or "SBE". Do NOT activate when the working project
  already routes the task through its own skill — defer to it. This skill
  carries task execution and closure discipline only: it keeps no session
  memory, writes no agent-initiated records into the target project
  (user-requested deliverables excluded), and never restructures a project.
---

# Skill-Based Execution (SBE)

Stateless, portable downstream of [skill-based-architecture](https://github.com/WoJiSama/skill-based-architecture). SBA embeds skill architecture into a repository; SBE carries the same execution discipline — requirement → anchor → plan → mutation → closure — with the agent, into any project. Nothing persists between tasks.

<always-applicable>

## Always Read

Default is empty. Workflows load rules at their own boundaries; do not preload.

## Session Discipline

**Every new task — even the second or third in the same session — must read `routing.yaml` and re-match one route before acting.** Re-matching is cheap and catches the most common error: a new task that belongs to a different route than the last one.

- Re-read only what changed or was lost. If you cannot tell whether context was compacted, re-read the current workflow and decision-relevant evidence.
- Use evidence-driven context — start with the selected workflow and the smallest source slice that can decide the next action. Only one clear read-only or fixed-contract action with no new desired behavior stays Simple; any request that adds or changes user-visible behavior, a business flow/state, or an external contract follows the ordered progression `requirement-ready -> Task Anchor -> implementation-ready -> Native Plan -> mutation`, owned by [`workflows/task-execution.md`](workflows/task-execution.md). An incomplete Requirement returns current understanding, real risk/conflict, and the minimum normative question instead of a Plan.
- After classifying a task as non-Simple, read [`rules/agent-behavior.md`](rules/agent-behavior.md) before the first action. Modifying workflows read [`rules/change-discipline.md`](rules/change-discipline.md) before the first mutation; [`workflows/task-closure.md`](workflows/task-closure.md) loads only when completion begins.
- Before final validation or commit after a long or interrupted task, run [`protocol-blocks/reboot-check.md`](protocol-blocks/reboot-check.md): restate the original user constraints and chosen route; if you cannot, re-read the request, current workflow, and decision-relevant evidence before proceeding.
- Vague wording is a signal, not a blocker: inspect the smallest read-only evidence first; see `protocol-blocks/ambiguous-request-gate.md`.

</always-applicable>

<task-routing>

## Common Tasks

Action hook, not a route catalog. Exact route data lives only in `routing.yaml`:

<!-- ROUTING_SUMMARY_START -->
- 修 bug / 排查异常 (`fix-bug`) -> workflow `workflows/fix-bug.md`
- 新增 / 重构 / 优化非 bug 行为 (`change-managed`) -> workflow `workflows/change-managed.md`
- 跨多处的同型重构 (`refactor-fanout`) -> workflow `workflows/refactor-fanout.md`
- 定义 / 澄清需求与目标行为 (`define-requirement`) -> workflow `workflows/define-requirement.md`
- 基于已确认需求制定实现计划 (`plan-feature`) -> workflow `workflows/plan-feature.md`
- 处理代码评审意见 (`receiving-review`) -> workflow `workflows/receiving-review.md`
- 从 skill-based-architecture 上游更新本 skill (`update-upstream`) -> workflow `workflows/update-upstream.md`
- 其他 / 未列出的任务 (`other`) -> workflow `workflows/task-execution.md`
<!-- ROUTING_SUMMARY_END -->

</task-routing>

## Known Gotchas

<!-- Starts empty by design: entries come only from real failures via task-closure AAR, written as symptom → cause → fix. Do not prefill imagined ones. -->
- <!-- empty -->

## Boundaries

- A project that routes the task through its own skill always wins. When SBE activates and the project's own skill covers the task, read that skill's routing manifest and follow its route for the whole task: SBE stops being the owner — no re-routing, no layering its protocols on top, no duplicating the project's workflows.
- SBE owns execution discipline only. It writes no agent-initiated gotchas, references, rules, or knowledge records into the target project — durable project knowledge is the project's own skill's job. A user-requested deliverable (e.g. a plan/PRD document the user asked for) is not such a record.
- Stateless by design: no read ledgers, no session-memory files, no cross-session task state. Task state lives only in the current Session's Task Anchor and native Plan.
- Subagents are optional accelerators; correctness and completion never depend on them.

## Rule Priority

1. The current user's explicit request in this conversation
2. The target project's own skill and declared rules (when present)
3. This `SKILL.md`
4. `routing.yaml`
5. `rules/*`
6. The matched route's `workflow`
7. The real code

## Self-Maintenance

Changes to this skill itself follow the same protocols, then run `scripts/smoke-test.sh` and `scripts/check-conformance.sh`. Track SBA upstream via `.upstream-sync` and [`workflows/update-upstream.md`](workflows/update-upstream.md).
