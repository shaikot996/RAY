# RAY — Relativity and Geometry Toolkit

> **Version 1.0.0 — initial public development release.**  
> **RAY is under active development.** APIs, performance characteristics, and higher-level abstractions may evolve as the package grows.

**RAY** is a Wolfram Language package for explicit-component tensor geometry, general relativity, and Raychaudhuri kinematics.

**Tagline:** *Explicit-component tensor geometry and relativity for Wolfram Language.*

RAY is designed around a simple workflow: define an explicit metric matrix and coordinates, optionally define a congruence $u^\mu$, and then query curvature, invariants, kinematics, mixed-index tensors, nonzero components, or a complete report using compact commands.

## Current scope

RAY currently provides:

- arbitrary-dimensional explicit metrics;
- either mostly-plus or mostly-minus signature, carried directly by the metric;
- Christoffel symbols;
- Riemann tensor with configurable index positions;
- Ricci tensor and Ricci scalar;
- Einstein tensor;
- Weyl tensor;
- Kretschmann scalar;
- $R_{\mu\nu}R^{\mu\nu}$;
- $C_{\mu\nu\rho\sigma}C^{\mu\nu\rho\sigma}$;
- mixed-index tensor access;
- nonzero-component tables in readable `TraditionalForm`;
- normalized non-null congruences;
- $\nabla_\mu u_\nu$ and $\nabla_\mu u^\nu$;
- expansion, acceleration, shear, and vorticity;
- shear and vorticity scalars;
- $R_{\mu\nu}u^\mu u^\nu$;
- $\nabla_\mu a^\mu$;
- the Raychaudhuri equation term-by-term;
- consistency checks for the kinematical decomposition and Raychaudhuri identity;
- raw symbolic output for further algebra.

The Raychaudhuri implementation uses expanded definitions built directly from covariant derivatives, the metric, the congruence, and acceleration. It does **not** explicitly introduce a spatial-projector tensor in the shear/vorticity implementation.

---

## Installation

RAY can be loaded either as a normal Wolfram application, as a paclet, or directly from the repository.

### Recommended on Linux / EndeavourOS

First ask Mathematica where your personal Wolfram directory is:

```mathematica
$UserBaseDirectory
```

On current Wolfram installations this is commonly something like:

```text
/home/your-username/.Wolfram
```

RAY should then live inside the `Applications` directory as

```text
~/.Wolfram/Applications/RAY/
```

with a structure like

```text
RAY/
├── Kernel/
│   └── RAY.wl
├── RAY.m
├── RAY.wl
├── PacletInfo.wl
├── README.md
└── ...
```

If you downloaded or cloned the repository as `RAY`, install it with:

```bash
mkdir -p ~/.Wolfram/Applications
cp -r RAY ~/.Wolfram/Applications/
```

If a previous copy is already installed and you want to replace it:

```bash
rm -rf ~/.Wolfram/Applications/RAY
cp -r RAY ~/.Wolfram/Applications/
```

Then restart Mathematica and load RAY with:

