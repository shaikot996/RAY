(* ::Package:: *)
(* RAY: dimension-independent warped-product curvature algebra.
   Metric: ds^2 = -L(t)^2 dt^2 + Sum_i Exp[2 a_i(t)] h^(i).
   Each h^(i) is time-independent, nondegenerate and block diagonal.
   Dimensions m_i are symbolic; no tensor arrays of size m_i are built.
   Curvature convention agrees with Kernel/RAY.wl.
   All formulas are exact for Levi-Civita warped products. *)

Options[RAYWarpedBlocks]={"Time"->Automatic,"Lapse"->1,
 "Assumptions"->True,"Simplification"->"Simplify",
 "Parameters"->{}};

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


(* The symbolic Hubble-block formulas assume that each warp is a function
   of the common time alone. Reject multivariable coordinate-dependent
   functions instead of silently dropping their spatial gradients.
   Bare symbols are parameters unless users supply separate coordinates. *)
rayWarpTimeOnlyQ[warp_,time_Symbol,parameters_List:{}] :=
 Module[{symbols},
  symbols=DeleteDuplicates@Cases[HoldComplete[warp],
    s_Symbol /; Context[s]=!="System`" :> s,Infinity];
  Complement[symbols,Join[{time},parameters]]==={}
 ];


RAYWarpedBlocks[specs_List,OptionsPattern[]] := Module[
 {time,lapse=OptionValue["Lapse"],ass=OptionValue["Assumptions"],
  mode=OptionValue["Simplification"],parameters=OptionValue["Parameters"],simple,geom,dimensions,warps,
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
 If[!ListQ[parameters] || !AllTrue[parameters,MatchQ[#,_Symbol]&],
  Return[rayFail["RAYWarpedBlocks: \"Parameters\" must be a list of constant parameter symbols."]]];
 If[!AllTrue[warps,rayWarpTimeOnlyQ[#,time,parameters]&] ||
   !rayWarpTimeOnlyQ[lapse,time,parameters],
  Return[rayFail[
   "RAYWarpedBlocks: warp factors and lapse must depend on time only. For spatial coordinate dependence, use RAYCovariantWarpedMetric; for constant symbolic coefficients explicitly supply \"Parameters\"->{c1,c2}."
  ]]];
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
  "Simplification"->OptionValue["Simplification"],
  "Parameters"->OptionValue["Parameters"]]
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


(* Einstein equations for comoving homogeneous diagonal matter.
   T_tt = lapse^2 rho,  T^(i)_ab = p_i Exp[2 a_i] h^(i)_ab.
   General intrinsic reference geometry is not automatically Einstein;
   preserve its full tensor equation as well as the scalar trace. *)
Options[RAYWarpedFieldEquations]={
 "Coupling"->1,"CosmologicalConstant"->0,
 "Simplification"->"Simplify"};
RAYWarpedFieldEquations[model_Association,source_:Automatic,OptionsPattern[]] :=
 Module[{blocks=Lookup[model,"Blocks",{}],rho=0,pressures,
  coupling=OptionValue["Coupling"],lambda=OptionValue["CosmologicalConstant"],
  timeRes,spatial,vars,curv,coeff,scalarPart,res,tensorRes,
  nsp,mode=OptionValue["Simplification"],simp},
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
   Return[rayFail["RAYWarpedFieldEquations: expected a symbolic warped-block model."]]];
 nsp=Length[blocks];
 If[source===Automatic,
   pressures=ConstantArray[0,nsp],
   If[!AssociationQ[source],
     Return[rayFail["RAYWarpedFieldEquations: source must be an Association or Automatic."]]];
   rho=Lookup[source,"EnergyDensity",0];
   pressures=Lookup[source,"Pressures",ConstantArray[0,nsp]];
   If[AssociationQ[pressures],
     If[!AllTrue[blocks,KeyExistsQ[pressures,#["Name"]]&],
       Return[rayFail["RAYWarpedFieldEquations: missing a pressure for one or more named blocks."]]];
     pressures=Lookup[pressures,blocks[[All,"Name"]]]];
   If[!ListQ[pressures]||Length[pressures]=!=nsp,
     Return[rayFail["RAYWarpedFieldEquations: one pressure per block is required."]]]
 ];
 simp=Switch[mode,
   "None",Function[q,q],
   "Full",Function[q,FullSimplify[q,model["Assumptions"]]],
   _,Function[q,Simplify[q,model["Assumptions"]]]];
 timeRes=simp[model["EinsteinTimeTime"]-
    model["Lapse"]^2(lambda+coupling rho)];
 spatial=Table[
   vars=blocks[[k]];curv=vars["Geometry"];
   coeff=Switch[curv,
      "Flat",0,
      {"ConstantCurvature",_},(vars["Dimension"]-1)curv[[2]],
      {"Einstein",_},curv[[2]],
      _,Missing["NonEinstein"]];
   scalarPart=simp[vars["EinsteinCoefficient"]+
      Exp[-2vars["Warp"]]vars["IntrinsicRicciScalar"]/vars["Dimension"]+
      lambda-coupling pressures[[k]]];
   tensorRes=simp[vars["EinsteinTensor"]+
      Exp[2 vars["Warp"]](lambda-coupling pressures[[k]])vars["ReferenceMetric"]];
   res=If[MissingQ[coeff],tensorRes,
     simp[Exp[-2vars["Warp"]]coeff+
       vars["EinsteinCoefficient"]+lambda-coupling pressures[[k]]]];
   <|"Name"->vars["Name"],
     "EquationType"->If[MissingQ[coeff],"FullTensor","Scalar"],
     "Equation"->(res==0),
     "Residual"->res,
     "TraceResidual"->scalarPart,
     "TensorResidual"->tensorRes|>,
   {k,nsp}];
 <|"Type"->"WarpedEinsteinEquations",
   "TimeTime"->(timeRes==0),"TimeTimeResidual"->timeRes,
   "Spatial"->spatial,"Coupling"->coupling,
   "CosmologicalConstant"->lambda,
   "EnergyDensity"->rho,"Pressures"->pressures|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYGeneralWarpedMetric[d,n,A[t],B[t]]","Exact Ricci and Einstein formulas with symbolic d,n; time lapse and spatial curvature configurable."},
 {"RAYWarpedBlocks[{{name,m,a[t],geometry},...}]","Dimension-independent warped product with any number of time-dependent spatial factors."},
 {"RAYWarpedToComponents[model,name,blocks]","Specialize integer block dimensions into the existing explicit metric engine."},
 {"RAYWarpedReport[model]","Readable symbolic Ricci/Einstein formulas and block descriptions."},
 {"RAYWarpedFieldEquations[model,source]","Einstein equations with Lambda and comoving rho, p_i; retains full tensor equations for non-Einstein blocks."},
 {"RAYIntrinsicScalar[name]","Placeholder for an unspecified intrinsic scalar curvature of a spatial reference metric."}
}];
