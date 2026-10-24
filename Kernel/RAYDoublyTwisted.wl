(* ::Package:: *)
(* RAY General Doubly Twisted Product — independent A(x,y), B(x,y).
   Metric G=e^(2 A(x,y)) hat[g](x) (+) e^(2 B(x,y)) tilde[g](y).
   NO constraint on either warp's coordinate dependence.
   d,n symbolic; both reference geometries arbitrary nondegenerate.
   Curvature R^rho_(sigma mu nu) matches RAY.
   Reference: universal conformal transformation of twisted products. *)

Options[RAYDoubleWarpedGeometry]={"DerivativeForm"->"Covariant",
 "ConstantA"->False,"ConstantB"->False};

RAYFrameInner[_,a_?NumericQ,_]:=0;
RAYFrameInner[_,_,a_?NumericQ]:=0;
RAYFrameInner[frame_,a_,a_]:=RAYFrameNorm[frame,a];
RAYMixedPartial[_,_,field_?NumericQ]:=0;

RAYFrameInner /: MakeBoxes[
 RAYFrameInner[frame_String,a_,b_],fmt:(StandardForm|TraditionalForm)]:=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],RowBox[{"a","b"}]],
  SubscriptBox["\[PartialD]","a"],MakeBoxes[a,fmt],
  SubscriptBox["\[PartialD]","b"],MakeBoxes[b,fmt]}]},
  InterpretationBox[boxes,RAYFrameInner[frame,a,b],Editable->False]];
RAYMixedPartial /: MakeBoxes[
 RAYMixedPartial[i_,m_,field_],fmt:(StandardForm|TraditionalForm)]:=
 With[{boxes=RowBox[{
  SubscriptBox["\[PartialD]",If[StringQ[i],i,MakeBoxes[i,fmt]]],
  SubscriptBox["\[PartialD]",If[StringQ[m],m,MakeBoxes[m,fmt]]],
  MakeBoxes[field,fmt]}]},
  InterpretationBox[boxes,RAYMixedPartial[i,m,field],Editable->False]];

rayDTPartial[frame_,index_,field_,constant_]:=
 If[constant,0,RAYFramePartial[frame,index,field]];
rayDTHess[frame_,i_,j_,field_,constant_,form_]:=
 If[constant,0,If[form==="Covariant",RAYFrameHessian[frame,i,j,field],
   RAYFramePartialHessian[frame,i,j,field]-
    RAYFrameConnectionTerm[frame,i,j,field]]];
rayDTBox[frame_,field_,constant_,form_]:=
 If[constant,0,If[form==="Covariant",RAYFrameBox[frame,field],
   RAYFramePartialBox[frame,field]]];
rayDTNorm[frame_,field_,constant_]:=
 If[constant,0,RAYFrameNorm[frame,field]];
rayDTInner[frame_,a_,b_,ca_,cb_]:=
 If[ca||cb,0,If[SameQ[a,b],RAYFrameNorm[frame,a],
    RAYFrameInner[frame,a,b]]];
rayDTMixed[i_,m_,field_,constant_]:=
 If[constant,0,RAYMixedPartial[i,m,field]];

