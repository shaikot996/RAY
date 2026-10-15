# RAY 1.2.0 — Fully symbolic d+n warped geometry

This module computes exact Ricci and Einstein expressions with **d and n left symbolic**. It is not an all-purpose symbolic-dimension arbitrary metric algorithm: it assumes a specific class of time-warped block products.

## Geometric assumptions

The metric is

\[
ds^2=-L(t)^2dt^2+\sum_{I=1}^p e^{2a_I(t)}
\widetilde g^{(I)}_{ab}(y_I)\,dy_I^a dy_I^b.
\]

Spatial block dimensions m_I may be symbolic. The reference metrics depend only on their own internal block coordinates and are time independent. The shift is zero and time is orthogonal to all spatial blocks. We assume a nonzero lapse, and spatial reference blocks with positive signature for cosmology.

With H_I = a_I'(t)/L(t), Q = Sum[m_I H_I], and D_tau = (1/L)D_t:

\[
R_{tt}=-L^2\sum_I m_I(D_\tau H_I+H_I^2),
\]

\[
R^{(I)}_{ab}=\widetilde R^{(I)}_{ab}
+e^{2a_I}(D_\tau H_I+H_I Q)\widetilde g^{(I)}_{ab},
\]

\[
R=\sum_I e^{-2a_I}\widetilde R_I+
2\sum_I m_I D_\tau H_I+Q^2+\sum_I m_I H_I^2,
\]

\[
G_{tt}=\frac{L^2}{2}\left[Q^2-\sum_I m_I H_I^2+
\sum_I e^{-2a_I}\widetilde R_I\right].
\]

For d+n let m_1=d-1, m_2=n and warps A(t), B(t).

## Notebook example: keep d,n symbolic

~~~mathematica
Needs["RAY`"];
ClearAll[d,n,t,A,B];

model=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,"ExternalGeometry"->"Flat",
 "InternalGeometry"->"General"];

model["TotalDimension"]   (* d+n *)
model["RicciTimeTime"] // RAYReadable
model["RicciScalar"] // RAYReadable
model["EinsteinTimeTime"] // RAYReadable
model["Blocks"][[1,"RicciTensor"]] // RAYPretty
model["Blocks"][[2,"RicciTensor"]] // RAYPretty
RAYWarpedReport[model]
~~~

With an unspecified internal geometry, its intrinsic scalar curvature is the formal placeholder RAYIntrinsicScalar["Internal"] and its intrinsic Ricci tensor is a formal RAYTensor. The package does not assume Ricci flatness.

Geometry options:
- "Flat"
- "General" (unspecified intrinsic scalar and tensor)
- {"General", Rscalar} (supplied scalar, unspecified tensor)
- {"Einstein", lambdaI}: intrinsic Ricci_ab = lambdaI * reference metric_ab
- {"ConstantCurvature", kI}: intrinsic Ricci_ab=(m-1)kI reference metric_ab and intrinsic scalar=m(m-1)kI

## Curved internal manifold and nontrivial lapse

~~~mathematica
curved=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,
 "Lapse"->lapse[t],
 "InternalGeometry"->{"ConstantCurvature",kInternal}];

curved["RicciScalar"] // RAYReadable
curved["Blocks"][[2,"RicciTensor"]] // RAYPretty
~~~

## Einstein equations with Lambda and homogeneous fluids

~~~mathematica
source=<|"EnergyDensity"->rho[t],
 "Pressures"->{pExternal[t],pInternal[t]}|>;

equations=RAYWarpedFieldEquations[curved,source,
 "Coupling"->kappa,"CosmologicalConstant"->lambda];

equations["TimeTime"]
equations["Spatial"][[1,"Equation"]]
equations["Spatial"][[2,"Equation"]]
~~~

The matter convention is T_tt=L^2 rho and T^(I)_ab=p_I e^(2a_I) referenceMetric^(I)_ab. For flat/Einstein reference blocks these are scalar equations; if the block has general intrinsic Ricci curvature the complete tensor equation is retained, with a separate trace. The trace alone is not a replacement for all tensor components.

## Multiple spatial warp factors

~~~mathematica
multi=RAYWarpedBlocks[{
 {"External",d-1,A[t],"Flat"},
 {"Internal",n,B[t],"General"},
 {"Extra",2,Fwarp[t],"Flat"}
}, "Time"->t, "Lapse"->lapse[t]];

multi["TotalDimension"]
multi["RicciScalar"] // RAYReadable
~~~

## Explicit components only after choosing integer dimensions

~~~mathematica
ClearAll[t,A,B,x1,x2,y1,y2];

small=RAYGeneralWarpedMetric[3,2,A[t],B[t],
 "Time"->t,"InternalGeometry"->{"ConstantCurvature",1}];

RAYWarpedToComponents[small,"Example5D",{
 {{x1,x2},IdentityMatrix[2]},
 {{y1,y2},DiagonalMatrix[{1,Sin[y1]^2}]}
},Assumptions->0<y1<Pi];

FullSimplify[
 RAYRaw["RicciScalar"]-small["RicciScalar"],
 Assumptions->0<y1<Pi
]
~~~

Expected zero. Note: the bridge checks concrete coordinate/matrix sizes but does not independently verify that a supplied reference metric belongs to its declared Einstein/constant-curvature class.

## Test coverage and limitations

Run Tests/RAY_SymbolicWarped_Tests.wl. There are 82 new exact formula and functional cases covering dimensions, lapse, arbitrary reference curvature, multi-block geometry, Einstein equations and 3D/5D component agreement.

These formulas do not automatically handle arbitrary off-diagonal coordinate-dependent metrics in symbolic dimension, intrinsically time-dependent reference metrics, or a lower-dimensional Einstein-frame action. The explicit metric engine remains available separately.
