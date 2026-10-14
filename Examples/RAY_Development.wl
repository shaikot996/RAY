(* RAY development examples: Wolfram Language 13+. *)
Needs["RAY`"];

ClearAll[t,x,y,z,a,phi,V,u];

(* 1. Raw data from an entire RAY call. *)
RAYDefineMetric["Flat2D",{t,x},DiagonalMatrix[{-1,1}]];
RAYRaw[RAYRicci["dd"]]
RAYRaw[RAYEinstein["dd"]]
RAYRaw["Christoffel"]

(* 2. An explicit scalar matter Lagrangian in symbolic g^ab. *)
q=RAYMetricVariables[];
lag=-1/2 (
    q[[1,1]] D[phi[t,x],t]^2
   +2q[[1,2]] D[phi[t,x],t] D[phi[t,x],x]
   +q[[2,2]] D[phi[t,x],x]^2
   )-V[phi[t,x]];
matter=RAYMatterAction[lag];
matter["Lagrangian"]
RAYRaw["StressTensor","dd"]
RAYStressTensor["dd",0,1]

(* The scalar helper constructs the same Lagrangian. *)
RAYMatterAction[RAYScalarLagrangian[phi[t,x],V[phi[t,x]]]];

(* 3. Einstein equations, with missing stress tensor equal to zero. *)
vacuum=RAYEinsteinEquations[RAYRaw[RAYEinstein["dd"]]];
matterEquations=RAYEinsteinEquations[
  RAYRaw[RAYEinstein["dd"]],RAYRaw["StressTensor","dd"],
  "Coupling"->1,"Components"->"All"
];

(* 4. Explicit covariant derivative; derivative index first. *)
nablaMetric=RAYCovD[RAYRaw["Metric","dd"],"dd"];

(* 5. Warp factor is the entire multiplier of each metric block. *)
RAYWarpedMetric["Warped1Plus1",{
  {{t},{{-1}},1},
  {{x},{{1}},Exp[2 a[t]]}
}];
RAYRaw["Ricci","dd"]
RAYConventions[]

(* 6. Numerical solve and multiple initial conditions. *)
sol=RAYSolve[
  {u''[t]+u[t]==0},{u},{t,0,12},
  {
    {u[0]==0,u'[0]==1},
    {u[0]==1,u'[0]==0},
    {u[0]==2,u'[0]==0}
  }
];
RAYPlot[sol,{u[t],u'[t]},
  "Colors"->{Blue,Red},
  "Frame"->True,
  "FrameLabel"->{"t","u and derivative"},
  "PlotLabel"->"Harmonic oscillator: three IC sets"
];

(* In a Mathematica notebook, optionally use:
   RAYSolveWizard[{u''[t]+u[t]==0},{u},{t,0,12}]
*)

(* 7. Standalone formal abstract tensors. *)
geom=RAYSymbolicMetric["Abstract4",4,"Signature"->{-1,1,1,1}];
RAYAbstractCovD[RAYTensor["A",{i}] RAYTensor["B",{j}],k]