RAYDoubleWarpedGeometry[d_,n_,A_,B_,OptionsPattern[]]:=Module[
 {form=OptionValue["DerivativeForm"],ca,cb,
 mu="μ",nu="ν",m="m",nn="n",h="Hat",tt="Tilde",
 gh,gt,rh,rt,scH,scT,ha,hb,ta,tb,pa1,pa2,pb1,pb2,
 qa1,qa2,qb1,qb2,naH,nbH,naT,nbT,abH,abT,
 xaH,xbH,xaT,xbT,coefH,coefT,RE,RI,RM,RS,GE,GI},
 If[!MemberQ[{"Covariant","Partial"},form],
   Return[rayFail["RAYDoubleWarpedGeometry: DerivativeForm must be Covariant or Partial."]]];
 If[(NumericQ[d]&&(!IntegerQ[d]||d<1))||
    (NumericQ[n]&&(!IntegerQ[n]||n<1)),
   Return[rayFail["RAYDoubleWarpedGeometry: dimensions must be positive."]]];
 ca=TrueQ[OptionValue["ConstantA"]]||TrueQ[NumericQ[A]];
 cb=TrueQ[OptionValue["ConstantB"]]||TrueQ[NumericQ[B]];
 gh=RAYFrameTensor[h,"Metric",{mu,nu}];
 gt=RAYFrameTensor[tt,"Metric",{m,nn}];
 rh=RAYFrameTensor[h,"Ricci",{mu,nu}];
 rt=RAYFrameTensor[tt,"Ricci",{m,nn}];
 scH=RAYFrameScalar[h,"Ricci"];
 scT=RAYFrameScalar[tt,"Ricci"];
 ha=rayDTHess[h,mu,nu,A,ca,form];
 hb=rayDTHess[h,mu,nu,B,cb,form];
 ta=rayDTHess[tt,m,nn,A,ca,form];
 tb=rayDTHess[tt,m,nn,B,cb,form];
 pa1=rayDTPartial[h,mu,A,ca];pa2=rayDTPartial[h,nu,A,ca];
 pb1=rayDTPartial[h,mu,B,cb];pb2=rayDTPartial[h,nu,B,cb];
 qa1=rayDTPartial[tt,m,A,ca];qa2=rayDTPartial[tt,nn,A,ca];
 qb1=rayDTPartial[tt,m,B,cb];qb2=rayDTPartial[tt,nn,B,cb];
 naH=rayDTNorm[h,A,ca];nbH=rayDTNorm[h,B,cb];
 naT=rayDTNorm[tt,A,ca];nbT=rayDTNorm[tt,B,cb];
 abH=rayDTInner[h,A,B,ca,cb];
 abT=rayDTInner[tt,A,B,ca,cb];
 xaH=rayDTBox[h,A,ca,form];xbH=rayDTBox[h,B,cb,form];
 xaT=rayDTBox[tt,A,ca,form];xbT=rayDTBox[tt,B,cb,form];
 coefH=xaH+(d-2)naH+n abH+
    Exp[2A-2B](xaT+d naT+(n-2)abT);
 coefT=xbT+(n-2)nbT+d abT+
    Exp[2B-2A](xbH+n nbH+(d-2)abH);
 RE=rh-(d-2)ha-n hb+
    (d-2)pa1 pa2-n pb1 pb2+n(pa1 pb2+pb1 pa2)-gh coefH;
 RI=rt-(n-2)tb-d ta+
    (n-2)qb1 qb2-d qa1 qa2+d(qb1 qa2+qa1 qb2)-gt coefT;
 RM=-(d-1)rayDTMixed[mu,m,A,ca]-
    (n-1)rayDTMixed[mu,m,B,cb]+
    (d+n-2)pb1 qa1;
 RS=Exp[-2A](scH-2(d-1)xaH-2n xbH-
     (d-1)(d-2)naH-n(n+1)nbH-2n(d-2)abH)+
    Exp[-2B](scT-2d xaT-2(n-1)xbT-
     d(d+1)naT-(n-1)(n-2)nbT-2d(n-2)abT);
 GE=RE-Exp[2A] gh RS/2;
 GI=RI-Exp[2B] gt RS/2;
 <|"Type"->"GeneralDoubleWarpedGeometry",
  "ExternalDimension"->d,"InternalDimension"->n,"TotalDimension"->d+n,
  "WarpA"->A,"WarpB"->B,
  "ExternalWarp"->A,"InternalWarp"->B,
  "DerivativeForm"->form,
  "CoordinateDependence"->"Unrestricted external and internal dependence for both scalar warp functions",
  "ConstantA"->ca,"ConstantB"->cb,
  "Metric"->"Exp[2 A(x,y)] hat[g](x) + Exp[2 B(x,y)] tilde[g](y)",
  "RicciExternal"->RE,"RicciInternal"->RI,"RicciMixed"->RM,
  "RicciScalar"->RS,
  "EinsteinExternal"->GE,"EinsteinInternal"->GI,"EinsteinMixed"->RM,
  "ExternalBoxA"->xaH,"ExternalBoxB"->xbH,
  "InternalBoxA"->xaT,"InternalBoxB"->xbT,
  "ExternalGradientA"->naH,"ExternalGradientB"->nbH,
  "InternalGradientA"->naT,"InternalGradientB"->nbT|>
];

