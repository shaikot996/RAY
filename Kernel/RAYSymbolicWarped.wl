(* ::Package:: *)
(* RAY: dimension-independent warped-product curvature algebra.
   Metric: ds^2 = -L(t)^2 dt^2 + Sum_i Exp[2 a_i(t)] h^(i).
   Each h^(i) is time-independent, nondegenerate and block diagonal.
   Dimensions m_i are symbolic; no tensor arrays of size m_i are built.
   Curvature convention agrees with Kernel/RAY.wl.
   All formulas are exact for Levi-Civita warped products. *)

Options[RAYWarpedBlocks]={"Time"->Automatic,"Lapse"->1,
 "Assumptions"->True,"Simplification"->"Simplify"};

rayWarpSpecQ[spec_] := MatchQ[spec,{_String,_,_,_}];

rayWarpGeometry[geometry_,dim_,name_] := Module[
 {g=RAYTensor[name<>"Metric",{RAYDown["i"],RAYDown["j"]}],
  r=RAYTensor[name<>"Ricci",{RAYDown["i"],RAYDown["j"]}],
  scalar=RAYIntrinsicScalar[name],curv},
 Switch[geometry,
  "Flat", {0,0,g},
  "General", {scalar,r,g},
  {"General",_}, {geometry[[2]],r,g},
  {"ConstantCurvature",_},
    curv=geometry[[2]];
    {dim (dim-1) curv,(dim-1)curv g,g},
  {"Einstein",_},
    curv=geometry[[2]];
    {dim curv,curv g,g},
  _, $Failed
 ]
];

rayWarpTime[specs_,lapse_,time_] := Module[{candidates},
 If[time=!=Automatic && Head[time]===Symbol,Return[time]];
 If[time=!=Automatic,Return[$Failed]];
 candidates=Cases[{specs[[All,3]],lapse},
     HoldPattern[f_Symbol[z_Symbol]] /; f=!=Exp :> z,Infinity];
 candidates=DeleteDuplicates[candidates];
 If[Length[candidates]===1,First[candidates],$Failed]
];

