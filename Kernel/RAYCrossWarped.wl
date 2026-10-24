(* ::Package:: *)
(* Paper-style crossed double warp: e^(2 A(y)) hat g_mu nu(x) +
   e^(2 B(x)) tilde g_mn(y). Exact for independent base/fiber
   geometries, any symbolic dimensions d+n and orthogonal blocks.
   Both A and B are scalars on their own reference manifolds.
   The Riemann sign follows the core RAY convention. *)

Options[RAYCrossWarpedGeometry]={"DerivativeForm"->"Covariant",
  "Simplification"->"Simplify"};

RAYCrossWarpedGeometry[d_,n_,internalWarp_,externalWarp_,
  OptionsPattern[]] := Module[
 {form=OptionValue["DerivativeForm"],aa=internalWarp,bb=externalWarp,
  hmu="μ",hnu="ν",tm="m",tn="n",RH,RT,gh,gt,
  boxH,boxT,normH,normT,hessH,hessT,gradH1,gradH2,gradT1,gradT2,
  ricH,ricT,ricMix,ricScalar,einH,einT,einMix,
  hSquare,tSquare,formHess},
 If[!MemberQ[{"Covariant","Partial"},form],
   Return[rayFail[
    "RAYCrossWarpedGeometry: \"DerivativeForm\" must be \"Covariant\" or \"Partial\"."]]];
 If[NumericQ[d]&&(!IntegerQ[d]||d<1)||
    NumericQ[n]&&(!IntegerQ[n]||n<1),
   Return[rayFail["RAYCrossWarpedGeometry: d and n must be positive dimensions."]]];
 RH=RAYFrameTensor["Hat","Ricci",{hmu,hnu}];
 RT=RAYFrameTensor["Tilde","Ricci",{tm,tn}];
 gh=RAYFrameTensor["Hat","Metric",{hmu,hnu}];
 gt=RAYFrameTensor["Tilde","Metric",{tm,tn}];
 boxH=If[form==="Covariant",
   RAYFrameBox["Hat",bb],RAYFramePartialBox["Hat",bb]];
 boxT=If[form==="Covariant",
   RAYFrameBox["Tilde",aa],RAYFramePartialBox["Tilde",aa]];
 normH=RAYFrameNorm["Hat",bb];
 normT=RAYFrameNorm["Tilde",aa];
 hessH=If[form==="Covariant",
   RAYFrameHessian["Hat",hmu,hnu,bb],
   RAYFramePartialHessian["Hat",hmu,hnu,bb]-
   RAYFrameConnectionTerm["Hat",hmu,hnu,bb]];
 hessT=If[form==="Covariant",
   RAYFrameHessian["Tilde",tm,tn,aa],
   RAYFramePartialHessian["Tilde",tm,tn,aa]-
   RAYFrameConnectionTerm["Tilde",tm,tn,aa]];
 gradH1=RAYFramePartial["Hat",hmu,bb];
 gradH2=RAYFramePartial["Hat",hnu,bb];
 gradT1=RAYFramePartial["Tilde",tm,aa];
 gradT2=RAYFramePartial["Tilde",tn,aa];
 ricH=RH-n (hessH+gradH1 gradH2)-
    gh Exp[2 aa-2 bb](boxT+d normT);
 ricT=RT-d (hessT+gradT1 gradT2)-
    gt Exp[2 bb-2 aa](boxH+n normH);
 ricMix=(d+n-2)gradH1 gradT1;
 ricScalar=Exp[-2aa]RAYFrameScalar["Hat","Ricci"]+
    Exp[-2bb]RAYFrameScalar["Tilde","Ricci"]-
    n Exp[-2aa](2 boxH+(n+1)normH)-
    d Exp[-2bb](2 boxT+(d+1)normT);
 einH=RAYFrameTensor["Hat","Einstein",{hmu,hnu}]-
    n(hessH+gradH1 gradH2)+
    n gh (boxH+(n+1)/2 normH)+
    Exp[2aa-2bb]gh ((d-1)boxT+d(d-1)/2 normT-
      1/2 RAYFrameScalar["Tilde","Ricci"]);
 einT=RAYFrameTensor["Tilde","Einstein",{tm,tn}]-
    d(hessT+gradT1 gradT2)+
    d gt (boxT+(d+1)/2 normT)+
    Exp[2bb-2aa]gt ((n-1)boxH+n(n-1)/2 normH-
      1/2 RAYFrameScalar["Hat","Ricci"]);
 einMix=ricMix;
 <|"Type"->"CrossWarpedGeometry","ExternalDimension"->d,
   "InternalDimension"->n,"TotalDimension"->d+n,
   "ExternalWarp"->aa,"InternalWarp"->bb,
   "Metric"->"Exp[2 A(y)] hat[g](x) + Exp[2 B(x)] tilde[g](y)",
   "DerivativeForm"->form,
   "RicciExternal"->ricH,"RicciInternal"->ricT,
   "RicciMixed"->ricMix,"RicciScalar"->ricScalar,
   "EinsteinExternal"->einH,"EinsteinInternal"->einT,
   "EinsteinMixed"->einMix,
   "ExternalBox"->boxH,"InternalBox"->boxT,
   "ExternalGradientSquared"->normH,
   "InternalGradientSquared"->normT|>
];

(* Exact partial-to-covariant conversion.  Partial covariant Hessian
   = partial_mu partial_nu f - Gamma^rho_mu nu partial_rho f,
   while the Laplace-Beltrami box is the inverse-metric trace. *)
RAYCrossToCovariant[expression_] :=
 Expand[expression /. {
  HoldPattern[RAYFramePartialHessian[f_,i_,j_,phi_]] :>
   RAYFrameHessian[f,i,j,phi]+RAYFrameConnectionTerm[f,i,j,phi],
  HoldPattern[RAYFramePartialBox[f_,phi_]] :>
   RAYFrameBox[f,phi]
 }] // Expand;