RAYDoubleWarpedReport[model_Association]/;
 Lookup[model,"Type",None]==="GeneralDoubleWarpedGeometry":=
 Column[{
  Style["General doubly twisted geometry: arbitrary A(x,y), B(x,y)",Bold,16],
  Grid[{
   {"Total dimension",model["TotalDimension"]},
   {"External Ricci",RAYPretty[model["RicciExternal"]]},
   {"Internal Ricci",RAYPretty[model["RicciInternal"]]},
   {"Mixed Ricci",RAYPretty[model["RicciMixed"]]},
   {"Ricci scalar",RAYPretty[model["RicciScalar"]]},
   {"External Einstein",RAYPretty[model["EinsteinExternal"]]},
   {"Internal Einstein",RAYPretty[model["EinsteinInternal"]]},
   {"Mixed Einstein",RAYPretty[model["EinsteinMixed"]]}
  },Frame->All,Alignment->Left]
 }];

(* Coordinate specialization bridges formal and component descriptions.
   Reference metrics remain independent; both warp fields can depend on
   every coordinate. These are actual full-metric tensors, not an ansatz. *)
Options[RAYDoubleWarpedToComponents]=Join[
 Options[RAYDefineMetric],{"Verify"->True}];

rayDTReference[coord_List,g_List,ass_]:=Module[
 {k=Length[coord],gi,ga,rc},
 gi=FullSimplify[Inverse[g],ass];
 ga=Table[FullSimplify[
   Sum[gi[[i,l]](D[g[[l,j]],coord[[m]]]+
     D[g[[l,m]],coord[[j]]]-D[g[[j,m]],coord[[l]]])/2,{l,k}],ass],
   {i,k},{j,k},{m,k}];
 rc=Table[FullSimplify[Sum[
    D[ga[[l,i,j]],coord[[l]]]-
    D[ga[[l,i,l]],coord[[j]]]+
    Sum[ga[[l,l,m]] ga[[m,i,j]]-
      ga[[l,j,m]]ga[[m,i,l]],{m,k}],{l,k}],ass],{i,k},{j,k}];
 <|"Metric"->g,"Inverse"->gi,"Gamma"->ga,"Ricci"->rc,
   "Scalar"->FullSimplify[Tr[gi.rc],ass]|>
];
rayDTField[coord_List,ref_Association,f_,ass_]:=Module[
 {k=Length[coord],grad,hess},
 grad=D[f,#]&/@coord;
 hess=Table[FullSimplify[
   D[f,coord[[i]],coord[[j]]]-
    Sum[ref["Gamma"][[l,i,j]]grad[[l]],{l,k}],ass],
   {i,k},{j,k}];
 <|"Gradient"->grad,"Hessian"->hess,
 "Box"->FullSimplify[Tr[ref["Inverse"].hess],ass],
 "Norm"->FullSimplify[grad.ref["Inverse"].grad,ass]|>
];
rayDTScalarProduct[a_Association,b_Association,ref_Association,ass_]:=
 FullSimplify[a["Gradient"].ref["Inverse"].b["Gradient"],ass];
rayDTBlock[hatRef_,tildeRef_,ehA_,ehB_,tiA_,tiB_,A_,B_,d_,n_,ass_]:=Module[
 {gha=hatRef["Metric"],gti=tildeRef["Metric"],
 pa=ehA["Gradient"],pb=ehB["Gradient"],
 qa=tiA["Gradient"],qb=tiB["Gradient"],
 hab=rayDTScalarProduct[ehA,ehB,hatRef,ass],
 tab=rayDTScalarProduct[tiA,tiB,tildeRef,ass],
 coefH,coefT,RH,RT,RM,scalar,gfull},
 coefH=ehA["Box"]+(d-2)ehA["Norm"]+n hab+
   Exp[2A-2B](tiA["Box"]+d tiA["Norm"]+(n-2)tab);
 coefT=tiB["Box"]+(n-2)tiB["Norm"]+d tab+
   Exp[2B-2A](ehB["Box"]+n ehB["Norm"]+(d-2)hab);
 RH=hatRef["Ricci"]-(d-2)ehA["Hessian"]-n ehB["Hessian"]+
   (d-2)Outer[Times,pa,pa]-n Outer[Times,pb,pb]+
   n(Outer[Times,pa,pb]+Outer[Times,pb,pa])-gha coefH;
 RT=tildeRef["Ricci"]-(n-2)tiB["Hessian"]-d tiA["Hessian"]+
   (n-2)Outer[Times,qb,qb]-d Outer[Times,qa,qa]+
   d(Outer[Times,qb,qa]+Outer[Times,qa,qb])-gti coefT;
 RM=-(d-1)Table[D[A,hatRef["Coordinates"][[i]],
     tildeRef["Coordinates"][[j]]],{i,d},{j,n}]-
   (n-1)Table[D[B,hatRef["Coordinates"][[i]],
     tildeRef["Coordinates"][[j]]],{i,d},{j,n}]+
   (d+n-2)Outer[Times,pb,qa];
 scalar=Exp[-2A](hatRef["Scalar"]-
   2(d-1)ehA["Box"]-2n ehB["Box"]-
   (d-1)(d-2)ehA["Norm"]-n(n+1)ehB["Norm"]-
   2n(d-2)hab)+
   Exp[-2B](tildeRef["Scalar"]-
   2d tiA["Box"]-2(n-1)tiB["Box"]-
   d(d+1)tiA["Norm"]-(n-1)(n-2)tiB["Norm"]-
   2d(n-2)tab);
 <|"RicciExternal"->FullSimplify[RH,ass],
  "RicciInternal"->FullSimplify[RT,ass],
  "RicciMixed"->FullSimplify[RM,ass],
  "RicciScalar"->FullSimplify[scalar,ass]|>
];
RAYDoubleWarpedToComponents[model_Association,name_String,
  externalCoordinates_List,internalCoordinates_List,
  externalMetric_List,internalMetric_List,OptionsPattern[]]:=Module[
 {d=Length[externalCoordinates],n=Length[internalCoordinates],
  coords,ass=OptionValue[Assumptions],A,B,ha,hb,ta,tb,
  href,tref,full,ret,derived,actual,rs,ein,block,verify,checks},
 If[Lookup[model,"Type",None]=!="GeneralDoubleWarpedGeometry",
  Return[rayFail["RAYDoubleWarpedToComponents: supply a general double warped model."]]];
 If[!TrueQ[FullSimplify[model["ExternalDimension"]==d&&
      model["InternalDimension"]==n,ass]],
  Return[rayFail["RAYDoubleWarpedToComponents: reference coordinate sizes must match specified dimensions."]]];
 If[Dimensions[externalMetric]=!={d,d}||Dimensions[internalMetric]=!={n,n}||
    Length[DeleteDuplicates[Join[externalCoordinates,internalCoordinates]]]=!=d+n,
  Return[rayFail["RAYDoubleWarpedToComponents: inconsistent coordinate or matrix dimensions."]]];
 If[!And@@Flatten[
   Table[TrueQ[FullSimplify[D[externalMetric[[i,j]],y]==0,ass]],
    {i,d},{j,d},{y,internalCoordinates}]]||
    !And@@Flatten[
   Table[TrueQ[FullSimplify[D[internalMetric[[i,j]],x]==0,ass]],
    {i,n},{j,n},{x,externalCoordinates}]],
  Return[rayFail["RAYDoubleWarpedToComponents: reference external g must be independent of internal coordinates and vice versa. Both warp fields are unrestricted."]]];
 coords=Join[externalCoordinates,internalCoordinates];
 A=model["WarpA"];B=model["WarpB"];
 (* A bare symbolic parameter must never be mistaken for a constant warp:
    the abstract API accepts bare scalar names, the component API requires
    functions of coordinates or an explicit "ConstantA/B" assumption. *)
 If[(Head[A]===Symbol&&!TrueQ[model["ConstantA"]])||
    (Head[B]===Symbol&&!TrueQ[model["ConstantB"]]),
   Return[rayFail["RAYDoubleWarpedToComponents: bare symbolic warp names have unknown coordinate dependence. Use A[t,x,y,z] and B[t,x,y,z], or explicitly set ConstantA/ConstantB -> True in the abstract model."]]];
 href=Join[rayDTReference[externalCoordinates,externalMetric,ass],
  <|"Coordinates"->externalCoordinates|>];
 tref=Join[rayDTReference[internalCoordinates,internalMetric,ass],
  <|"Coordinates"->internalCoordinates|>];
 ha=rayDTField[externalCoordinates,href,A,ass];
 hb=rayDTField[externalCoordinates,href,B,ass];
 ta=rayDTField[internalCoordinates,tref,A,ass];
 tb=rayDTField[internalCoordinates,tref,B,ass];
 derived=rayDTBlock[href,tref,ha,hb,ta,tb,A,B,d,n,ass];
 full=ArrayFlatten[{
  {Exp[2A]externalMetric,ConstantArray[0,{d,n}]},
  {ConstantArray[0,{n,d}],Exp[2B]internalMetric}
 }];
 ret=RAYDefineMetric[name,coords,full,Assumptions->ass,
   "Simplification"->OptionValue["Simplification"]];
 If[ret===$Failed,Return[$Failed]];
 actual=RAYRaw["Ricci","dd"];rs=RAYRaw["RicciScalar"];
 ein=RAYRaw["Einstein","dd"];
 checks=<|
  "RicciExternal"->FullSimplify[
    actual[[1;;d,1;;d]]-derived["RicciExternal"],ass],
  "RicciInternal"->FullSimplify[
    actual[[d+1;;d+n,d+1;;d+n]]-derived["RicciInternal"],ass],
  "RicciMixed"->FullSimplify[
    actual[[1;;d,d+1;;d+n]]-derived["RicciMixed"],ass],
  "RicciScalar"->FullSimplify[rs-derived["RicciScalar"],ass],
  "EinsteinTrace"->FullSimplify[Tr[Inverse[full].ein]-
    (1-(d+n)/2)rs,ass]|>;
 verify=If[TrueQ[OptionValue["Verify"]],
   And@@(TrueQ[FullSimplify[#==0,ass]]||TrueQ[
     FullSimplify[#==ConstantArray[0,Dimensions[#]],ass]]&/@Values[checks]),
   Missing["NotRequested"]];
 <|"Type"->"DoubleWarpedComponentGeometry",
  "Name"->name,"Dimensions"->{d,n},
  "Coordinates"->coords,"Metric"->full,
  "RicciTensor"->actual,"RicciScalar"->rs,"EinsteinTensor"->ein,
  "RicciExternal"->actual[[1;;d,1;;d]],
  "RicciInternal"->actual[[d+1;;d+n,d+1;;d+n]],
  "RicciMixed"->actual[[1;;d,d+1;;d+n]],
  "DerivedFromGeneralFormula"->derived,
  "Residuals"->checks,"Verified"->verify,
  "AbstractModel"->model|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYDoubleWarpedGeometry[d,n,A,B]","General doubly twisted metric with unrestricted A(x,y),B(x,y), arbitrary symbolic dimensions and covariant/partial operators."},
 {"RAYDoubleWarpedReport[model]","Paper-style Ricci, scalar and Einstein tensors, including second mixed derivatives."},
 {"RAYDoubleWarpedToComponents[model,name,x,y,hatg,tildeg]","Instantiate arbitrary reference metrics, compute components and independently compare Ricci/scalar with symbolic identities."}
}];
