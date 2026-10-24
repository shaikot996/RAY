#!/usr/bin/env python3
"""Static delimiter/string/comment checks for Wolfram Language source.

This does not replace evaluation in a Wolfram kernel or VerificationTest.
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCES = sorted((ROOT / "Kernel").glob("*.wl"))
SOURCES += sorted((ROOT / "Tests").glob("*.wl"))
SOURCES += sorted((ROOT / "Examples").glob("*.wl"))
SOURCES += [ROOT / "RAY.wl", ROOT / "RAYStandalone.wl"]


def validate(path: Path):
    source = path.read_text(encoding="utf-8")
    brackets = {"(": ")", "[": "]", "{": "}"}
    stack = []
    comment_depth = 0
    quoted = False
    escaped = False
    line = 1
    i = 0
    while i < len(source):
        ch = source[i]
        next_char = source[i + 1] if i + 1 < len(source) else ""
        if ch == "\n":
            line += 1
        if comment_depth:
            if ch == "(" and next_char == "*":
                comment_depth += 1
                i += 2
                continue
            if ch == "*" and next_char == ")":
                comment_depth -= 1
                i += 2
                continue
            i += 1
            continue
        if quoted:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == '"':
                quoted = False
            i += 1
            continue
        if ch == "(" and next_char == "*":
            comment_depth = 1
            i += 2
            continue
        if ch == '"':
            quoted = True
            i += 1
            continue
        if ch in brackets:
            stack.append((ch, line))
        elif ch in brackets.values():
            if not stack or brackets[stack[-1][0]] != ch:
                raise ValueError(f"{path}: unexpected {ch!r} at line {line}")
            stack.pop()
        i += 1
    if comment_depth or quoted or stack:
        raise ValueError(
            f"{path}: incomplete file "
            f"(comments={comment_depth}, string={quoted}, stack={stack[-3:]})"
        )


def main():
    if not SOURCES:
        raise RuntimeError("No Wolfram source files found")
    for path in SOURCES:
        validate(path)
        print(f"OK  {path.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
