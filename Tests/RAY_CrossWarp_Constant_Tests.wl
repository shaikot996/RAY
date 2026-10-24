(* Regression: constant factors in abstract crossed double warps.
   A=1 is an overall constant rescaling; A=0 means unit warp.
   No operator may act nontrivially on a numeric constant. *)
Needs["RAY`"];
ClearAll[d,n,t,x,y,z,A,B,c,u,ricH,ricT,hatg,tildeg,
 hatRic,hatScalar,hatInv,hatGamma,refRic,refScalar,
 grad,hess,box,norm,fullg,directR,directE,directS,
 refExpected,expectedScalar,expectedEin,constantChecks,
 constantReport,constantSummary];

a1=RAYCrossWarpedGeometry[4,6,1,B[t]];
p1=RAYCrossWarpedGeometry[4,6,1,B[t],
 "DerivativeForm"->"Partial"];
a0=RAYCrossWarpedGeometry[d,n,0,B[t]];
cField=RAYCrossWarpedGeometry[d,n,c,B[t]];
cConst=RAYCrossWarpedGeometry[d,n,c,B[t],
 "ConstantInternalWarp"->True];
bb1=RAYCrossWarpedGeometry[4,6,1,2];
fullConst=RAYCrossWarpedGeometry[4,6,1,2,
 "DerivativeForm"->"Partial"];

