(* ::Package:: *)
(* RAY timed functional benchmarks: run from an installed RAY directory with
   Get[".../Tests/RAY_Benchmarks.wl"]. Each case is executed, timed and
   independently verified in a Wolfram kernel. Times depend on hardware. *)

Needs["RAY`"];
ClearAll[rayBench,benchmarkTimings,benchmarkCases,benchmarkReport,
 t,x,y,z,r,th,a,b,c,d,i,j,k,phi,V,F,E0,p,q,xx,yy,uu,bb,MM];

benchmarkTimings={};
SetAttributes[rayBench,HoldRest];
rayBench[id_String,expression_] := Module[{elapsed,result,passed},
  {elapsed,result}=AbsoluteTiming[
    Quiet[Check[expression,$Failed]]
  ];
  passed=TrueQ[result];
  AppendTo[benchmarkTimings,
    <|"ID"->id,"Seconds"->elapsed,"Passed"->passed|>];
  VerificationTest[passed,True,TestID->id]
];

benchmarkCases={

(* Explicit geometry *)
 rayBench["01-flat-2D-Ricci",
  (RAYDefineMetric["BMink2",{t,x},DiagonalMatrix[{-1,1}]];
   RAYRaw["RicciScalar"]===0)],
 rayBench["02-flat-3D-Christoffel",
  (RAYDefineMetric["BMink3",{t,x,y},DiagonalMatrix[{-1,1,1}]];
   RAYRaw["Christoffel"]===ConstantArray[0,{3,3,3}])],
 rayBench["03-flat-4D-Riemann",
  (RAYDefineMetric["BMink4",{t,x,y,z},DiagonalMatrix[{-1,1,1,1}]];
   RAYRaw["Riemann","uddd"]===ConstantArray[0,{4,4,4,4}])],
 rayBench["04-flat-5D-Ricci",
  (RAYDefineMetric["BMink5",{t,x,y,z,r},DiagonalMatrix[{-1,1,1,1,1}]];
   RAYRaw["Ricci","dd"]===ConstantArray[0,{5,5}])],
 rayBench["05-two-sphere-scalar",
  (RAYDefineMetric["BSphere",{th,x},
    DiagonalMatrix[{1,Sin[th]^2}],Assumptions->0<th<Pi];
   TrueQ[FullSimplify[RAYRaw["RicciScalar"]==2]])],
 rayBench["06-two-sphere-Ricci",
  TrueQ[FullSimplify[RAYRaw["Ricci","dd"]==
    RAYRaw["Metric","dd"],Assumptions->0<th<Pi]]],
 rayBench["07-dimension",
  RAYDimension[]===2],
 rayBench["08-raw-full-call",
  SameQ[RAYRaw[RAYRicci["dd"]],RAYRaw["Ricci","dd"]]],
 rayBench["09-raw-bare-command",
  SameQ[RAYRaw[RAYRicci,"dd"],RAYRaw["Ricci","dd"]]],
 rayBench["10-raw-component",
  TrueQ[FullSimplify[RAYRaw[RAYRicci["dd",1,1]]-
    Sin[th]^2==0,Assumptions->0<th<Pi]]],
 rayBench["11-covariant-metric-zero",
  RAYCovD[RAYRaw["Metric","dd"],"dd"]===
    ConstantArray[0,{2,2,2}]],
 rayBench["12-covariant-inverse-zero",
  TrueQ[FullSimplify[RAYCovD[RAYRaw["Metric","uu"],"uu"]===
    ConstantArray[0,{2,2,2}]]]],
 rayBench["13-warped-product",
  (RAYWarpedMetric["BWarp",{
    {{t},{{-1}},1},{{x},{{1}},Exp[2 bb[t]]}
   }];
   RAYRaw["Metric","dd"]===
     DiagonalMatrix[{-1,Exp[2 bb[t]]}])],
 rayBench["14-warped-determinant",
  TrueQ[FullSimplify[RAYRaw["MetricDeterminant"]+
    Exp[2 bb[t]]==0]]],
 rayBench["15-GR-signature",
  Head[RAYConventions[]]===Grid],

(* Explicit matter variation *)
 rayBench["16-matter-scalar-energy",
  (RAYDefineMetric["BScalar",{t,x},DiagonalMatrix[{-1,1}]];
   RAYMatterAction[RAYScalarLagrangian[phi[t,x],V[phi[t,x]]]];
   TrueQ[FullSimplify[RAYRaw["StressTensor","dd"][[1,1]]==
     (D[phi[t,x],t]^2+D[phi[t,x],x]^2)/2+
       V[phi[t,x]]]])],
 rayBench["17-matter-scalar-flux",
  TrueQ[FullSimplify[
    RAYRaw["StressTensor","dd"][[1,2]]==
    D[phi[t,x],t] D[phi[t,x],x]]]],
 rayBench["18-matter-scalar-symmetry",
  TrueQ[FullSimplify[RAYRaw["StressTensor","dd"]==
    Transpose[RAYRaw["StressTensor","dd"]]]]],
 rayBench["19-matter-Maxwell-electric",
  (RAYMatterAction[RAYMaxwellLagrangian[{{0,E0},{-E0,0}}]];
   TrueQ[FullSimplify[
    RAYRaw["StressTensor","dd"][[1,1]]==E0^2/2]])],
 rayBench["20-matter-Maxwell-pressure",
  TrueQ[FullSimplify[
    RAYRaw["StressTensor","dd"][[2,2]]==-E0^2/2]]],
 rayBench["21-Einstein-vacuum",
  (RAYDefineMetric["BVac",{t,x},DiagonalMatrix[{-1,1}]];
   RAYEinsteinEquations[RAYRaw["Einstein","dd"]]==={})],
 rayBench["22-Einstein-Lambda",
  (p=RAYEinsteinEquations[RAYRaw["Einstein","dd"],0,
   "CosmologicalConstant"->3,"Components"->"Diagonal"];
   Length[p]===2 && p[[1]]===(-3==0) && p[[2]]===(3==0))],
 rayBench["23-Einstein-association",
  AssociationQ[RAYEinsteinEquations[RAYRaw["Einstein","dd"],
   0,"Return"->"Association"]]],

(* Abstract index algebra *)
 rayBench["24-antisym-declare",
  RAYDeclareSymmetry["BF","Antisymmetric"]==="BF"],
 rayBench["25-antisym-swap",
  RAYCanonicalize[
    RAYTensor["BF",{RAYDown[a],RAYDown[b]}]+
    RAYTensor["BF",{RAYDown[b],RAYDown[a]}]]===0],
 rayBench["26-antisym-diagonal",
  RAYCanonicalize[RAYTensor["BF",{RAYDown[a],RAYDown[a]}]]===0],
 rayBench["27-metric-symmetric",
  RAYCanonicalize[
    RAYTensor["Metric",{RAYDown[a],RAYDown[b]}]-
    RAYTensor["Metric",{RAYDown[b],RAYDown[a]}]]===0],
 rayBench["28-Ricci-symmetric",
  RAYCanonicalize[
    RAYTensor["Ricci",{RAYDown[a],RAYDown[b]}]-
    RAYTensor["Ricci",{RAYDown[b],RAYDown[a]}]]===0],
 rayBench["29-Riemann-last-antisym",
  RAYCanonicalize[
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}]+
    RAYTensor["Riemann",RAYDown/@{a,b,d,c}]]===0],
 rayBench["30-Riemann-first-antisym",
  RAYCanonicalize[
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}]+
    RAYTensor["Riemann",RAYDown/@{b,a,c,d}]]===0],
 rayBench["31-Riemann-pair-exchange",
  RAYCanonicalize[
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}]-
    RAYTensor["Riemann",RAYDown/@{c,d,a,b}]]===0],
 rayBench["32-dummy-rename",
  RAYCanonicalize[
    RAYTensor["A",{RAYUp[i]}]RAYTensor["B",{RAYDown[i]}]-
    RAYTensor["A",{RAYUp[j]}]RAYTensor["B",{RAYDown[j]}]]===0],
 rayBench["33-invalid-repeated-variance",
  !TrueQ[RAYIndexCheck[
    RAYTensor["A",{RAYUp[i]}]RAYTensor["B",{RAYUp[i]}]]["Valid"]]],
 rayBench["34-valid-repeated-variance",
  TrueQ[RAYIndexCheck[
    RAYTensor["A",{RAYUp[i]}]RAYTensor["B",{RAYDown[i]}]]["Valid"]]],
 rayBench["35-delta-trace",
  RAYContract[
    RAYTensor["Delta",{RAYUp[a],RAYDown[a]}],
    "Dimension"->4]===4],
 rayBench["36-metric-raises-vector",
  RAYCanonicalize[
    RAYContract[
      RAYTensor["Metric",{RAYUp[a],RAYUp[b]}]*
      RAYTensor["V",{RAYDown[b]}],
      "Dimension"->4]]===
    RAYTensor["V",{RAYUp[a]}]],
 rayBench["37-delta-acts-on-vector",
  RAYContract[
    RAYTensor["Delta",{RAYUp[a],RAYDown[b]}]*
    RAYTensor["V",{RAYUp[b]}],
    "Dimension"->4]===
    RAYTensor["V",{RAYUp[a]}]],
 rayBench["38-metric-metric-trace",
  RAYContract[
    RAYTensor["Metric",{RAYUp[a],RAYUp[b]}]*
    RAYTensor["Metric",{RAYDown[a],RAYDown[b]}],
    "Dimension"->4]===4],
 rayBench["39-Riemann-contract-Ricci",
  RAYContract[RAYTensor["Riemann",
     {RAYUp[i],RAYDown[a],RAYDown[i],RAYDown[b]}],
    "Dimension"->4]===
    RAYCanonicalize[RAYTensor["Ricci",{RAYDown[a],RAYDown[b]}]]],
 rayBench["40-first-Bianchi",
  RAYBianchiReduce[
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}]+
    RAYTensor["Riemann",RAYDown/@{a,c,d,b}]+
    RAYTensor["Riemann",RAYDown/@{a,d,b,c}]]===0],
 rayBench["41-covD-metric-compatibility",
  RAYAbstractCovD[2RAYTensor["Metric",
   {RAYDown[a],RAYDown[b]}],c]===0],
 rayBench["42-curvature-commutator-scalar",
  RAYCovDCommutator[7,a,b]===0],
 rayBench["43-curvature-commutator-metric",
  RAYCovDCommutator[
    RAYTensor["Metric",{RAYDown[a],RAYDown[b]}],c,d]===0],
 rayBench["44-curvature-commutator-vector",
  RAYCovDCommutator[RAYTensor["V",{RAYUp[c]}],a,b]=!=0],
 rayBench["45-curvature-commutator-covector",
  RAYCovDCommutator[RAYTensor["W",{RAYDown[c]}],a,b]=!=0],

