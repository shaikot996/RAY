(* ::Package:: *)
(* Exact, executable v1.2.0 dimension-independent warped-geometry tests.
   Run with installed package, or load RAYStandalone.wl first. *)
Needs["RAY`"];
ClearAll[d,n,t,A,B,C,L,ke,ki,lambda,RI,RE,x1,x2,y1,y2,z1,
  gwTest,gwLapse,gwGeneral,gwMulti,gwFlat,gwCurved,gwThree,gwReport,
  gwCases,gwCheck,gwTiming,gwSummary,gwReportTests];

SetAttributes[gwCheck,HoldRest];
gwTiming={};
gwCheck[id_String,expr_] := Module[{dt,res,pass},
 {dt,res}=AbsoluteTiming[Quiet@Check[expr,$Failed]];
 pass=TrueQ[res];
 AppendTo[gwTiming,<|"ID"->id,"Passed"->pass,"Seconds"->dt|>];
 VerificationTest[pass,True,TestID->id]
];

gwFlat=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,"InternalGeometry"->"Flat"];
gwCurved=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,"ExternalGeometry"->{"ConstantCurvature",ke},
 "InternalGeometry"->{"ConstantCurvature",ki}];
gwGeneral=RAYGeneralWarpedMetric[d,n,A[t],B[t],"Time"->t];
gwLapse=RAYGeneralWarpedMetric[d,n,A[t],B[t],
 "Time"->t,"Lapse"->L[t],
 "InternalGeometry"->{"ConstantCurvature",ki}];
gwMulti=RAYWarpedBlocks[
 {{"x",d-1,A[t],"Flat"},{"y",n,B[t],{"ConstantCurvature",ki}}},
 "Time"->t];
gwThree=RAYWarpedBlocks[
 {{"x",1,A[t],"Flat"},{"y",2,B[t],"Flat"},{"z",n,C[t],"General"}},
 "Time"->t];

m=d-1;
scalarFlat=2m A''[t]+2n B''[t]+m(m+1)A'[t]^2+
 n(n+1)B'[t]^2+2m n A'[t]B'[t];
ricttFlat=-m(A''[t]+A'[t]^2)-n(B''[t]+B'[t]^2);
extCoeffFlat=A''[t]+m A'[t]^2+n A'[t]B'[t];
intCoeffFlat=B''[t]+n B'[t]^2+m A'[t]B'[t];
hamFlat=1/2 (m(m-1)A'[t]^2+n(n-1)B'[t]^2+
 2m n A'[t] B'[t]);

