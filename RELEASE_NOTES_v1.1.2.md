# RAY v1.1.2 — Handwritten curvature notation and notebook-style RAW

Date: 2026-10-15.

## What changed

- **RAYRicci["dd"]** and **RAYEinstein["dd"]** now show named nonzero components R_tt, R_xx, R_yy, etc., instead of a large clipped MatrixForm output. All nonzero components are included; there is no silent truncation.
- **RAYRicciScalar[]**, scalar curvature invariants and coordinate-indexed single tensor components now show physics-friendly mathematical notation.
- Time derivatives become dotted functions A-dot and A-double-dot; partial derivatives of P(y,z) and Q(y,z) display as conventional partial fractions instead of superscript derivative multiindices.
- Common exponential warp factors are collected where computationally reasonable.
- Existing RAYNonzero* reports and matrix-form outputs use handwritten math for derivatives.
- `RAYRicci["dd","Matrix"]` and `RAYEinstein["dd","Matrix"]` explicitly select full matrix output.
- **expr // RAW** now presents Mathematica *StandardForm input syntax* (square brackets and A'[t]/A''[t] prime derivatives) rather than the literal InputForm rendering with Derivative[1][A][t].
- RAW bypasses RAY's abstract tensor cosmetic boxes to reveal underlying `RAYTensor[...]` source. Its boxes preserve the original expression for copying/re-evaluation.
- **RAYReadable[expr]** formats arbitrary algebraic input without altering the underlying physics. **RAYPretty** uses the same derivative formatting.

## Examples

~~~mathematica
RAYRicci["dd"]
RAYRicciScalar[]
RAYRicci["dd","Matrix"]
RAYRicci["dd"] // RAW
RAYRicciScalar[] // RAW
RAYReadable[RAYRaw["RicciScalar"]]
~~~

If someone explicitly writes `RAYRaw["RicciScalar"] // TraditionalForm`, Mathematica's built-in partial derivative multiindices still apply. Use RAYReadable instead to get the handwritten physics notation.

## Verified in the Wolfram Language kernel

| Suite | Passed |
|---|---:|
| New handwritten curvature and RAW tests | 35/35 |
| Notebook formatting tests (updated RAW expectation) | 35/35 |
| Original geometry regression | 7/7 |
| Matter/numeric development regression | 11/11 |
| Timed geometry, symbolic and numerical functional benchmarks | 62/62 |
| **Total** | **150/150** |

The tests cover box generation, complete input round trips, displayed curvature components, physics invariance and numerical workflows. Visual rendering inside a user's Mathematica desktop has not been independently tested.

## Installation

Download the updated RAYStandalone.wl and restart the Mathematica kernel. Then:

~~~mathematica
Get["C:\\Users\\YourUser\\Downloads\\RAYStandalone.wl"];
RAYVersion
~~~

The expected version is 1.1.2. For modular package installations, update the entire RAY folder so that Kernel/RAYHandwritten.wl is installed.