(* Abstract -> explicit bridge *)
 rayBench["46-to-components-metric",
  (RAYDefineMetric["BBridge",{r,th},
   DiagonalMatrix[{1,r^2}]];
   RAYToComponents[
    RAYTensor["Metric",{RAYDown[a],RAYDown[b]}],
    {RAYDown[a],RAYDown[b]}]===
      DiagonalMatrix[{1,r^2}])],
 rayBench["47-to-components-inverse",
  TrueQ[FullSimplify[RAYToComponents[
    RAYTensor["Metric",{RAYUp[a],RAYUp[b]}],
    {RAYUp[a],RAYUp[b]}]===DiagonalMatrix[{1,r^-2}]]]],
 rayBench["48-to-components-scalar-trace",
  RAYToComponents[RAYTensor["Delta",{RAYUp[a],RAYDown[a]}]]===2],
 rayBench["49-to-components-metric-trace",
  RAYToComponents[
    RAYTensor["Metric",{RAYUp[a],RAYUp[b]}]*
    RAYTensor["Metric",{RAYDown[a],RAYDown[b]}]]===2],
 rayBench["50-to-components-Ricci",
  RAYToComponents[
    RAYTensor["Ricci",{RAYDown[a],RAYDown[b]}],
    {RAYDown[a],RAYDown[b]}]===ConstantArray[0,{2,2}]],
 rayBench["51-symbolic-metric-descriptor",
  AssociationQ[RAYSymbolicMetric["BAbstract",4,
    "Signature"->{-1,1,1,1}]]],
 rayBench["52-symbolic-diagonal-components",
  Dimensions[RAYSymbolicMetric["BDiag",
    {t,x},"Symmetry"->"Diagonal"]["Components"]]==={2,2}],