```mathematica
Needs["RAY`"]
```

Check the installation with:

```mathematica
RAYVersion
RAYHelp[]
```

### Automatic Linux installer

The repository includes `install-linux.sh`. From inside the repository:

```bash
chmod +x install-linux.sh
./install-linux.sh
```

It copies the package to:

```text
~/.Wolfram/Applications/RAY/
```

and replaces an older installed copy if one exists.

After that, restart Mathematica and run:

```mathematica
Needs["RAY`"]
RAYHelp[]
```

### Paclet installation

You can also install the repository as a paclet:

```mathematica
PacletInstall["/full/path/to/RAY"]
Needs["RAY`"]
```

For development without permanently installing it:

```mathematica
PacletDirectoryLoad["/full/path/to/RAY"]
Needs["RAY`"]
```

### Direct load

To use RAY directly from a cloned/downloaded repository:

```mathematica
Get["/full/path/to/RAY/RAY.wl"]
```

### Confirm where Mathematica searches for packages

Inside Mathematica:

```mathematica
$Path
```

and:

```mathematica
FileNameJoin[{$UserBaseDirectory, "Applications"}]
```

These show the package search paths and your user `Applications` directory.

---

## First commands

```mathematica
RAYHelp[]
RAYAbout[]
```

Focused help:

```mathematica
RAYHelp["Ricci"]
RAYHelp["RAYShear"]
```

Standard Wolfram Language usage messages also work:

```mathematica
?RAYRicci
?RAYShear
?RAYRiemann
```

---

# Example 1 — anisotropic Bianchi-I and Raychaudhuri kinematics

Define

$$
ds^2=-dt^2+e^{2b_1(t)}dx^2+e^{2b_2(t)}dy^2+e^{2b_3(t)}dz^2.
$$

```mathematica
RAYDefineMetric[
  "BianchiI",
  {t, x, y, z},
  DiagonalMatrix[{
    -1,
    Exp[2 b1[t]],
    Exp[2 b2[t]],
    Exp[2 b3[t]]
  }],
  Assumptions -> Element[{t, x, y, z}, Reals]
];
```

Define a comoving congruence. `RAYDefineCongruence` takes **contravariant** components $u^\mu$:

```mathematica
RAYDefineCongruence[
  "Comoving",
  {1, 0, 0, 0}
];
```

Now query the kinematics:

```mathematica
RAYExpansion[]
RAYAcceleration["u"]
RAYShear["dd"]
RAYVorticity["dd"]
RAYShearScalar[]
RAYVorticityScalar[]
```

Request individual components using physical indices $0,1,2,3$:

```mathematica
RAYShear["dd", 1, 1]
RAYShear["ud", 1, 1]
RAYCovariantDerivativeU["dd", 0, 1]
```

Display only nonzero components:

```mathematica
RAYNonzeroShear["dd"]
RAYNonzeroVorticity["dd"]
```

Inspect the Raychaudhuri equation:

```mathematica
RAYRaychaudhuriTerms[]
RAYRaychaudhuriResidual[]
RAYKinematicChecks[]
```

For the default Bianchi-I example, the expansion is

$$
\Theta=\dot b_1+\dot b_2+\dot b_3.
$$

---

# Example 2 — Schwarzschild geometry

Using the mostly-plus convention,

$$
ds^2=
-\left(1-\frac{2M}{r}\right)dt^2
+\left(1-\frac{2M}{r}\right)^{-1}dr^2
+r^2d\theta^2+r^2\sin^2\theta\,d\phi^2.
$$

```mathematica
RAYDefineMetric[
  "Schwarzschild",
  {t, r, \[Theta], \[Phi]},
  DiagonalMatrix[{
    -(1 - 2 M/r),
    1/(1 - 2 M/r),
    r^2,
    r^2 Sin[\[Theta]]^2
  }],
  Assumptions -> r > 2 M > 0 && 0 < \[Theta] < Pi
];
```

Curvature quantities:

```mathematica
RAYNonzeroChristoffel[]
RAYNonzeroRiemann["uddd"]
RAYRicci["dd"]
RAYRicciScalar[]
RAYWeyl["dddd"]
RAYKretschmann[]
```

Expected vacuum checks:

$$
R_{\mu\nu}=0,
\qquad
R=0,
$$

and

$$
R_{\mu\nu\rho\sigma}R^{\mu\nu\rho\sigma}
=
\frac{48M^2}{r^6}.
$$

You can request a single component directly:

```mathematica
RAYRiemann["uddd", 1, 0, 1, 0]
RAYRicci["dd", 0, 0]
RAYWeyl["dddd", 0, 1, 0, 1]
```

---

# Example 3 — arbitrary dimension

RAY does not hard-code four dimensions. The dimension is inferred from the metric and coordinate list.

For 5D Minkowski spacetime:

```mathematica
RAYDefineMetric[
  "Minkowski5D",
  {t, x1, x2, x3, x4},
  DiagonalMatrix[{-1, 1, 1, 1, 1}]
];

RAYDimension[]
RAYRiemann["uddd"]
RAYRicci["dd"]
```

Define a 5D inertial congruence:

```mathematica
RAYDefineCongruence[
  "Inertial5D",
  {1, 0, 0, 0, 0}
];

RAYExpansion[]
RAYRaychaudhuriResidual[]
```

---

# Example 4 — mixed index positions

Index-configuration strings use:

- `u` = upper index;
- `d` = lower index.

Examples:

```mathematica
RAYRicci["dd"]
RAYRicci["ud"]
RAYRicci["uu"]

RAYRiemann["uddd"]
RAYRiemann["dddd"]
RAYRiemann["uudd"]
RAYRiemann["uuuu"]

RAYShear["dd"]
RAYShear["ud"]
RAYShear["uu"]
```

For example,

```mathematica
RAYShear["ud", 1, 1]
```

returns the component corresponding to

$$
\sigma^1{}_1.
$$

---

# Example 5 — one-command reports

Geometry report:

```mathematica
RAYGeometry[]
```

Raychaudhuri/kinematics report:

```mathematica
RAYRaychaudhuri[]
```

Full report:

```mathematica
RAYReport[]
```

---

## Raw symbolic output

Human-facing commands are formatted for notebook readability. For subsequent symbolic manipulation, use `RAYRaw`.

```mathematica
rawRicci = RAYRaw["Ricci", "dd"];
rawRiemann = RAYRaw["Riemann", "uddd"];
rawShearMixed = RAYRaw["Shear", "ud"];

