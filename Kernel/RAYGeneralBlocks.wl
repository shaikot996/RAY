(* ::Package:: *)
(* General orthogonal 2-block metric in arbitrary d+n dimensions:
   H_(mu nu)(x,y)=Exp[2A(x,y)] hatg_(mu nu)(x,y),
   Q_(mn)(x,y)=Exp[2B(x,y)] tildeg_(mn)(x,y).
   The reference metrics may each vary across BOTH coordinate sectors.
   Full metric is block diagonal, nondegenerate and torsion free.
   Abstract curvature identities are exact C/K decompositions.
   Riemann convention matches the component RAY engine. *)

Options[RAYGeneralBlockGeometry]={"DerivativeForm"->"Covariant"};
RAYGeneralBlockGeometry[d_,n_,A_,B_,OptionsPattern[]]:=Module[
 {mu="\[Mu]",nu="\[Nu]",m="m",nn="n",form=OptionValue["DerivativeForm"],
  H,Q,ricH,ricQ,ricM,scalar,einH,einQ},
 If[form=!="Covariant",
  Return[rayFail["RAYGeneralBlockGeometry: exact abstract C/K formulas currently use induced covariant derivatives; use \"DerivativeForm\"->\"Covariant\"."]]];
 If[(NumericQ[d]&&(!IntegerQ[d]||d<1))||
   (NumericQ[n]&&(!IntegerQ[n]||n<1)),
  Return[rayFail["RAYGeneralBlockGeometry: d and n must be positive dimensions."]]];
 H=RAYBlockTerm["HMetric",{mu,nu}];
 Q=RAYBlockTerm["QMetric",{m,nn}];
 (* H- and Q-covariant divergences include the appropriate connection
    on every relevant tensor slot. C and K are defined below. *)
 ricH=RAYBlockTerm["HRicci",{mu,nu}]-
  RAYBlockTerm["HCovDOfKTrace",{mu,nu}]-
  RAYBlockTerm["KSquare",{mu,nu}]-
  RAYBlockTerm["QDivC",{mu,nu}]-
  RAYBlockTerm["CTraceC",{mu,nu}]+
  2RAYBlockTerm["CSquare",{mu,nu}];
 ricQ=RAYBlockTerm["QRicci",{m,nn}]-
  RAYBlockTerm["QCovDOfCTrace",{m,nn}]-
  RAYBlockTerm["CSquareInternal",{m,nn}]-
  RAYBlockTerm["HDivK",{m,nn}]-
  RAYBlockTerm["KTraceK",{m,nn}]+
  2RAYBlockTerm["KSquareInternal",{m,nn}];
 ricM=RAYBlockTerm["HDivCUp",{mu,m}]-
  RAYBlockTerm["PartialCTrace",{mu,m}]+
  RAYBlockTerm["QDivKUp",{mu,m}]-
  RAYBlockTerm["PartialKTrace",{mu,m}]+
  RAYBlockTerm["KTraceC",{mu,m}]+
  RAYBlockTerm["CTraceK",{mu,m}]-
  2RAYBlockTerm["CKCross",{mu,m}];
 scalar=RAYBlockTrace["H",ricH]+RAYBlockTrace["Q",ricQ];
 einH=ricH-H scalar/2;
 einQ=ricQ-Q scalar/2;
 <|"Type"->"GeneralOrthogonalBlocks",
  "TotalDimension"->d+n,"ExternalDimension"->d,"InternalDimension"->n,
  "WarpA"->A,"WarpB"->B,"DerivativeForm"->form,
  "ExternalMetric"->H,"InternalMetric"->Q,
  "Metric"->"H=Exp[2A(x,y)] hat[g](x,y), Q=Exp[2B(x,y)] tilde[g](x,y)",
  "ReferenceMetricDependence"->"Both reference blocks may depend on all external and internal coordinates",
  "CDefinition"->RAYBlockTerm["CDefinition",{}],
  "KDefinition"->RAYBlockTerm["KDefinition",{}],
  "RicciExternal"->ricH,"RicciInternal"->ricQ,
  "RicciMixed"->ricM,"RicciScalar"->scalar,
  "EinsteinExternal"->einH,"EinsteinInternal"->einQ,
  "EinsteinMixed"->ricM|>
];

