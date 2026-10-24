#!/usr/bin/env python3
"""CI check: the downloadable standalone package contains every source module."""
from pathlib import Path
import re

root = Path(__file__).resolve().parent.parent
core = (root / "Kernel" / "RAY.wl").read_text(encoding="utf-8")
bundle = (root / "RAYStandalone.wl").read_text(encoding="utf-8")

version = re.search(r'\$RAYVersion\s*=\s*"([^"]+)"', core)
paclet = (root / "PacletInfo.wl").read_text(encoding="utf-8")
assert version, "No core RAY version found"
assert f'"Version" -> "{version.group(1)}"' in paclet, "Paclet/core versions differ"
assert f"standalone v{version.group(1)}" in bundle, "Standalone version differs"

for module_path in sorted((root / "Kernel").glob("RAY*.wl")):
    if module_path.name == "RAY.wl":
        continue
    source = module_path.read_text(encoding="utf-8").strip()
    assert source in bundle, f"Standalone missing module source: {module_path.name}"

assert 'BeginPackage["RAY`"]' in bundle
# Match package declarations at the start of a source line, not text quoted
# inside user-facing strings (the updater validates package markers in downloads).
assert len(re.findall(r'(?m)^\s*BeginPackage\[', bundle)) == 1
assert len(re.findall(r'(?m)^\s*EndPackage\[', bundle)) == 1
assert "RAYSymbolicWarped.wl" not in bundle.split('(* --- Embedded', 1)[0], (
    "Standalone still depends on external symbolic warp source"
)
print(f"Standalone consistency OK: {version.group(1)}")
