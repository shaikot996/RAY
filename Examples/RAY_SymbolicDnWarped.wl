(* ::Package:: *)
(* RAY 1.2.0: EXACT symbolic d+n curvature without assigning d or n. *)
Needs["RAY`"];
ClearAll[d,n,t,A,B,kappa,lambda,rho,pExt,pInt,kInt,lapse];

(* I. Fully symbolic dimensions: d is external spacetime dimension,
      n is internal dimension. d>=2, n>=1 assumed physically. *)
geometry=RAYGeneralWarpedMetric[d,n,A[t],B[t],
  "Time"->t,
  "ExternalGeometry"->"Flat",
  "InternalGeometry"->"General"];

geometry["TotalDimension"]    (* d+n, no explicit metric matrix *)
geometry["RicciTimeTime"] // RAYReadable
geometry["RicciScalar"] // RAYReadable
geometry["EinsteinTimeTime"] // RAYReadable

(* Internal geometry stays unspecified: intrinsic scalar and tensor
   are symbolic placeholders. *)
geometry["Blocks"][[2,"IntrinsicRicciScalar"]]
geometry["Blocks"][[2,"RicciTensor"]] // RAYPretty
RAYWarpedReport[geometry]

(* II. General Einstein equations, with independent source pressures. *)
equations=RAYWarpedFieldEquations[geometry,
  <|"EnergyDensity"->rho[t],
    "Pressures"->{pExt[t],pInt[t]}|>,
  "Coupling"->kappa,
  "CosmologicalConstant"->lambda];

equations["TimeTime"]
equations["Spatial"][[1,"Equation"]]
equations["Spatial"][[2,"EquationType"]]   (* FullTensor, not scalar *)
equations["Spatial"][[2,"TraceResidual"]] // RAYReadable

(* III. For a constant-curvature internal manifold, spatial
   Einstein equations reduce to scalar coefficient equations. *)
curved=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,
 "Lapse"->lapse[t],
 "InternalGeometry"->{"ConstantCurvature",kInt}];
curved["RicciScalar"] // RAYReadable
curved["Blocks"][[2,"RicciTensor"]] // RAYPretty

curvedEq=RAYWarpedFieldEquations[curved,
 <|"EnergyDensity"->rho[t],
   "Pressures"->{pExt[t],pInt[t]}|>,
 "CosmologicalConstant"->lambda];
curvedEq["TimeTime"]
curvedEq["Spatial"][[2,"Equation"]]

(* IV. Arbitrary number of symbolic warped spatial factors. *)
multi=RAYWarpedBlocks[{
 {"Space1",d-1,A[t],"Flat"},
 {"Space2",n,B[t],{"Einstein",kInt}},
 {"Extra",2,0,"Flat"}
},"Time"->t];

multi["TotalDimension"]
multi["RicciScalar"] // RAYReadable

(* V. Switch to explicit components only AFTER fixing dimension:
   here 2 spatial external + 2 internal coordinates (5D). *)
small=RAYGeneralWarpedMetric[3,2,A[t],B[t],
 "Time"->t,"InternalGeometry"->{"ConstantCurvature",1}];

RAYWarpedToComponents[small,"Sphere5D",{
 {{x1,x2},IdentityMatrix[2]},
 {{y1,y2},DiagonalMatrix[{1,Sin[y1]^2}]}
},Assumptions->0<y1<Pi];

FullSimplify[
  RAYRaw["RicciScalar"]-small["RicciScalar"],
  Assumptions->0<y1<Pi
]     (* 0 *)

(* Numeric equations: use RAYSolve on an independent ODE subsystem
   only after selecting gauge, initial data and constraints. *)