constantChecks={
 VerificationTest[RAYVersion,"1.3.2",TestID->"c01-version"],
 VerificationTest[a1["InternalWarpConstant"],True,
  TestID->"c02-numeric-constant-detection"],
 VerificationTest[a1["ExternalWarpConstant"],False,
  TestID->"c03-Bt-remains-dynamic"],
 VerificationTest[a1["InternalBox"],0,
  TestID->"c04-internal-box-constant-zero"],
 VerificationTest[a1["InternalGradientSquared"],0,
  TestID->"c05-internal-norm-constant-zero"],
 VerificationTest[a1["RicciMixed"],0,
  TestID->"c06-mixed-Ricci-zero"],
 VerificationTest[a1["EinsteinMixed"],0,
  TestID->"c07-mixed-Einstein-zero"],
 VerificationTest[FreeQ[a1["RicciExternal"],RAYFrameBox["Tilde",_]|RAYFrameNorm["Tilde",_]],
  True,TestID->"c08-external-Ricci-no-internal-derivatives"],
 VerificationTest[FreeQ[a1["RicciInternal"],RAYFrameHessian["Tilde",_,_,_]|RAYFramePartial["Tilde",_,_]],
  True,TestID->"c09-internal-Ricci-no-internal-derivatives"],
 VerificationTest[FreeQ[a1["RicciScalar"],RAYFrameBox["Tilde",_]|RAYFrameNorm["Tilde",_]],
  True,TestID->"c10-scalar-no-spurious-derivatives"],
 VerificationTest[a1["RicciScalar"],
  Exp[-2]RAYFrameScalar["Hat","Ricci"]+
   Exp[-2B[t]]RAYFrameScalar["Tilde","Ricci"]-
   6 Exp[-2](2RAYFrameBox["Hat",B[t]]+
    7RAYFrameNorm["Hat",B[t]]),
  TestID->"c11-Ricci-scalar-constant-A"],
 VerificationTest[a0["RicciMixed"],0,
  TestID->"c12-unit-warp-A0-mixed-zero"],
 VerificationTest[FreeQ[a0["RicciScalar"],RAYFrameBox["Tilde",_]|RAYFrameNorm["Tilde",_]],
  True,TestID->"c13-unit-warp-A0-derivatives-zero"],
 VerificationTest[FreeQ[cField["RicciScalar"],RAYFrameBox["Tilde",c]],
  False,TestID->"c14-symbolic-c-not-automatically-assumed-constant"],
 VerificationTest[cConst["InternalWarpConstant"],True,
  TestID->"c15-symbolic-c-explicit-constant-assumption"],
 VerificationTest[cConst["InternalBox"],0,
  TestID->"c16-symbolic-c-box-zero"],
 VerificationTest[cConst["RicciMixed"],0,
  TestID->"c17-symbolic-c-mixed-zero"],
 VerificationTest[FreeQ[cConst["RicciScalar"],RAYFrameNorm["Tilde",_]|RAYFrameBox["Tilde",_]],
  True,TestID->"c18-symbolic-c-norm-box-zero"],
 VerificationTest[bb1["RicciMixed"],0,
  TestID->"c19-both-constant-mixed-zero"],
 VerificationTest[FreeQ[bb1["RicciScalar"],_RAYFrameBox|_RAYFrameNorm],
  True,TestID->"c20-both-constant-curvature-only"],
 VerificationTest[fullConst["RicciMixed"],0,
  TestID->"c21-both-constant-partial-mixed-zero"],
 VerificationTest[RAYFramePartial["Hat","μ",1],0,
  TestID->"c22-formal-numeric-partial-zero"],
 VerificationTest[RAYFrameHessian["Tilde","m","n",1],0,
  TestID->"c23-formal-numeric-Hessian-zero"],
 VerificationTest[RAYFramePartialHessian["Tilde","m","n",1],0,
  TestID->"c24-formal-numeric-partial-Hessian-zero"],
 VerificationTest[RAYFrameConnectionTerm["Tilde","m","n",1],0,
  TestID->"c25-formal-constant-connection-zero"],
 VerificationTest[RAYFrameBox["Tilde",1],0,
  TestID->"c26-formal-numeric-Box-zero"],
 VerificationTest[RAYFramePartialBox["Tilde",1],0,
  TestID->"c27-formal-partial-Box-zero"],
 VerificationTest[RAYFrameNorm["Tilde",1],0,
  TestID->"c28-formal-constant-norm-zero"],
 VerificationTest[
  And@@(Expand[RAYCrossToCovariant[p1[#]]-a1[#]]===0& /@
   {"RicciExternal","RicciInternal","RicciMixed","RicciScalar",
    "EinsteinExternal","EinsteinInternal","EinsteinMixed"}),
  True,TestID->"c29-both-forms-exactly-equal-after-specializing-A1"]
};

(* Independent Levi-Civita calculation. 4D metric: 2D FLRW base
   multiplied by constant Exp[2 c], curved S2 fiber scaled by B(t).
   This checks ALL Ricci and Einstein tensor entries and scalar. *)
hatg=DiagonalMatrix[{-1,Exp[2u[t]]}];
tildeg=DiagonalMatrix[{1,Sin[y]^2}];
RAYDefineMetric["ConstantHat2D",{t,x},hatg];
hatRic=RAYRaw["Ricci","dd"];
hatScalar=RAYRaw["RicciScalar"];
hatInv=RAYRaw["Metric","uu"];
hatGamma=RAY`Private`rayGamma[];
RAYDefineMetric["ConstantTildeS2",{y,z},tildeg,Assumptions->0<y<Pi];
refRic=RAYRaw["Ricci","dd"];
refScalar=RAYRaw["RicciScalar"];
grad={D[B[t],t],D[B[t],x]};
hess=Table[D[B[t],{t,x}[[i]],{t,x}[[j]]]-
 Sum[hatGamma[[k,i,j]]grad[[k]],{k,2}],{i,2},{j,2}];
box=Tr[hatInv.hess];
norm=grad.hatInv.grad;
expectedHat=hatRic-2(hess+Outer[Times,grad,grad]);
expectedTilde=refRic-Exp[2B[t]-2c](box+2norm)tildeg;
refExpected=ArrayFlatten[{{expectedHat,ConstantArray[0,{2,2}]},
 {ConstantArray[0,{2,2}],expectedTilde}}];
expectedScalar=Exp[-2c]hatScalar+Exp[-2B[t]]refScalar-
 2Exp[-2c](2box+3norm);
fullg=DiagonalMatrix[{-Exp[2c],Exp[2c+2u[t]],
 Exp[2B[t]],Exp[2B[t]]Sin[y]^2}];
RAYDefineMetric["ConstantFull4D",{t,x,y,z},fullg,Assumptions->0<y<Pi];
directR=RAYRaw["Ricci","dd"];
directE=RAYRaw["Einstein","dd"];
directS=RAYRaw["RicciScalar"];
AppendTo[constantChecks,VerificationTest[
 FullSimplify[directR-refExpected,Assumptions->0<y<Pi],
 ConstantArray[0,{4,4}],TestID->"c30-full-4D-Ricci-independent"]];
AppendTo[constantChecks,VerificationTest[
 FullSimplify[directS-expectedScalar,Assumptions->0<y<Pi],
 0,TestID->"c31-full-4D-scalar-independent"]];
AppendTo[constantChecks,VerificationTest[
 FullSimplify[directE-(refExpected-fullg expectedScalar/2),
  Assumptions->0<y<Pi],
 ConstantArray[0,{4,4}],TestID->"c32-full-4D-Einstein-independent"]];
AppendTo[constantChecks,VerificationTest[
 FullSimplify[(directS-expectedScalar)/.c->1,Assumptions->0<y<Pi],
 0,TestID->"c33-constant-A1-substitution-consistency"]];

constantReport=TestReport[constantChecks];
constantSummary=<|"Total"->Length[constantChecks],
 "Passed"->Length[constantReport[[1]]["TestsSucceededKeys"]],
 "Failed"->Length[constantReport[[1]]["TestsFailedWrongResultsKeys"]]+
  Length[constantReport[[1]]["TestsFailedWithMessagesKeys"]]|>;
constantSummary
