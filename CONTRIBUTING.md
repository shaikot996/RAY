# Contributing to RAY

RAY is currently under active development.

Contributions are welcome in the form of:

- bug reports;
- regression tests;
- documentation improvements;
- new example metrics;
- performance improvements;
- tensor-algebra features;
- xAct interoperability;
- higher-dimensional gravity and supergravity modules.

## Development expectations

1. Preserve the documented curvature and index conventions.
2. Add or update regression tests when changing tensor calculations.
3. Prefer explicit, readable Wolfram Language over opaque shortcuts.
4. Keep public component indices in the physical `0,1,...,d-1` convention.
5. Avoid silently changing mathematical conventions.
6. Document new public symbols with `::usage`.
7. Update `RAYHelp[]` when adding public commands.

## Pull requests

A pull request should include:

- a concise description of the change;
- the mathematical convention used;
- a minimal example;
- tests or a reason tests are not applicable;
- any compatibility implications.

For substantial new features, opening an issue first is recommended.