rawR = RAYRaw["RicciScalar"];
rawK = RAYRaw["Kretschmann"];
rawTheta = RAYRaw["Expansion"];
rawResidual = RAYRaw["RaychaudhuriResidual"];
```

---

## Curvature convention

RAY uses

$$
R^\rho{}_{\sigma\mu\nu}
=
\partial_\mu\Gamma^\rho{}_{\nu\sigma}
-\partial_\nu\Gamma^\rho{}_{\mu\sigma}
+\Gamma^\rho{}_{\mu\lambda}\Gamma^\lambda{}_{\nu\sigma}
-\Gamma^\rho{}_{\nu\lambda}\Gamma^\lambda{}_{\mu\sigma},
$$

with

$$
R_{\sigma\nu}
=
R^\rho{}_{\sigma\rho\nu}.
$$

---

## Raychaudhuri convention

For a normalized non-null congruence in $d>1$ dimensions,

$$
\epsilon=u^\mu u_\mu=\pm1,
$$

and RAY evaluates

$$
u^\alpha\nabla_\alpha\Theta
=
-\frac{\Theta^2}{d-1}
-\sigma_{\mu\nu}\sigma^{\mu\nu}
+\omega_{\mu\nu}\omega^{\mu\nu}
-R_{\mu\nu}u^\mu u^\nu
+\nabla_\mu a^\mu.
$$

The metric itself carries the signature; RAY does not hard-code mostly-plus or mostly-minus.

---

## Development status

**RAY 1.0.0 is the first public development release.**

The current release is intended to provide a clean explicit-component foundation. The project is actively evolving, and the present API should be regarded as usable but not yet frozen.

Current priorities are:

- correctness and transparent conventions;
- readable notebook output;
- explicit component access;
- dimension-independent formulas;
- reproducible regression tests;
- a simple interface suitable for research calculations.

---

## Future directions

Planned or exploratory directions include:

### Tensor and geometry infrastructure

- coordinate transformations;
- tensor symmetries and canonicalization;
- more efficient sparse tensor storage;
- faster high-dimensional calculations;
- parallel component evaluation;
- additional curvature invariants;
- geodesics and geodesic deviation;
- tetrads/vielbeins;
- orthonormal-frame components;
- spin connections;
- Cartan structure equations;
- differential forms and exterior calculus;
- ADM / $3+1$ decomposition.

### xAct interoperability

A major future goal is interoperability with the **xAct** ecosystem, including:

- importing/exporting explicit RAY metrics;
- converting RAY component tensors into xAct-compatible objects;
- using xAct for abstract-index manipulations while retaining RAY's explicit-component interface;
- cross-checking curvature and kinematical quantities between the two systems.

### Supergravity and higher-dimensional gravity

Longer-term extensions are intended to support calculations useful in string theory and supergravity, including:

- arbitrary $p$-form field strengths;
- Hodge duals;
- flux contractions and stress tensors;
- Einstein-form systems in higher dimensions;
- vielbein and spin-connection utilities;
- gamma-matrix infrastructure;
- Killing-spinor equations;
- bosonic supergravity equations of motion;
- Bianchi identities for form fields;
- dimensional reduction and compactification utilities;
- warped products;
- flux compactifications;
- effective lower-dimensional quantities.

These directions are **not yet implemented** in Version 1 unless explicitly present in the current API.

---

## Testing

Regression tests are included in:

```text
Tests/RAY_Tests.wl
```

Run them after loading RAY:

```mathematica
Get["/full/path/to/RAY/Tests/RAY_Tests.wl"]
```

The current suite covers representative checks including Bianchi-I, Schwarzschild, FLRW, higher-dimensional flat spacetime, signature changes, rotating congruences, and low-dimensional Weyl behavior.

---

## Repository structure

```text
RAY/
├── Kernel/
│   └── RAY.wl
├── Examples/
│   └── RAY_QuickStart.wl
├── Tests/
│   └── RAY_Tests.wl
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── workflows/
│   └── pull_request_template.md
├── PacletInfo.wl
├── RAY.wl
├── RAY.m
├── install-linux.sh
├── README.md
├── LICENSE
├── CITATION.cff
├── CHANGELOG.md
├── CONTRIBUTING.md
├── CONTRIBUTORS.md
├── AI_ASSISTANCE.md
└── ROADMAP.md
```

---

## Citation

If RAY contributes to a research calculation, please cite the repository. GitHub can generate citation metadata from the included `CITATION.cff`.

---

## AI-assisted development

Parts of the package architecture, code review, testing strategy, documentation, and repository preparation were developed with assistance from **ChatGPT by OpenAI**.

See [`AI_ASSISTANCE.md`](AI_ASSISTANCE.md) for the attribution statement.

---

## License

RAY is released under the **MIT License**. See [`LICENSE`](LICENSE).

---

## Project status

**Version:** 1.0.0  
**Status:** under active development  
**Language:** Wolfram Language  
**Primary focus:** explicit-component tensor geometry, general relativity, and Raychaudhuri kinematics