(* Input notation is an intentional display policy, not a rewrite of
   any computed tensor's interpretation. *)
rayCrossAccent[name_] := If[name==="Hat","^","~"];
rayCrossSymbol[name_,type_] :=
  OverscriptBox[
   StyleBox[Switch[type,"Ricci","R","Einstein","G",
    "Metric","g",_ ,type],FontSlant->"Italic"],
   rayCrossAccent[name]];

rayCrossIndices[i_List,fmt_] :=
 RowBox[Map[If[StringQ[#],#,
    MakeBoxes[#,fmt]]&,i]];

RAYFrameTensor /: MakeBoxes[RAYFrameTensor[frame_String,
   type_String, indices_List],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=SubscriptBox[rayCrossSymbol[frame,type],
    rayCrossIndices[indices,fmt]]},
   InterpretationBox[boxes,RAYFrameTensor[frame,type,indices],
   Editable->False]];

RAYFrameScalar /: MakeBoxes[
 RAYFrameScalar[frame_String,type_String],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=rayCrossSymbol[frame,type]},
  InterpretationBox[boxes,RAYFrameScalar[frame,type],Editable->False]];

rayCrossOperator[frame_,"Nabla"] :=
 OverscriptBox["\[Del]",rayCrossAccent[frame]];
rayCrossOperator[frame_,"Partial"] := "\[PartialD]";
rayCrossOperator[frame_,"Box"] :=
 OverscriptBox["\[EmptySquare]",rayCrossAccent[frame]];

RAYFramePartial /: MakeBoxes[RAYFramePartial[frame_String,
 idx_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{SubscriptBox[
   rayCrossOperator[frame,"Partial"],If[StringQ[idx],idx,
   MakeBoxes[idx,fmt]]],MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartial[frame,idx,expr],Editable->False]];

RAYFrameHessian /: MakeBoxes[RAYFrameHessian[frame_String,
  i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubscriptBox[rayCrossOperator[frame,"Nabla"],
    If[StringQ[i],i,MakeBoxes[i,fmt]]],
  SubscriptBox[rayCrossOperator[frame,"Nabla"],
    If[StringQ[j],j,MakeBoxes[j,fmt]]],MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFrameHessian[frame,i,j,expr],
   Editable->False]];

RAYFramePartialHessian /: MakeBoxes[RAYFramePartialHessian[
 frame_String,i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubscriptBox[rayCrossOperator[frame,"Partial"],i],
  SubscriptBox[rayCrossOperator[frame,"Partial"],j],
   MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartialHessian[frame,i,j,expr],
  Editable->False]];

RAYFrameConnectionTerm /: MakeBoxes[RAYFrameConnectionTerm[
 frame_String,i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubsuperscriptBox[OverscriptBox["\[CapitalGamma]",rayCrossAccent[frame]],
    RowBox[{i,j}],"\[Rho]"],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"\[Rho]"],
  MakeBoxes[expr,fmt]}]},
 InterpretationBox[boxes,RAYFrameConnectionTerm[frame,i,j,expr],
 Editable->False]];

RAYFrameBox /: MakeBoxes[RAYFrameBox[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{rayCrossOperator[frame,"Box"],
    MakeBoxes[expr,fmt]}]},
   InterpretationBox[boxes,RAYFrameBox[frame,expr],Editable->False]];

RAYFramePartialBox /: MakeBoxes[RAYFramePartialBox[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],
    RowBox[{"a","b"}]],
  "(",SubscriptBox[rayCrossOperator[frame,"Partial"],"a"],
    SubscriptBox[rayCrossOperator[frame,"Partial"],"b"],
    "-",SubsuperscriptBox[
     OverscriptBox["\[CapitalGamma]",rayCrossAccent[frame]],
     RowBox[{"a","b"}],"c"],
   SubscriptBox[rayCrossOperator[frame,"Partial"],"c"],
  ")",MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartialBox[frame,expr],
   Editable->False]];

RAYFrameNorm /: MakeBoxes[RAYFrameNorm[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],
    RowBox[{"a","b"}]],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"a"],
   MakeBoxes[expr,fmt],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"b"],
   MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFrameNorm[frame,expr],
  Editable->False]];

(* Paper-style grouped equations; component matrix calculations belong to
   RAYCovariantWarpedMetric or RAYDefineMetric. *)
RAYCrossWarpedReport[model_Association] /;
 Lookup[model,"Type",None]==="CrossWarpedGeometry" :=
 Column[{
  Style["Crossed double warp: exact d+n tensor identities",Bold,15],
  Grid[{
   {"External Ricci",RAYPretty[model["RicciExternal"]]},
   {"Internal Ricci",RAYPretty[model["RicciInternal"]]},
   {"Mixed Ricci",RAYPretty[model["RicciMixed"]]},
   {"Ricci scalar",RAYPretty[model["RicciScalar"]]},
   {"External Einstein",RAYPretty[model["EinsteinExternal"]]},
   {"Internal Einstein",RAYPretty[model["EinsteinInternal"]]},
   {"Mixed Einstein",RAYPretty[model["EinsteinMixed"]]}
  },Frame->All,Alignment->Left]
 }];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYCrossWarpedGeometry[d,n,A,B]","Exact Appendix-C-style crossed double warped tensors with d,n symbolic and covariant/partial derivative notation."},
 {"RAYCrossToCovariant[expr]","Translate the partial-plus-connection representation to covariant-form tensor expressions."},
 {"RAYCrossWarpedReport[model]","Display Ricci and Einstein block equations in paper-style symbolic notation."}
}];