(* Numerical dynamics / plots *)
 rayBench["53-oscillator-single-IC",
  Module[{sol},
   sol=RAYSolve[{uu''[t]+uu[t]==0},{uu},{t,0,2},
      {uu[0]==0,uu'[0]==1}];
   AssociationQ[sol] &&
      Abs[N[uu[2]/.sol["Solutions"][[1]]]-Sin[2]]<10^-6]],
 rayBench["54-oscillator-multi-IC",
  Module[{sol,v},
   sol=RAYSolve[{uu''[t]+uu[t]==0},{uu},{t,0,2},
    {{uu[0]==0,uu'[0]==1},{uu[0]==1,uu'[0]==0}}];
   If[!AssociationQ[sol],Return[False]];
   v=(uu[2]/.#)&/@sol["Solutions"];
   Max[Abs[N[v-{Sin[2],Cos[2]}]]]<10^-6]],
 rayBench["55-plot-graphics",
  Module[{sol},
   sol=RAYSolve[{uu''[t]+uu[t]==0},{uu},{t,0,2},
      {{uu[0]==0,uu'[0]==1},{uu[0]==1,uu'[0]==0}}];
   MemberQ[{Legended,Graphics},
      Head[RAYPlot[sol,{uu[t],uu'[t]},
        "Colors"->{Red,Blue},"FrameLabel"->{"t","value"}]]]]],
 rayBench["56-solve-and-plot",
  Module[{sol},
   sol=RAYSolve[{uu''[t]+uu[t]==0},{uu},{t,0,2},
    {{uu[0]==0,uu'[0]==1},{uu[0]==1,uu'[0]==0}},
    "Plot"->True,"PlotFields"->{uu[t]}];
   AssociationQ[sol] && KeyExistsQ[sol,"Plot"]]],
 rayBench["57-deSitter-ODE",
  Module[{eq,sol,val},
   RAYDefineMetric["BdeSitter",{t,x,y,z},
     DiagonalMatrix[{-1,a[t]^2,a[t]^2,a[t]^2}]];
   eq=RAYEinsteinEquations[RAYRaw["Einstein","dd"],0,
    "CosmologicalConstant"->3,"Components"->{{1,1}}];
   sol=RAYSolve[eq,{a},{t,0,2},{a[0]==1,a'[0]==1}];
   If[!AssociationQ[sol],Return[False]];
   val=N[a[2]/.sol["Solutions"][[1]]];
   Abs[val-Exp[2]]<10^-5]]
};

benchmarkReport=TestReport[benchmarkCases];
benchmarkSummary=<|
 "Cases"->Length[benchmarkTimings],
 "Passed"->Count[benchmarkTimings[[All,"Passed"]],True],
 "Failed"->Count[benchmarkTimings[[All,"Passed"]],False],
 "TotalSeconds"->Total[benchmarkTimings[[All,"Seconds"]]],
 "MedianSeconds"->Median[benchmarkTimings[[All,"Seconds"]]],
 "Slowest"->TakeLargestBy[benchmarkTimings,#["Seconds"]&,5]
|>;
Print[benchmarkSummary];
benchmarkSummary
