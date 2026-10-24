# RAY 1.4.0 — fully independent d+n doubly twisted geometry

## Exact ansatz and scope

The general geometry is

    ds_D^2 = exp(2 A(x,y)) hat[g]_(mu nu)(x) dx^mu dx^nu
           + exp(2 B(x,y)) tilde[g]_(mn)(y) dy^m dy^n

where D=d+n, A and B are completely independent functions of ALL coordinates. The reference metrics are arbitrary nondegenerate metrics on their corresponding coordinate sectors: there is no Kähler, Einstein, Ricci-flat, constant-curvature, or diagonal assumption. The sign convention matches RAY's existing Riemann convention.

These are known doubly twisted product curvature identities; no novelty of the mathematical identity is asserted.

The exact general mixed Ricci block is

    R_(mu m) = -(d-1) partial_mu partial_m A
               -(n-1) partial_mu partial_m B
               +(d+n-2) (partial_mu B) (partial_m A).

The Ricci scalar uses hat and tilde reference-metric gradients and Laplacians:

    R = exp(-2A) [hatR - 2(d-1)hatBox A - 2n hatBox B
         -(d-1)(d-2)|hatGrad A|^2 - n(n+1)|hatGrad B|^2
         -2n(d-2)(hatGrad A dot hatGrad B)]
      + exp(-2B) [tildeR - 2d tildeBox A - 2(n-1)tildeBox B
         -d(d+1)|tildeGrad A|^2
         -(n-1)(n-2)|tildeGrad B|^2
         -2d(n-2)(tildeGrad A dot tildeGrad B)].

The package returns all external/internal/mixed Ricci and Einstein blocks, and scalar, without constructing a dimension-specific coordinate matrix.

## Mathematica — symbolic d+n with no hidden dependence assumptions

~~~mathematica
Needs["RAY"<>FromCharacterCode[96]];
ClearAll[d,n,A,B];
g=RAYDoubleWarpedGeometry[d,n,A,B,
  "DerivativeForm"->"Covariant"];
RAYDoubleWarpedReport[g]
g["RicciMixed"] // RAYPretty
g["RicciScalar"] // RAYPretty

partial=RAYDoubleWarpedGeometry[d,n,A,B,
  "DerivativeForm"->"Partial"];
partial["RicciExternal"] // RAYPretty
~~~

Without coordinate information RAY NEVER decides that a symbolic mixed derivative vanishes merely from the appearance of the variable names. Partial and covariant expressions are mathematically equivalent, including connection corrections.

## Mathematica — complete coordinate lists, arbitrary warps

~~~mathematica
ClearAll[t,x,y,z,A,B];
g=RAYDoubleWarpedGeometry[
  2,2,A[t,x,y,z],B[t,x,y,z],
  "ExternalCoordinates"->{t,x},
  "InternalCoordinates"->{y,z}
];
g["RicciMixed"] // RAYPretty
cm=RAYDoubleWarpedToComponents[g,"Test4D",{t,x},{y,z},
  {{-1,0},{0,1}},IdentityMatrix[2],
  "Verify"->True];
cm["Verified"]           (* expected: True *)
cm["Residuals"]          (* each entry exactly zero *)
cm["RicciTensor"] // MatrixForm
cm["RicciScalar"] // RAYReadable
cm["EinsteinTensor"] // MatrixForm
~~~

This component bridge constructs the actual full metric, evaluates all its Levi-Civita curvature independently and checks external/internal/mixed Ricci, Ricci scalar and Einstein trace against the abstract formula. The full metric becomes the active RAY metric.

## Nonflat reference metrics: independent validation

~~~mathematica
ClearAll[t,x,y,z];
g2=RAYDoubleWarpedGeometry[2,2,t*y+x*z,t*z+x*y];
c2=RAYDoubleWarpedToComponents[
  g2,"Curved4D",{t,x},{y,z},
  DiagonalMatrix[{-1,1+t^2}],
  DiagonalMatrix[{1,1+y^2}],
  "Verify"->True
];
c2["Verified"]        (* True *)
~~~

No reference Einstein or constant-curvature assumption is made.

## Symbolic Type IIB 4+6 example

~~~mathematica
ClearAll[t,x1,x2,x3,y1,y2,y3,y4,y5,y6,A,B];
ext={t,x1,x2,x3};
int={y1,y2,y3,y4,y5,y6};
all=Join[ext,int];
g10=RAYDoubleWarpedGeometry[
  4,6,A@@all,B@@all,
  "ExternalCoordinates"->ext,
  "InternalCoordinates"->int
];
g10["RicciScalar"] // RAYPretty
g10["RicciMixed"] // RAYPretty
~~~

The 4+6 model is still symbolic in the reference metrics. Supplying explicit 4x4 and 6x6 reference matrices to RAYDoubleWarpedToComponents permits component-level curvature.

## Independence, limits and compatibility

- Fully general preferred entrypoint: RAYDoubleWarpedGeometry[d,n,A,B].
- Legacy RAYCrossWarpedGeometry[d,n,A,B] retains its former separated A(y),B(x) interpretation for compatibility.
- With the legacy entrypoint use "WarpDependence"->"General" to select the new fully general formula. For the earlier behavior use "WarpDependence"->"Separated".
- Optional exact coordinate lists certify vanished derivatives; if unspecified, no sector-specific dependence is presumed.
- Bare symbolic A/B passed to the component bridge without an explicit constant declaration are REJECTED rather than being silently treated as constants.
- Abstract geometries still require factorized reference metrics hat[g](x) and tilde[g](y). If you wish reference metrics to depend on both x and y, define the complete explicit block matrix via RAYDefineMetric; the abstract doubly twisted product formula does not apply in that more general situation.
- Arbitrary space-and-time-dependent Einstein equations are PDEs. Existing RAYSolve supports ODE evolution after a time-only reduction; it is not a general PDE solver.

## Validation

Tests/RAY_DoubleWarped_Tests.wl provides 45 focused assertions, including completely arbitrary mixed derivatives, partial/covariant equivalence, readable notebook notation, rejection of unsafe coordinate assumptions and independent 4D curved-reference Levi-Civita checks.
