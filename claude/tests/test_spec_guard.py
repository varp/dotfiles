#!/usr/bin/env python3
"""Scenario tests for dotfiles/claude/hooks/spec-guard.py.

Run: make test-claude-guard

The guard runs with HOME pointed at a temporary home whose ~/.claude entries
are symlinks into this repo, as `make dotfiles-dotfiles` installs them. That
way the tests cover both paths to a protected file and never touch the real
~/.claude.
"""
import json
import os
import subprocess
import sys
import tempfile

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SRC = os.path.join(REPO, "dotfiles", "claude")
GUARD = os.path.join(SRC, "hooks", "spec-guard.py")
LINKED = ["hooks/spec-guard.py", "agents/spec-writer.md", "agents/planner.md",
          "agents/developer.md"]


def make_home(tmp):
    home = os.path.join(tmp, "home")
    for rel in LINKED:
        dst = os.path.join(home, ".claude", rel)
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        os.symlink(os.path.join(SRC, rel), dst)
    return home


def cases(home, proj):
    spec = proj + "/docs/superpowers/specs/x.md"
    plan = proj + "/docs/superpowers/plans/x.md"
    hc = home + "/.claude"

    def w(path, agent=None, effort=None, tool="Write"):
        d = {"tool_name": tool, "cwd": proj, "tool_input": {"file_path": path}}
        if agent:
            d["agent_type"] = agent
        if effort:
            d["effort"] = {"level": effort}
        return d

    def b(cmd, agent=None):
        d = {"tool_name": "Bash", "cwd": proj, "tool_input": {"command": cmd}}
        if agent:
            d["agent_type"] = agent
        return d

    def a(role, **kw):
        return {"tool_name": "Agent", "tool_input": {"subagent_type": role, **kw}}

    # (name, hook input, expect deny)
    return [
        ("main writes spec", w(spec), True),
        ("spec-writer writes spec at high", w(spec, "spec-writer", "high"), False),
        ("spec-writer writes spec at medium", w(spec, "spec-writer", "medium"), True),
        ("planner writes spec", w(spec, "planner", "high"), True),
        ("main writes plan", w(plan), True),
        ("developer edits plan", w(plan, "developer", tool="Edit"), True),
        ("planner writes plan at high", w(plan, "planner", "high"), False),
        ("planner writes plan at medium", w(plan, "planner", "medium"), True),
        ("spec-writer writes plan", w(plan, "spec-writer", "high"), True),
        ("relative plan path", w("docs/superpowers/plans/x.md"), True),
        ("main writes code", w(proj + "/main.go"), False),
        ("edit ~/.claude planner.md", w(hc + "/agents/planner.md", tool="Edit"), True),
        ("edit ~/.claude spec-writer.md", w(hc + "/agents/spec-writer.md", tool="Edit"), True),
        ("write ~/.claude guard", w(hc + "/hooks/spec-guard.py"), True),
        ("edit ~/.claude developer.md", w(hc + "/agents/developer.md", tool="Edit"), False),
        ("edit repo planner.md", w(SRC + "/agents/planner.md", tool="Edit"), True),
        ("edit repo spec-writer.md", w(SRC + "/agents/spec-writer.md", tool="Edit"), True),
        ("write repo guard", w(GUARD), True),
        ("edit repo developer.md", w(SRC + "/agents/developer.md", tool="Edit"), False),
        ("bash reads plan", b("cat docs/superpowers/plans/x.md 2>/dev/null"), False),
        ("bash git add spec and plan",
         b("git add docs/superpowers/specs/x.md docs/superpowers/plans/x.md"), False),
        ("bash sed -i plan", b("sed -i '' s/a/b/ docs/superpowers/plans/x.md"), True),
        ("bash redirect into spec", b("echo hi > docs/superpowers/specs/x.md"), True),
        ("planner bash sed plan",
         b("sed -i '' s/a/b/ docs/superpowers/plans/x.md", "planner"), False),
        ("planner bash rm planner.md", b("rm ~/.claude/agents/planner.md", "planner"), True),
        ("bash rm guard", b("rm ~/.claude/hooks/spec-guard.py"), True),
        ("bash ls", b("ls"), False),
        ("Agent planner on fable", a("planner", model="fable"), True),
        ("Agent planner on opus", a("planner", model="opus"), False),
        ("Agent planner at medium", a("planner", effort="medium"), True),
        ("Agent planner plain", a("planner"), False),
        ("Agent spec-writer on opus", a("spec-writer", model="opus"), True),
        ("Agent spec-writer plain", a("spec-writer"), False),
        ("Agent developer on opus", a("developer", model="opus"), False),
    ]


def main():
    with tempfile.TemporaryDirectory() as tmp:
        home = make_home(tmp)
        proj = os.path.join(tmp, "proj")
        os.makedirs(proj)
        env = dict(os.environ, HOME=home)
        fails = 0
        all_cases = cases(home, proj)
        for name, inp, expect in all_cases:
            p = subprocess.run([GUARD], input=json.dumps(inp), capture_output=True,
                               text=True, env=env)
            out = p.stdout.strip()
            denied = bool(out) and json.loads(out)["hookSpecificOutput"]["permissionDecision"] == "deny"
            ok = denied == expect and p.returncode == 0
            fails += not ok
            print(f"{'ok  ' if ok else 'FAIL'} {name:36} {'deny' if denied else 'pass'}"
                  f"{'' if p.returncode == 0 else f' rc={p.returncode} ' + p.stderr.strip()[:120]}")
        print(f"{len(all_cases) - fails}/{len(all_cases)} ok")
        return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
