#!/usr/bin/python3 -I
"""PreToolUse guard: specs and plans are written only by their own subagents.

Each role pins its model and effort in its frontmatter. Hook input has no
model field, so the model is enforced indirectly: only the role may write its
directory, and an Agent call may not override the role's model or effort.
"""
import json
import os
import re
import sys

HOME = os.path.expanduser("~")
RULES = [
    {"dir": "docs/superpowers/specs", "role": "spec-writer", "what": "Specs",
     "models": {"fable", "claude-fable-5-2"}, "model_name": "Fable 5.2", "effort": "high"},
    {"dir": "docs/superpowers/plans", "role": "planner", "what": "Plans",
     "models": {"opus", "claude-opus-5-5"}, "model_name": "Opus 5.5", "effort": "high"},
]
BY_ROLE = {r["role"]: r for r in RULES}
# Files that define the rules; Claude must not loosen them. The user edits them by hand.
_RULE_FILES = [os.path.join(HOME, ".claude/hooks/spec-guard.py")] + [
    os.path.join(HOME, f".claude/agents/{r['role']}.md") for r in RULES]
# ~/.claude entries are symlinks into the dotfiles repo; a write path is compared
# after realpath, so the link targets must be in the set too, or the guard is open.
PROTECTED = set(_RULE_FILES) | {os.path.realpath(p) for p in _RULE_FILES}
PROTECTED_NAMES = sorted({os.path.basename(p) for p in _RULE_FILES})
WRITE_TOOLS = {"Write", "Edit", "MultiEdit", "NotebookEdit"}
# Bash commands that can change a file. Heuristic: a determined command can slip past.
BASH_WRITE = re.compile(
    r">|\btee\b|\b(sed|perl)\b[^|;&]*\s-i|\b(mv|cp|rm|truncate|touch|ln|dd)\b"
    r"|\bgit\s+(checkout|restore|mv|rm|apply|stash|reset)\b|\b(python3?|node|ruby)\b"
)


def deny(reason):
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }}, sys.stdout)
    sys.exit(0)


def how(rule):
    return (f"{rule['what']} are written only by the {rule['role']} subagent "
            f"({rule['model_name']}, effort {rule['effort']}). Call "
            f"Agent(subagent_type='{rule['role']}') with a brief and the target file; "
            "decisions that belong to the user are made in the main thread first.")


def main():
    data = json.load(sys.stdin)
    tool = data.get("tool_name", "")
    inp = data.get("tool_input") or {}
    agent = data.get("agent_type")
    effort = (data.get("effort") or {}).get("level")
    cwd = data.get("cwd") or os.getcwd()

    if tool in WRITE_TOOLS:
        path = inp.get("file_path") or inp.get("notebook_path") or ""
        path = os.path.realpath(os.path.join(cwd, os.path.expanduser(path)))
        if path in PROTECTED:
            deny(f"{path} defines the spec/plan rule; only the user edits it by hand.")
        for rule in RULES:
            if f"/{rule['dir']}/" in path:
                if agent != rule["role"]:
                    deny(how(rule))
                if effort and effort != rule["effort"]:
                    deny(f"{rule['role']} runs at effort {effort}; the rule requires "
                         f"{rule['effort']}. Check CLAUDE_CODE_EFFORT_LEVEL.")

    elif tool == "Bash":
        cmd = inp.get("command", "")
        # Drop stream redirections that do not write files, so reads like `cat x 2>/dev/null` pass.
        if not BASH_WRITE.search(re.sub(r"\d?>&\d|\d?>\s*/dev/null", "", cmd)):
            return
        if any(n in cmd for n in PROTECTED_NAMES):
            deny("This shell command may change the spec/plan rule; only the user edits it.")
        for rule in RULES:
            if rule["dir"] in cmd and agent != rule["role"]:
                deny("This shell command may change a file the rule protects. " + how(rule))

    elif tool in ("Agent", "Task") and inp.get("subagent_type") in BY_ROLE:
        rule = BY_ROLE[inp["subagent_type"]]
        model = inp.get("model")
        if model and model not in rule["models"]:
            deny(f"{rule['role']} must run on {rule['model_name']}; drop model={model!r}.")
        eff = inp.get("effort")
        if eff and eff != rule["effort"]:
            deny(f"{rule['role']} must run at effort {rule['effort']}; drop effort={eff!r}.")


main()
