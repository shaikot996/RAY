(* RAY 1.3.0 crossed double-warp: arXiv:2512.19793 Appendix C. *)
Needs["RAY`"];
ClearAll[d,n,A,B,t,x,y,z,u,hatMetric,tildeMetric,fullMetric];
cov=RAYCrossWarpedGeometry[d,n,A,B];
par=RAYCrossWarpedGeometry[d,n,A,B,"DerivativeForm"->"Partial"];
crossKeys={"RicciExternal","RicciInternal","RicciMixed","RicciScalar",
 "EinsteinExternal","EinsteinInternal","EinsteinMixed"};
crossTests={
 VerificationTest[RAYVersion,"1.3.2",TestID->"01-version"],
 VerificationTest[cov["TotalDimension"],d+n,TestID->"02-symbolic-d+n"],
 VerificationTest[Length[crossKeys],7,TestID->"03-seven-geometric-sectors"],
 VerificationTest[AllTrue[crossKeys,KeyExistsQ[cov,#]&],True,
   TestID->"04-complete-tensor-sectors"],
 VerificationTest[AllTrue[crossKeys,
  Expand[RAYCrossToCovariant[par[#]]-cov[#]]===0&],
  True,TestID->"05-partial-converts-to-covariant-all-sectors"],
 VerificationTest[Head[RAYCrossWarpedReport[cov]],Column,
  TestID->"06-paper-style-report"],
 VerificationTest[Quiet[RAYCrossWarpedGeometry[d,n,A,B,
    "DerivativeForm"->"Unknown"]],$Failed,
  TestID->"07-invalid-derivative-option"],
 VerificationTest[Quiet[RAYCrossWarpedGeometry[0,n,A,B]],$Failed,
  TestID->"08-invalid-external-dimension"],
 VerificationTest[Quiet[RAYCrossWarpedGeometry[d,0,A,B]],$Failed,
  TestID->"09-invalid-internal-dimension"],
 VerificationTest[cov["RicciMixed"]/.{d->4,n->6},
  8RAYFramePartial["Hat","μ",B]RAYFramePartial["Tilde","m",A],
  TestID->"10-paper-C25-mixed-8"],
 VerificationTest[
  Coefficient[cov["RicciScalar"],RAYFrameBox["Hat",B]]/.{d->4,n->6},
  -12 Exp[-2A],TestID->"11-paper-C26-external-box"],
 VerificationTest[
  Coefficient[cov["RicciScalar"],RAYFrameBox["Tilde",A]]/.{d->4,n->6},
  -8 Exp[-2B],TestID->"12-paper-C26-internal-box"],
 VerificationTest[
  Coefficient[cov["RicciScalar"],RAYFrameNorm["Hat",B]]/.{d->4,n->6},
  -42 Exp[-2A],TestID->"13-paper-C26-external-gradient"],
 VerificationTest[
  Coefficient[cov["RicciScalar"],RAYFrameNorm["Tilde",A]]/.{d->4,n->6},
  -20 Exp[-2B],TestID->"14-paper-C26-internal-gradient"],
 VerificationTest[
  !FreeQ[ToBoxes[RAYFrameHessian["Hat","μ","ν",B],StandardForm],
    OverscriptBox["\[Del]","^"]],True,
  TestID->"15-hat-nabla-typeset"],
 VerificationTest[
  !FreeQ[ToBoxes[RAYFrameHessian["Tilde","m","n",A],StandardForm],
    OverscriptBox["\[Del]","~"]],True,
  TestID->"16-tilde-nabla-typeset"],
 VerificationTest[
  !FreeQ[ToBoxes[RAYFrameConnectionTerm["Hat","μ","ν",B],
    StandardForm],_SubsuperscriptBox],True,
  TestID->"17-partial-connection-present"],
 VerificationTest[
  SameQ[ToExpression[ToBoxes[RAYFrameHessian["Hat","μ","ν",B],
    StandardForm],StandardForm],
    RAYFrameHessian["Hat","μ","ν",B]],
  True,TestID->"18-nabla-copy-paste-roundtrip"],
 VerificationTest[
  SameQ[ToExpression[ToBoxes[RAYFramePartialBox["Tilde",A],
    StandardForm],StandardForm],
    RAYFramePartialBox["Tilde",A]],
  True,TestID->"19-partial-box-copy-paste-roundtrip"]
};
(* Independent full Levi-Civita component calculation in 4D,
   with nontrivial external curvature, internal S^2 curvature, A(y),
   B(t), both warped scale factors, and nonzero mixed Ricci. *)
hatMetric=DiagonalMatrix[{-1,Exp[2u[t]]}];
tildeMetric=DiagonalMatrix[{1,Sin[y]^2}];
RAYDefineMetric["CrossHat2",{t,x},hatMetric];
hatRic=RAYRaw["Ricci","dd"];hatSc=RAYRaw["RicciScalar"];
hatInv=RAYRaw["Metric","uu"];hatGamma=RAY`Private`rayGamma[];
RAYDefineMetric["CrossTilde2",{y,z},tildeMetric,Assumptions->0<y<Pi];
tildeRic=RAYRaw["Ricci","dd"];tildeSc=RAYRaw["RicciScalar"];
tildeInv=RAYRaw["Metric","uu"];tildeGamma=RAY`Private`rayGamma[];
hatGrad={D[B[t],t],D[B[t],x]};tildeGrad={D[A[y],y],D[A[y],z]};
hatHess=Table[D[B[t],{t,x}[[i]],{t,x}[[j]]]-
 Sum[hatGamma[[k,i,j]]hatGrad[[k]],{k,2}],{i,2},{j,2}];
tildeHess=Table[D[A[y],{y,z}[[i]],{y,z}[[j]]]-
 Sum[tildeGamma[[k,i,j]]tildeGrad[[k]],{k,2}],{i,2},{j,2}];
hatBox=Tr[hatInv.hatHess];tildeBox=Tr[tildeInv.tildeHess];
hatNorm=hatGrad.hatInv.hatGrad;tildeNorm=tildeGrad.tildeInv.tildeGrad;
expectedHat=hatRic-2(hatHess+Outer[Times,hatGrad,hatGrad])-
 Exp[2A[y]-2B[t]](tildeBox+2tildeNorm)hatMetric;
expectedTilde=tildeRic-2(tildeHess+Outer[Times,tildeGrad,tildeGrad])-
 Exp[2B[t]-2A[y]](hatBox+2hatNorm)tildeMetric;
expectedMixed=2Outer[Times,hatGrad,tildeGrad];
expectedScalar=Exp[-2A[y]]hatSc+Exp[-2B[t]]tildeSc-
 2Exp[-2A[y]](2hatBox+3hatNorm)-
 2Exp[-2B[t]](2tildeBox+3tildeNorm);
fullMetric=DiagonalMatrix[{-Exp[2A[y]],Exp[2A[y]+2u[t]],
 Exp[2B[t]],Exp[2B[t]]Sin[y]^2}];
RAYDefineMetric["CrossFull4D",{t,x,y,z},fullMetric,
 Assumptions->0<y<Pi];
directRic=RAYRaw["Ricci","dd"];
directSc=RAYRaw["RicciScalar"];
directEin=RAYRaw["Einstein","dd"];
expectedRic=ArrayFlatten[{
 {expectedHat,expectedMixed},
 {Transpose[expectedMixed],expectedTilde}}];
AppendTo[crossTests,VerificationTest[
 FullSimplify[directRic-expectedRic,Assumptions->0<y<Pi],
 ConstantArray[0,{4,4}],TestID->"20-independent-4D-entire-Ricci"]];
AppendTo[crossTests,VerificationTest[
 FullSimplify[directSc-expectedScalar,Assumptions->0<y<Pi],
 0,TestID->"21-independent-4D-Ricci-scalar"]];
AppendTo[crossTests,VerificationTest[
 FullSimplify[directEin-(expectedRic-fullMetric expectedScalar/2),
   Assumptions->0<y<Pi],
 ConstantArray[0,{4,4}],TestID->"22-independent-4D-entire-Einstein"]];
AppendTo[crossTests,VerificationTest[
 FullSimplify[directRic[[1,3]]-2B'[t]A'[y],Assumptions->0<y<Pi],
 0,TestID->"23-independent-nonzero-mixed"]];
AppendTo[crossTests,VerificationTest[
 FullSimplify[directEin[[1,3]]-directRic[[1,3]]],
 0,TestID->"24-mixed-Einstein-equals-Ricci"]];
AppendTo[crossTests,VerificationTest[
 FullSimplify[Tr[RAYRaw["Metric","uu"].directEin]+directSc],
 0,TestID->"25-independent-4D-trace"]];

(* 4+6 paper dimensions: reproduce both block formulas exactly,
   not only scalar coefficients. *)
paper=RAYCrossWarpedGeometry[4,6,A,B];
hG=RAYFrameTensor["Hat","Metric",{"μ","ν"}];
tG=RAYFrameTensor["Tilde","Metric",{"m","n"}];
paperExpectedH=RAYFrameTensor["Hat","Ricci",{"μ","ν"}]-
 6(RAYFrameHessian["Hat","μ","ν",B]+
 RAYFramePartial["Hat","μ",B]RAYFramePartial["Hat","ν",B])-
 hG Exp[2A-2B](RAYFrameBox["Tilde",A]+
 4RAYFrameNorm["Tilde",A]);
paperExpectedT=RAYFrameTensor["Tilde","Ricci",{"m","n"}]-
 4(RAYFrameHessian["Tilde","m","n",A]+
 RAYFramePartial["Tilde","m",A]RAYFramePartial["Tilde","n",A])-
 tG Exp[2B-2A](RAYFrameBox["Hat",B]+6RAYFrameNorm["Hat",B]);
AppendTo[crossTests,VerificationTest[
 Expand[paper["RicciExternal"]-paperExpectedH],0,
 TestID->"26-paper-C23-Ricci-external"]];
AppendTo[crossTests,VerificationTest[
 Expand[paper["RicciInternal"]-paperExpectedT],0,
 TestID->"27-paper-C24-Ricci-internal"]];
AppendTo[crossTests,VerificationTest[
 paper["EinsteinMixed"],paper["RicciMixed"],
 TestID->"28-paper-C22-mixed-Einstein"]];
AppendTo[crossTests,VerificationTest[
 Expand[RAYCrossToCovariant[
  RAYCrossWarpedGeometry[4,6,A,B,
   "DerivativeForm"->"Partial"]["EinsteinInternal"]]-
   paper["EinsteinInternal"]],0,
 TestID->"29-paper-C21-Einstein-partial-equivalent"]];
AppendTo[crossTests,VerificationTest[
 Head[RAYUpdateStandalone],Symbol,TestID->"30-updater-exposed"]];
AppendTo[crossTests,VerificationTest[
 Options[RAYUpdateStandalone],
 {"Destination"->Automatic,"VerifySHA256"->True},
 TestID->"31-updater-options-default-secure"]];


paperExpectedGH=RAYFrameTensor["Hat","Einstein",{"μ","ν"}]-
 6(RAYFrameHessian["Hat","μ","ν",B]+
 RAYFramePartial["Hat","μ",B]RAYFramePartial["Hat","ν",B])+
 3hG(2RAYFrameBox["Hat",B]+7RAYFrameNorm["Hat",B])+
 3hG Exp[2A-2B](RAYFrameBox["Tilde",A]+
   2RAYFrameNorm["Tilde",A])-
 1/2 hG Exp[2A-2B] RAYFrameScalar["Tilde","Ricci"];
paperExpectedGT=RAYFrameTensor["Tilde","Einstein",{"m","n"}]-
 4(RAYFrameHessian["Tilde","m","n",A]+
 RAYFramePartial["Tilde","m",A]RAYFramePartial["Tilde","n",A])+
 2tG(2RAYFrameBox["Tilde",A]+5RAYFrameNorm["Tilde",A])+
 5tG Exp[2B-2A](RAYFrameBox["Hat",B]+
   3RAYFrameNorm["Hat",B])-
 1/2 tG Exp[2B-2A] RAYFrameScalar["Hat","Ricci"];
paperExpectedScalar=Exp[-2A] RAYFrameScalar["Hat","Ricci"]+
 Exp[-2B]RAYFrameScalar["Tilde","Ricci"]-
 6Exp[-2A](2RAYFrameBox["Hat",B]+7RAYFrameNorm["Hat",B])-
 4Exp[-2B](2RAYFrameBox["Tilde",A]+5RAYFrameNorm["Tilde",A]);
AppendTo[crossTests,VerificationTest[
 Expand[paper["EinsteinExternal"]-paperExpectedGH],0,
 TestID->"32-paper-C20-external-Einstein"]];
AppendTo[crossTests,VerificationTest[
 Expand[paper["EinsteinInternal"]-paperExpectedGT],0,
 TestID->"33-paper-C21-internal-Einstein"]];
AppendTo[crossTests,VerificationTest[
 Expand[paper["RicciScalar"]-paperExpectedScalar],0,
 TestID->"34-paper-C26-Ricci-scalar"]];
AppendTo[crossTests,VerificationTest[
 RAYCrossToCovariant[
  RAYCrossWarpedGeometry[4,6,A,B,
   "DerivativeForm"->"Partial"]["RicciMixed"]]-
  paper["RicciMixed"],0,
 TestID->"35-paper-C25-partial-mixed"]];

crossReport=TestReport[crossTests];
crossSummary=<|"Total"->Length[crossTests],
 "Passed"->Length[crossReport[[1]]["TestsSucceededKeys"]],
 "Failed"->Length[crossReport[[1]]["TestsFailedWrongResultsKeys"]]+
 Length[crossReport[[1]]["TestsFailedWithMessagesKeys"]]|>;
crossSummary