RAYBlockTerm /: MakeBoxes[RAYBlockTerm[type_String,indices_List],
 fmt:(StandardForm|TraditionalForm)]:=With[
 {b=SubscriptBox[StyleBox[Switch[type,
    "HMetric","H","QMetric","Q","HRicci","R[H]","QRicci","R[Q]",
    "HCovDOfKTrace","D[H] K","KSquare","Tr(K K)",
    "QDivC","Div[Q] C","CTraceC","Tr(C) C",
    "CSquare","C.C","QCovDOfCTrace","D[Q] C",
    "CSquareInternal","Tr(C C)","HDivK","Div[H] K",
    "KTraceK","Tr(K) K","KSquareInternal","K.K",
    "HDivCUp","Div[H] C","PartialCTrace","d Tr(C)",
    "QDivKUp","Div[Q] K","PartialKTrace","d Tr(K)",
    "KTraceC","Tr(K) C","CTraceK","Tr(C) K",
    "CKCross","C.K","CDefinition","C = (1/2) d_y H",
    "KDefinition","K = (1/2) d_x Q",_,type],FontSlant->"Italic"],
   RowBox[If[StringQ[#],# ,MakeBoxes[#,fmt]]&/@indices]]},
 InterpretationBox[b,RAYBlockTerm[type,indices],Editable->False]
];
RAYBlockTrace /: MakeBoxes[RAYBlockTrace[which_String,expr_],
 fmt:(StandardForm|TraditionalForm)]:=With[
 {b=RowBox[{"Tr[",which,"]","(",MakeBoxes[expr,fmt],")"}]},
 InterpretationBox[b,RAYBlockTrace[which,expr],Editable->False]
];

RAYGeneralBlockReport[g_Association]/;
 Lookup[g,"Type",None]==="GeneralOrthogonalBlocks":=
 Column[{Style["Arbitrary d+n orthogonal blocks, including time-dependent internal geometry",Bold,15],
 Grid[{{"Metric",g["Metric"]},
 {"C = (1/2) partial_m H",g["CDefinition"]},
 {"K = (1/2) partial_mu Q",g["KDefinition"]},
 {"External Ricci",RAYPretty[g["RicciExternal"]]},
 {"Internal Ricci",RAYPretty[g["RicciInternal"]]},
 {"Mixed Ricci",RAYPretty[g["RicciMixed"]]},
 {"Ricci scalar",RAYPretty[g["RicciScalar"]]},
 {"External Einstein",RAYPretty[g["EinsteinExternal"]]},
 {"Internal Einstein",RAYPretty[g["EinsteinInternal"]]},
 {"Mixed Einstein",RAYPretty[g["EinsteinMixed"]]}},
 Frame->All,Alignment->Left]}];

(* Explicit specialization and INDEPENDENT block curvature derivation:
   H and Q may each depend on ALL x and y.
   Each induced Levi-Civita connection differentiates its own block's
   coordinates only; cross-derivatives are K and C. *)
Options[RAYGeneralBlockToComponents]=Join[Options[RAYDefineMetric],
 {"Verify"->True}];

rayGBBlockCurvature[xs_List,ys_List,H_List,Q_List,ass_]:=Module[
 {d=Length[xs],n=Length[ys],h,q,hi,qi,ch,cq,C,K,Cu,Ku,
  Cr,Kr,Cup,Kup,re,ri,rm,scalar,einH,einQ,
  divC,divK,divCu,divKu,calc},
 h=Join[rayDTReference[xs,H,ass],<|"Coordinates"->xs|>];
 q=Join[rayDTReference[ys,Q,ass],<|"Coordinates"->ys|>];
 hi=h["Inverse"];qi=q["Inverse"];ch=h["Gamma"];cq=q["Gamma"];
 C=Table[D[H[[i,j]],ys[[m]]]/2,{m,n},{i,d},{j,d}];
 K=Table[D[Q[[p,r]],xs[[i]]]/2,{i,d},{p,n},{r,n}];
 Cu=Table[Sum[hi[[i,j]] C[[m,j,k]],{j,d}],
   {m,n},{i,d},{k,d}];
 Ku=Table[Sum[qi[[p,r]] K[[i,r,s]],{r,n}],
   {i,d},{p,n},{s,n}];
 Cr=Table[Sum[hi[[i,j]] C[[m,i,j]],{i,d},{j,d}],{m,n}];
 Kr=Table[Sum[qi[[p,r]] K[[i,p,r]],{p,n},{r,n}],{i,d}];
 Cup=Table[Sum[qi[[m,p]]C[[p,i,j]],{p,n}],
   {m,n},{i,d},{j,d}];
 Kup=Table[Sum[hi[[i,j]]K[[j,m,p]],{j,d}],
   {i,d},{m,n},{p,n}];
 divC=Table[Sum[
    D[Cup[[m,i,j]],ys[[m]]]+
    Sum[cq[[m,m,p]]Cup[[p,i,j]],{p,n}],{m,n}],
   {i,d},{j,d}];
 divK=Table[Sum[
    D[Kup[[i,m,p]],xs[[i]]]+
    Sum[ch[[i,i,j]]Kup[[j,m,p]],{j,d}],{i,d}],
   {m,n},{p,n}];
 divCu=Table[Sum[
    D[Cu[[m,i,j]],xs[[i]]]+
    Sum[ch[[i,i,k]]Cu[[m,k,j]]-
      ch[[k,i,j]]Cu[[m,i,k]],{k,d}],{i,d}],
   {m,n},{j,d}];
 divKu=Table[Sum[
    D[Ku[[i,p,m]],ys[[p]]]+
    Sum[cq[[p,p,q0]] Ku[[i,q0,m]]-
     cq[[q0,p,m]]Ku[[i,p,q0]],{q0,n}],{p,n}],
   {i,d},{m,n}];
 re=Table[
  h["Ricci"][[i,j]]-
    (D[Kr[[i]],xs[[j]]]-
     Sum[ch[[k,j,i]]Kr[[k]],{k,d}])-
    Sum[Ku[[i,p,q0]]Ku[[j,q0,p]],{p,n},{q0,n}]-
    divC[[i,j]]-
    Sum[Cr[[m]]Cup[[m,i,j]],{m,n}]+
    2Sum[qi[[m,p]]C[[m,i,r]]hi[[r,s]]C[[p,s,j]],
      {m,n},{p,n},{r,d},{s,d}],
   {i,d},{j,d}];
 ri=Table[
  q["Ricci"][[m,p]]-
    (D[Cr[[m]],ys[[p]]]-
     Sum[cq[[q0,p,m]]Cr[[q0]],{q0,n}])-
    Sum[Cu[[m,i,j]]Cu[[p,j,i]],{i,d},{j,d}]-
    divK[[m,p]]-
    Sum[Kr[[i]]Kup[[i,m,p]],{i,d}]+
    2Sum[hi[[i,j]]K[[i,m,q0]]qi[[q0,s]]K[[j,s,p]],
      {i,d},{j,d},{q0,n},{s,n}],
   {m,n},{p,n}];
 rm=Table[
    divCu[[m,i]]-D[Cr[[m]],xs[[i]]] +
    divKu[[i,m]]-D[Kr[[i]],ys[[m]]]+
    Sum[Kr[[j]]Cu[[m,j,i]],{j,d}]+
    Sum[Cr[[p]]Ku[[i,p,m]],{p,n}]-
    2Sum[Cu[[p,j,i]]Ku[[j,p,m]],{p,n},{j,d}],
   {i,d},{m,n}];
 re=FullSimplify[re,ass];ri=FullSimplify[ri,ass];
 rm=FullSimplify[rm,ass];
 scalar=FullSimplify[
   Sum[hi[[i,j]]re[[i,j]],{i,d},{j,d}]+
   Sum[qi[[m,p]]ri[[m,p]],{m,n},{p,n}],ass];
 <|"RicciExternal"->re,"RicciInternal"->ri,
  "RicciMixed"->rm,"RicciScalar"->scalar,
  "EinsteinExternal"->FullSimplify[re-H scalar/2,ass],
  "EinsteinInternal"->FullSimplify[ri-Q scalar/2,ass],
  "EinsteinMixed"->rm,
  "C"->C,"K"->K,"CTrace"->Cr,"KTrace"->Kr,
  "HInverse"->hi,"QInverse"->qi|>
];

RAYGeneralBlockToComponents[model_Association,name_String,
 xs_List,ys_List,hat_List,tilde_List,OptionsPattern[]]:=Module[
 {d=Length[xs],n=Length[ys],all=Join[xs,ys],
  a=model["WarpA"],b=model["WarpB"],ass=OptionValue[Assumptions],
  H,Q,full,ret,block,ric,rs,ein,resid,verified},
 If[Lookup[model,"Type",None]=!="GeneralOrthogonalBlocks",
  Return[rayFail["RAYGeneralBlockToComponents: invalid model."]]];
 If[model["ExternalDimension"]=!=d||model["InternalDimension"]=!=n||
    Dimensions[hat]=!={d,d}||Dimensions[tilde]=!={n,n}||
    Length[DeleteDuplicates[all]]=!=Length[all],
  Return[rayFail["RAYGeneralBlockToComponents: coordinate and matrix dimensions must match concrete d,n."]]];
 If[!TrueQ[FullSimplify[Transpose[hat]==hat,ass]]||
    !TrueQ[FullSimplify[Transpose[tilde]==tilde,ass]],
  Return[rayFail["RAYGeneralBlockToComponents: both reference metrics must be symmetric."]]];
 If[!TrueQ[FullSimplify[Det[hat]!=0&&Det[tilde]!=0,ass]],
  Return[rayFail["RAYGeneralBlockToComponents: reference metrics must be nondegenerate under supplied assumptions."]]];
 H=Exp[2a]hat;Q=Exp[2b]tilde;
 block=rayGBBlockCurvature[xs,ys,H,Q,ass];
 full=ArrayFlatten[{{H,ConstantArray[0,{d,n}]},
   {ConstantArray[0,{n,d}],Q}}];
 ret=RAYDefineMetric[name,all,full,Assumptions->ass,
   "Simplification"->OptionValue["Simplification"]];
 If[ret===$Failed,Return[$Failed]];
 ric=RAYRaw["Ricci","dd"];rs=RAYRaw["RicciScalar"];
 ein=RAYRaw["Einstein","dd"];
 resid=<|
   "RicciExternal"->FullSimplify[ric[[1;;d,1;;d]]-block["RicciExternal"],ass],
   "RicciInternal"->FullSimplify[ric[[d+1;;d+n,d+1;;d+n]]-block["RicciInternal"],ass],
   "RicciMixed"->FullSimplify[ric[[1;;d,d+1;;d+n]]-block["RicciMixed"],ass],
   "RicciScalar"->FullSimplify[rs-block["RicciScalar"],ass],
   "EinsteinExternal"->FullSimplify[ein[[1;;d,1;;d]]-block["EinsteinExternal"],ass],
   "EinsteinInternal"->FullSimplify[ein[[d+1;;d+n,d+1;;d+n]]-block["EinsteinInternal"],ass],
   "EinsteinMixed"->FullSimplify[ein[[1;;d,d+1;;d+n]]-block["EinsteinMixed"],ass]|>;
 verified=If[TrueQ[OptionValue["Verify"]],
   And@@(TrueQ[FullSimplify[#==0,ass]]||
    TrueQ[FullSimplify[#==ConstantArray[0,Dimensions[#]],ass]]& /@
    Values[resid]),Missing["NotRequested"]];
 <|"Type"->"GeneralOrthogonalBlockComponents",
  "Name"->name,"TotalDimension"->d+n,"Coordinates"->all,
  "Metric"->full,"RicciTensor"->ric,"RicciScalar"->rs,
  "EinsteinTensor"->ein,
  "RicciExternal"->ric[[1;;d,1;;d]],
  "RicciInternal"->ric[[d+1;;d+n,d+1;;d+n]],
  "RicciMixed"->ric[[1;;d,d+1;;d+n]],
  "InducedC"->block["C"],"InducedK"->block["K"],
  "Derived"->block,"Residuals"->resid,
  "Verified"->verified|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYGeneralBlockGeometry[d,n,A,B]","Exact d+n Ricci and Einstein tensor decompositions for H=exp(2A) hat[g](x,y), Q=exp(2B) tilde[g](x,y), with arbitrary reference metric variation."},
 {"RAYGeneralBlockToComponents[model,name,x,y,hatg,tildeg]","Evaluate H/Q internal and external derivatives, Ricci and Einstein blocks, independently verifying all tensor components."},
 {"RAYGeneralBlockReport[model]","Display exact abstract C/K-based general curvature formulas."}
}];
