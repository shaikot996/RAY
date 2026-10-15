# RAY 1.1.0 — Release Notes

Release date: 2026-10-15.

## New in 1.1.0

- RAYRaw accepts full unevaluated RAY function calls, bare function symbols and original string selectors.
- Hilbert metric variation of algebraic matter Lagrangians using RAYMetricVariables and RAYMatterAction; scalar and Maxwell helpers.
- Component Einstein equations via RAYEinsteinEquations, with vacuum defaults, Lambda/coupling and filtering.
- RAYSolve and RAYPlot: multiple initial conditions, consistent quantity colors and IC-specific line patterns.
- A three-step Mathematica front-end wizard (RAYSolveWizard).
- RAYWarpedMetric, RAYCovD, RAYConventions for block products, explicit covariant derivatives and conventions.
- Abstract-index calculations via RAYUp/RAYDown, RAYCanonicalize, RAYIndexCheck, RAYContract, RAYBianchiReduce, RAYCovDCommutator.
- Explicit-component translation via RAYToComponents and user tensor registration via RAYRegisterTensor/RAYUnregisterTensor.
- RAYSymbolicMetric and RAYInstantiateMetric for symbolic metrics and their component realization.
- **RAYStandalone.wl**, a self-contained one-file distribution.

## Verified tests

Executed in a Wolfram Language 15 kernel using the version 1.1.0 source:

| Suite | Passed | Total |
|---|---:|---:|
| Original geometry regression tests | 7 | 7 |
| Development regression tests | 11 | 11 |
| Timed functional benchmarks | 62 | 62 |
| **Combined** | **80** | **80** |

The 62 benchmark expressions took approximately **0.887 s accumulated evaluation time** in the evaluator session. This excludes package load and test harness overhead. Results are not a cross-hardware performance guarantee.

Reproducible suites: Tests/RAY_Tests.wl, Tests/RAY_Development_Tests.wl and Tests/RAY_Benchmarks.wl. Examples: Examples/RAY_Development.wl. Guide: DEVELOPMENT_API.md.

## Installation

**One file (Windows, Linux, macOS):** download RAYStandalone.wl and load it directly:

~~~mathematica
Get["C:\\path\\to\\RAYStandalone.wl"]
RAYVersion
~~~

No other RAY source files are required for this distribution.

**Application/paclet:** clone/download the complete repository as the RAY folder; place it under $UserBaseDirectory/Applications/RAY and load it:

~~~mathematica
Needs["RAY`"]
RAYVersion
~~~

Or use PacletInstall["/path/to/RAY"] with the extracted repository.

## Scope boundaries

- The abstract-index layer handles slot symmetries, dummy renaming, contractions, first Riemann Bianchi identity and commutators. It is **not a full xAct substitute** for arbitrary tensor canonicalization and higher algebra.
- Matter variation handles algebraic inverse-metric dependence, not curvature, tetrad or metric-derivative action variations.
- The numerical backend was tested in a real kernel; graphical wizard operation has not been exercised in an interactive notebook session.
- GitHub Actions checks structural/source consistency; the Wolfram suites were executed separately in a Wolfram kernel.
