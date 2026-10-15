(* RAY 1.2.1: exact coordinate-dependent warped product and formal Weyl rules *)
Needs["RAY`"];
ClearAll[d,n,t,x,y,z,A,B,sigma,omega];

(* CHUNK 1: both d and n remain symbolic; metric/covariant
   derivatives of the d-dimensional base remain FORMAL. *)
abstract=RAYAbstractWarpedCurvature[d,n,B[t,x]];
abstract["TotalDimension"]                         (* d+n *)
abstract["RicciScalar"] // RAYPretty
abstract["RicciBaseTensor"] // RAYPretty
abstract["RicciFiberTensor"] // RAYPretty

(* CHUNK 2: coordinate-dependent 2D base with n symbolic fiber:
   ds^2 = -exp(sigma(t)) dt^2 + exp(2 A(t,x)) dx^2
          + exp(2 B(t,x)) h_ij(y) dy^i dy^j. *)
baseMetric=DiagonalMatrix[
 {-Exp[sigma[t]],Exp[2 A[t,x]]}
];
geom=RAYCovariantWarpedMetric[
 "CoordinateWarp",{t,x},baseMetric,n,B[t,x],
 "IntrinsicGeometry"->"General"];

geom["TotalDimension"]                      (* 2+n *)
geom["WarpPartialDerivative"] // RAYReadable
geom["WarpCovariantHessian"] // MatrixForm
geom["WarpCovariantLaplacian"] // RAYReadable
geom["WarpGradientSquared"] // RAYReadable
geom["FullBaseRicciTensor"] // MatrixForm
geom["FullFiberRicciTensor"] // RAYPretty
geom["FullRicciScalar"] // RAYReadable

(* CHUNK 3: verify Christoffel correction explicitly.
   At generic A(t,x) and B(t,x), the cross Hessian differs
   from the naive mixed partial derivative. *)
partialTX=D[B[t,x],t,x];
covariantTX=geom["WarpCovariantHessian"][[1,2]];

FullSimplify[covariantTX-partialTX]
(* Expected: -Derivative[1,0][A][t,x] Derivative[0,1][B][t,x] *)

(* CHUNK 4: correct partial versus covariant notation. *)
RAYPartialD[B[t,x],x]                         (* partial_x B *)
RAYNabla[RAYDown[x],B[t,x]]                 (* formal nabla_x B *)
RAYCovariantHessian[B[t,x],RAYDown[t],RAYDown[x]]
RAYCovariantBox[B[t,x]]

(* CHUNK 5: Weyl rescaling of an arbitrary symbolic d-dimensional
   base metric, Omega(t,x), with BASE covariant derivatives. *)
weyl=RAYWeylRescale[d,omega[t,x]];
weyl["RicciTensor"] // RAYPretty
weyl["RicciScalar"] // RAYReadable

(* CHUNK 6: optional time-derivative dots; partials by default. *)
RAYReadable[A'[t]]
RAYReadable[A'[t],"DerivativeNotation"->"Dot"]

(* CHUNK 7: time-only API MUST reject A(t,x), rather than
   silently discarding spatial gradients. *)
Quiet[
 RAYGeneralWarpedMetric[d,n,A[t,x],B[t],
  "Time"->t]
] // RAW
(* Expected: $Failed *)

(* CHUNK 8: full explicit component check for a 3D fiber n=1. *)
flat=RAYCovariantWarpedMetric[
 "FlatFiber",{t,x},baseMetric,1,B[t,x],
 "IntrinsicGeometry"->"Flat"];
RAYDefineMetric["Direct3D",{t,x,y},
 DiagonalMatrix[{-Exp[sigma[t]],Exp[2 A[t,x]],Exp[2 B[t,x]]}]];
FullSimplify[RAYRaw["RicciScalar"]-flat["FullRicciScalar"]]
(* Expected: 0 *)
