# RAY v1.1.1 — Notebook mathematical output and RAW

Release date: 2026-10-15.

## User-facing improvements

Abstract tensors and covariant derivatives now typeset in Mathematica StandardForm and TraditionalForm as familiar index notation: A^i B_i, g_ab, R_ab, R^a_bcd, G_ab, C_abcd, delta^a_b, sigma_ab, omega_ab and nabla_a V^b. Internally normalized dummy symbols display as lambda_1, lambda_2, etc.

**Notebook formatting only**: computation remains on unmodified Wolfram expressions; InterpretationBox preserves copy/paste and re-evaluation. Symbolic metric descriptors now contain genuine RAYUp/RAYDown index entries rather than plain variance placeholders.

## RAW / RAYPretty commands

~~~mathematica
expr = RAYTensor["A",{RAYUp[i]}] RAYTensor["B",{RAYDown[i]}];

expr
expr // RAYPretty
expr // RAW
RAYCanonicalize[expr]

RAYRicci["dd"] // RAW
~~~

RAW returns an InputForm display wrapper that exposes full Wolfram Language input syntax, and unwraps TraditionalForm/MatrixForm/TableForm. For algebra use expr or RAYRaw[...]; RAW is for input-style presentation.

## Validation

Ran Wolfram Language 15 against the v1.1.1 standalone distribution:

| Tests | Passed |
|---|---:|
| Notebook / RAW formatting | 35/35 |
| Original regression | 7/7 |
| Development regression | 11/11 |
| Timed geometry, matter, symbolic and numerical benchmarks | 62/62 |
| **Overall** | **115/115** |

The presentation suite tests ToBoxes and ToExpression round trips, symbolic math typography, RAW behavior and compatibility with the existing geometry API. An actual graphical notebook front-end interaction has not been tested: kernel tests validate the generated boxes, not their rendering in every Mathematica desktop version.

## Update / installation

Single-file direct loading:

~~~mathematica
Get["C:\\Users\\YourUser\\Downloads\\RAYStandalone.wl"];
RAYVersion
~~~

Install or update the complete repository folder for regular Needs["RAY`"] loading. In this form the new Kernel/RAYFormatting.wl module must be present.