RAYWarpedBlocks[specs_List,OptionsPattern[]] := Module[
 {time,lapse=OptionValue["Lapse"],ass=OptionValue["Assumptions"],
  mode=OptionValue["Simplification"],simple,geom,dimensions,warps,
  H,Hdot,sumH,sumH2,curvTerm,timeRic,scalar,einTime,blocks,
  spatialRic,EinCoeffs,coords,vol},
 If[specs==={}||!AllTrue[specs,rayWarpSpecQ],
   Return[rayFail["RAYWarpedBlocks: use {{name,dimension,warp,geometry},...}."]]];
 If[Length[DeleteDuplicates[specs[[All,1]]]]=!=Length[specs],
   Return[rayFail["RAYWarpedBlocks: block names must be unique."]]];
 dimensions=specs[[All,2]];warps=specs[[All,3]];
 If[AnyTrue[dimensions,(NumericQ[#]&&(!IntegerQ[#]||#<1))&],
   Return[rayFail["RAYWarpedBlocks: each block dimension must be a positive integer or symbolic."]]];
 If[TrueQ[PossibleZeroQ[lapse]],
   Return[rayFail["RAYWarpedBlocks: the lapse cannot vanish."]]];
 time=rayWarpTime[specs,lapse,OptionValue["Time"]];
 If[time===$Failed,
   Return[rayFail["RAYWarpedBlocks: specify \"Time\"->t or use a single time variable in all warps."]]];
 geom=Map[rayWarpGeometry[#[[4]],#[[2]],#[[1]]]&,specs];
 If[MemberQ[geom,$Failed],
   Return[rayFail["RAYWarpedBlocks: geometry must be Flat, General, {General,R}, {Einstein,lambda}, or {ConstantCurvature,K}."]]];
 simple=Switch[mode,
   "None",Function[x,x],
   "Full",Function[x,FullSimplify[x,ass]],
   _,Function[x,Simplify[x,ass]]];
 H=simple/@(D[#,time]/lapse&/@warps);
 Hdot=simple/@(D[#,time]/lapse&/@H);
 sumH=simple[Total[dimensions H]];
 sumH2=simple[Total[dimensions H^2]];
 curvTerm=simple[Total[MapThread[Exp[-2 #1] #2[[1]]&,{warps,geom}]]];
 timeRic=simple[-lapse^2 Total[dimensions (Hdot+H^2)]];
 scalar=simple[curvTerm+2 Total[dimensions Hdot]+sumH^2+sumH2];
 einTime=simple[timeRic+(lapse^2/2)scalar];
 blocks=Table[
  With[{name=specs[[q,1]],mi=dimensions[[q]],a=warps[[q]],
    geometry=specs[[q,4]],intr=geom[[q,2]],g=geom[[q,3]],
    sc=geom[[q,1]],hi=H[[q]],dh=Hdot[[q]],
    c=simple[Hdot[[q]]+H[[q]]sumH]},
   <|"Name"->name,"Dimension"->mi,"Warp"->a,"Geometry"->geometry,
    "IntrinsicRicciScalar"->sc,"IntrinsicRicciTensor"->intr,
    "ReferenceMetric"->g,"Hubble"->hi,
    "HubbleDerivative"->dh,
    "RicciCoefficient"->c,
    "RicciTensor"->simple[intr+Exp[2a] c g],
    "EinsteinCoefficient"->simple[c-scalar/2],
    "EinsteinTensor"->simple[intr+Exp[2a](c-scalar/2)g]
   |>
  ],{q,Length[specs]}];
 vol=simple[lapse Exp[Total[dimensions warps]]];
 <|"Type"->"SymbolicWarpedBlocks",
   "Time"->time,"Lapse"->lapse,"Blocks"->blocks,
   "BlockCount"->Length[specs],
   "Dimensions"->dimensions,
   "SpatialDimension"->Total[dimensions],
   "TotalDimension"->1+Total[dimensions],
   "TotalHubble"->sumH,
   "SumWeightedHubbleSquares"->sumH2,
   "IntrinsicCurvatureContribution"->curvTerm,
   "RicciTimeTime"->timeRic,
   "RicciScalar"->scalar,
   "EinsteinTimeTime"->einTime,
   "VolumeFactor"->vol,
   "MetricSignature"->"One timelike direction; spatial block signatures follow their reference metrics",
   "Assumptions"->ass|>
];

Options[RAYGeneralWarpedMetric]=Join[
  Options[RAYWarpedBlocks],{"ExternalGeometry"->"Flat",
   "InternalGeometry"->"General"}];

RAYGeneralWarpedMetric[d_,n_,extWarp_,intWarp_,OptionsPattern[]] :=
 Module[{specs,options},
 If[NumericQ[d]&&(!IntegerQ[d]||d<2),
  Return[rayFail["RAYGeneralWarpedMetric: external spacetime dimension d must be at least 2."]]];
 If[NumericQ[n]&&(!IntegerQ[n]||n<1),
  Return[rayFail["RAYGeneralWarpedMetric: internal dimension n must be at least 1."]]];
 specs={
  {"External",d-1,extWarp,OptionValue["ExternalGeometry"]},
  {"Internal",n,intWarp,OptionValue["InternalGeometry"]}};
 RAYWarpedBlocks[specs,
  "Time"->OptionValue["Time"],"Lapse"->OptionValue["Lapse"],
  "Assumptions"->OptionValue["Assumptions"],
  "Simplification"->OptionValue["Simplification"]]
];

(* Instantiate a symbolic model at fixed INTEGER block dimensions by
   supplying {coordinates, referenceMetric} for each spatial block.
   The model is not an arbitrary-sized matrix until these are supplied.
   The intrinsic curvature classification is a mathematical declaration,
   not an automatic validation of the supplied reference metrics. *)
Options[RAYWarpedToComponents]=Options[RAYDefineMetric];
RAYWarpedToComponents[model_Association,name_String,
  metricBlocks_List,opts:OptionsPattern[]] :=
 Module[{blocks=Lookup[model,"Blocks",{}],time,lapse,part,warpSpec,
  dim,good},
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
  Return[rayFail["RAYWarpedToComponents: a symbolic warped-block descriptor is required."]]];
 If[Length[blocks]=!=Length[metricBlocks],
  Return[rayFail["RAYWarpedToComponents: provide one coordinate/metric pair per spatial block."]]];
 good=And@@Table[
   MatchQ[metricBlocks[[k]],{_List,_List}] &&
   IntegerQ[blocks[[k,"Dimension"]]] &&
   blocks[[k,"Dimension"]]>=1 &&
   Length[metricBlocks[[k,1]]]==blocks[[k,"Dimension"]] &&
   Dimensions[metricBlocks[[k,2]]]==
     {blocks[[k,"Dimension"]],blocks[[k,"Dimension"]]},
   {k,Length[blocks]}];
 If[!good,Return[rayFail["RAYWarpedToComponents: block dimensions must be concrete positive integers matching their matrices."]]];
 time=model["Time"];lapse=model["Lapse"];
 warpSpec=Join[{{{time},{{-lapse^2}},1}},
   Table[{metricBlocks[[k,1]],metricBlocks[[k,2]],
    Exp[2 blocks[[k,"Warp"]]]},{k,Length[blocks]}]];
 RAYWarpedMetric[name,warpSpec,
  Assumptions->OptionValue[Assumptions],
  "Simplification"->OptionValue["Simplification"]]
];

(* Convenience: readable summary; formulas remain exact algebraic expressions. *)
RAYWarpedReport[model_Association] :=
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
  rayFail["RAYWarpedReport: expected a RAYWarpedBlocks result."],
  Column[{
   Style["Symbolic warped geometry",Bold,16],
   Grid[{
    {"Total dimension",model["TotalDimension"]},
    {"Time coordinate",model["Time"]},
    {"Lapse",model["Lapse"]},
    {"Ricci time-time",RAYReadable[model["RicciTimeTime"]]},
    {"Ricci scalar",RAYReadable[model["RicciScalar"]]},
    {"Einstein time-time",RAYReadable[model["EinsteinTimeTime"]]},
    {"Volume factor",RAYReadable[model["VolumeFactor"]]}
   },Frame->All,Alignment->Left],
   Style["Spatial blocks",Bold,13],
   Grid[Prepend[
    Table[{bl["Name"],bl["Dimension"],
      RAYReadable[bl["RicciTensor"]],
      RAYReadable[bl["EinsteinTensor"]]},{bl,model["Blocks"]}],
     {"Name","Dimension","Ricci tensor","Einstein tensor"}],
    Frame->All,Alignment->Left]
  },Spacings->1]
 ];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYGeneralWarpedMetric[d,n,A[t],B[t]]","Exact Ricci and Einstein formulas with symbolic d,n; time lapse and spatial curvature configurable."},
 {"RAYWarpedBlocks[{{name,m,a[t],geometry},...}]","Dimension-independent warped product with any number of time-dependent spatial factors."},
 {"RAYWarpedToComponents[model,name,blocks]","Specialize integer block dimensions into the existing explicit metric engine."},
 {"RAYWarpedReport[model]","Readable symbolic Ricci/Einstein formulas and block descriptions."},
 {"RAYIntrinsicScalar[name]","Placeholder for an unspecified intrinsic scalar curvature of a spatial reference metric."}
}];