gwCases={
 gwCheck["01-general-is-association",AssociationQ[gwFlat]],
 gwCheck["02-dimensions-symbolic",SameQ[gwFlat["TotalDimension"],d+n]],
 gwCheck["03-spatial-dimensions",SameQ[gwFlat["SpatialDimension"],d-1+n]],
 gwCheck["04-two-blocks",Length[gwFlat["Blocks"]]===2],
 gwCheck["05-name-external",gwFlat["Blocks"][[1,"Name"]]==="External"],
 gwCheck["06-name-internal",gwFlat["Blocks"][[2,"Name"]]==="Internal"],
 gwCheck["07-dim-external",SameQ[gwFlat["Blocks"][[1,"Dimension"]],d-1]],
 gwCheck["08-dim-internal",SameQ[gwFlat["Blocks"][[2,"Dimension"]],n]],
 gwCheck["09-ricci-tt-flat",TrueQ[FullSimplify[gwFlat["RicciTimeTime"]==ricttFlat]]],
 gwCheck["10-ricci-scalar-flat",TrueQ[FullSimplify[gwFlat["RicciScalar"]==scalarFlat]]],
 gwCheck["11-Hamiltonian-flat",TrueQ[FullSimplify[gwFlat["EinsteinTimeTime"]==hamFlat]]],
 gwCheck["12-external-Ricci-coefficient",
  TrueQ[FullSimplify[gwFlat["Blocks"][[1,"RicciCoefficient"]]==extCoeffFlat]]],
 gwCheck["13-internal-Ricci-coefficient",
  TrueQ[FullSimplify[gwFlat["Blocks"][[2,"RicciCoefficient"]]==intCoeffFlat]]],
 gwCheck["14-volume-factor",
  TrueQ[FullSimplify[gwFlat["VolumeFactor"]==Exp[m A[t]+n B[t]]]]],
 gwCheck["15-weighted-Hubble",
  TrueQ[FullSimplify[gwFlat["TotalHubble"]==m A'[t]+n B'[t]]]],
 gwCheck["16-curvature-scalar-two-factors",
  TrueQ[FullSimplify[
   gwCurved["RicciScalar"]-scalarFlat-
   m(m-1)ke Exp[-2 A[t]]-n(n-1)ki Exp[-2 B[t]]==0]]],
 gwCheck["17-curvature-hamiltonian",
  TrueQ[FullSimplify[
   gwCurved["EinsteinTimeTime"]-hamFlat-
   (m(m-1)ke Exp[-2 A[t]]+n(n-1)ki Exp[-2 B[t]])/2==0]]],
 gwCheck["18-curved-Ricci-time-unchanged",
  TrueQ[FullSimplify[gwCurved["RicciTimeTime"]==ricttFlat]]],
 gwCheck["19-external-curved-Ricci",
  TrueQ[FullSimplify[
   gwCurved["Blocks"][[1,"RicciTensor"]]-
   (m-1)ke RAYTensor["ExternalMetric",{RAYDown["i"],RAYDown["j"]}]-
   Exp[2A[t]]extCoeffFlat RAYTensor["ExternalMetric",{RAYDown["i"],RAYDown["j"]}]==0]]],
 gwCheck["20-internal-curved-Ricci",
  TrueQ[FullSimplify[
   gwCurved["Blocks"][[2,"RicciTensor"]]-
   (n-1)ki RAYTensor["InternalMetric",{RAYDown["i"],RAYDown["j"]}]-
   Exp[2B[t]]intCoeffFlat RAYTensor["InternalMetric",{RAYDown["i"],RAYDown["j"]}]==0]]],
 gwCheck["21-generic-intrinsic-placeholder",
   !FreeQ[gwGeneral["RicciScalar"],RAYIntrinsicScalar["Internal"]]],
 gwCheck["22-generic-Ricci-tensor-placeholder",
   !FreeQ[gwGeneral["Blocks"][[2,"RicciTensor"]],
    RAYTensor["InternalRicci",{RAYDown["i"],RAYDown["j"]}]]],
 gwCheck["23-intrinsic-curvature-weight",
   TrueQ[FullSimplify[
    gwGeneral["RicciScalar"]-scalarFlat-
      Exp[-2B[t]] RAYIntrinsicScalar["Internal"]==0]]],
 gwCheck["24-lapse-Ricci-tt",
  TrueQ[FullSimplify[
   gwLapse["RicciTimeTime"]-
   (-m(A''[t]+A'[t]^2-A'[t]L'[t]/L[t])-
     n(B''[t]+B'[t]^2-B'[t]L'[t]/L[t]))==0]]],
 gwCheck["25-lapse-Ricci-scalar",
  TrueQ[FullSimplify[
   gwLapse["RicciScalar"]-n(n-1)ki Exp[-2 B[t]]-
   (scalarFlat-2(m A'[t]+n B'[t])L'[t]/L[t])/L[t]^2==0]]],
 gwCheck["26-lapse-Einstein-time",
  TrueQ[FullSimplify[
   gwLapse["EinsteinTimeTime"]-
   hamFlat-(L[t]^2/2)n(n-1)ki Exp[-2B[t]]==0]]],
 gwCheck["27-lapse-volume",
  TrueQ[FullSimplify[
   gwLapse["VolumeFactor"]==L[t] Exp[m A[t]+n B[t]]]]],
 gwCheck["28-time-inference",
  RAYGeneralWarpedMetric[d,n,A[t],B[t],
   "InternalGeometry"->"Flat"]["Time"]===t],
 gwCheck["29-time-dimension-one",
  RAYGeneralWarpedMetric[2,1,A[t],B[t],
   "InternalGeometry"->"Flat"]["TotalDimension"]===3],
 gwCheck["30-internal-one-dimensional-curvature-zero",
  TrueQ[FullSimplify[
   (gwCurved["IntrinsicCurvatureContribution"]/.n->1/.ke->0)==0]]],
 gwCheck["31-external-one-dimensional-curvature-zero",
  TrueQ[FullSimplify[
   (gwCurved["IntrinsicCurvatureContribution"]/.d->2/.ki->0)==0]]],
 gwCheck["32-ten-dimensional-symbolic",
  (gwFlat["TotalDimension"]/.{d->4,n->6})===10],
 gwCheck["33-ten-dimensional-ricci-independent-computation",
  TrueQ[FullSimplify[
  (gwFlat["RicciScalar"]/.{d->4,n->6})-
  (6 A''[t]+12 B''[t]+12 A'[t]^2+42 B'[t]^2+
   36 A'[t]B'[t])==0]]],
 gwCheck["34-isotropic-warp-flat-limit",
  TrueQ[FullSimplify[
   (gwFlat["RicciScalar"]/.{A->B})-
   (2(m+n)B''[t]+(m+n)(m+n+1)B'[t]^2)==0]]],
 gwCheck["35-static-flat-is-zero",
  TrueQ[FullSimplify[
   (gwFlat["RicciScalar"]/.{A[t]->0,B[t]->0,
     Derivative[_][A][t]->0,Derivative[_][B][t]->0})==0]]],
 gwCheck["36-multi-block-two-agrees",
  TrueQ[FullSimplify[gwMulti["RicciScalar"]-
    (scalarFlat+n(n-1)ki Exp[-2B[t]])==0]]],
 gwCheck["37-multi-block-three-dimension",
  SameQ[gwThree["TotalDimension"],4+n]],
 gwCheck["38-multi-block-three-scalar",
  TrueQ[FullSimplify[
   gwThree["RicciScalar"]-
   (2 A''[t]+4 B''[t]+2n C''[t]+
    (A'[t]+2 B'[t]+n C'[t])^2+
    A'[t]^2+2 B'[t]^2+n C'[t]^2+
    Exp[-2C[t]] RAYIntrinsicScalar["z"])==0]]],
 gwCheck["39-multi-block-three-Hamiltonian",
  TrueQ[FullSimplify[
   gwThree["EinsteinTimeTime"]-
   ((A'[t]+2 B'[t]+n C'[t])^2-
     A'[t]^2-2 B'[t]^2-n C'[t]^2+
       Exp[-2C[t]]RAYIntrinsicScalar["z"])/2==0]]],
 gwCheck["40-Einstein-reference-geometry",
  TrueQ[FullSimplify[
   RAYGeneralWarpedMetric[d,n,A[t],B[t],"Time"->t,
    "InternalGeometry"->{"Einstein",lambda}]["RicciScalar"]-
   scalarFlat-n lambda Exp[-2 B[t]]==0]]],
 gwCheck["41-custom-intrinsic-scalar",
  TrueQ[FullSimplify[
   RAYGeneralWarpedMetric[d,n,A[t],B[t],"Time"->t,
    "InternalGeometry"->{"General",RI}]["RicciScalar"]-
   scalarFlat-RI Exp[-2B[t]]==0]]],
 gwCheck["42-flat-reference-Einstein-tensor",
  TrueQ[FullSimplify[
   gwFlat["Blocks"][[1,"EinsteinCoefficient"]]-
    extCoeffFlat+scalarFlat/2==0]]],
 gwCheck["43-integer-dimension-rejects-zero-n",
  Quiet[RAYGeneralWarpedMetric[4,0,A[t],B[t],"Time"->t]]===$Failed],
 gwCheck["44-integer-dimension-rejects-d-one",
  Quiet[RAYGeneralWarpedMetric[1,3,A[t],B[t],"Time"->t]]===$Failed],
 gwCheck["45-blocks-reject-zero-dimension",
  Quiet[RAYWarpedBlocks[{{"x",0,A[t],"Flat"}},"Time"->t]]===$Failed],
 gwCheck["46-blocks-reject-duplicate-names",
  Quiet[RAYWarpedBlocks[{{"x",2,A[t],"Flat"},{"x",1,B[t],"Flat"}},
   "Time"->t]]===$Failed],
 gwCheck["47-blocks-reject-geometry-name",
  Quiet[RAYWarpedBlocks[{{"x",2,A[t],"Unknown"}},"Time"->t]]===$Failed],
 gwCheck["48-lapse-rejects-zero",
  Quiet[RAYWarpedBlocks[{{"x",2,A[t],"Flat"}},"Time"->t,
    "Lapse"->0]]===$Failed],
 gwCheck["49-reports-readable",
  Head[RAYWarpedReport[gwFlat]]===Column],
 gwCheck["50-symbolic-alone-no-metric-activation",
  (RAYDefineMetric["WarpSentinel",{t,x1},DiagonalMatrix[{-1,1}]];
   RAYGeneralWarpedMetric[d,n,A[t],B[t],"Time"->t];
   RAYDimension[]===2)],
 gwCheck["51-bridge-5d-flat",
  (gwTest=RAYGeneralWarpedMetric[3,2,A[t],B[t],"Time"->t,
      "InternalGeometry"->"Flat"];
   RAYWarpedToComponents[gwTest,"WarpBridge5D",
     {{{x1,x2},IdentityMatrix[2]},
      {{y1,y2},IdentityMatrix[2]}}];
   RAYDimension[]===5)],
 gwCheck["52-bridge-5d-scalar",
  TrueQ[FullSimplify[RAYRaw["RicciScalar"]==gwTest["RicciScalar"]]]],
 gwCheck["53-bridge-5d-time-Ricci",
  TrueQ[FullSimplify[RAYRaw["Ricci","dd"][[1,1]]==
      gwTest["RicciTimeTime"]]]],
 gwCheck["54-bridge-5d-external-Ricci",
  TrueQ[FullSimplify[RAYRaw["Ricci","dd"][[2,2]]==
     Exp[2A[t]]gwTest["Blocks"][[1,"RicciCoefficient"]]]]],
 gwCheck["55-bridge-5d-internal-Ricci",
  TrueQ[FullSimplify[RAYRaw["Ricci","dd"][[4,4]]==
     Exp[2B[t]]gwTest["Blocks"][[2,"RicciCoefficient"]]]]],
 gwCheck["56-bridge-5d-Einstein-time",
  TrueQ[FullSimplify[RAYRaw["Einstein","dd"][[1,1]]==
      gwTest["EinsteinTimeTime"]]]],
 gwCheck["57-bridge-reject-symbolic-dimensions",
  Quiet[RAYWarpedToComponents[gwFlat,"BadSymbolicBridge",
     {{{x1,x2},IdentityMatrix[2]},{{y1,y2},IdentityMatrix[2]}}]]===$Failed],
 gwCheck["58-bridge-reject-missing-blocks",
  Quiet[RAYWarpedToComponents[gwTest,"MissingBridge",
     {{{x1,x2},IdentityMatrix[2]}}]]===$Failed],
 gwCheck["59-bridge-curved-internal-sphere",
  (gwTest=RAYGeneralWarpedMetric[3,2,A[t],B[t],"Time"->t,
   "InternalGeometry"->{"ConstantCurvature",1}];
   RAYWarpedToComponents[gwTest,"WarpSphere5D",
    {{{x1,x2},IdentityMatrix[2]},
     {{y1,y2},DiagonalMatrix[{1,Sin[y1]^2}]}},
    Assumptions->0<y1<Pi];
   RAYDimension[]===5)],
 gwCheck["60-bridge-sphere-scalar",
  TrueQ[FullSimplify[RAYRaw["RicciScalar"]==gwTest["RicciScalar"],
    Assumptions->0<y1<Pi]]],
 gwCheck["61-bridge-sphere-spatial-Ricci",
  TrueQ[FullSimplify[
   RAYRaw["Ricci","dd"][[4,4]]==
   1+Exp[2 B[t]]gwTest["Blocks"][[2,"RicciCoefficient"]],
   Assumptions->0<y1<Pi]]],
 gwCheck["62-bridge-variable-lapse",
  (gwTest=RAYGeneralWarpedMetric[2,1,A[t],B[t],
    "Time"->t,"Lapse"->L[t],"InternalGeometry"->"Flat"];
   RAYWarpedToComponents[gwTest,"WarpLapse3D",
     {{{x1},{{1}}},{{y1},{{1}}}}];
   RAYDimension[]===3)],
 gwCheck["63-bridge-lapse-Ricci-time",
  TrueQ[FullSimplify[RAYRaw["Ricci","dd"][[1,1]]==
    gwTest["RicciTimeTime"],Assumptions->L[t]>0]]],
 gwCheck["64-bridge-lapse-scalar",
  TrueQ[FullSimplify[RAYRaw["RicciScalar"]==gwTest["RicciScalar"],
    Assumptions->L[t]>0]]],
 gwCheck["65-bridge-lapse-Einstein",
  TrueQ[FullSimplify[RAYRaw["Einstein","dd"][[1,1]]==
    gwTest["EinsteinTimeTime"],Assumptions->L[t]>0]]]
};

gwReportTests=TestReport[gwCases];
gwSummary=<|
 "Total"->Length[gwTiming],
 "Passed"->Count[gwTiming[[All,"Passed"]],True],
 "Failed"->Count[gwTiming[[All,"Passed"]],False],
 "TotalSeconds"->Total[gwTiming[[All,"Seconds"]]],
 "Failures"->Select[gwTiming,!#["Passed"]&]|>;
gwSummary
