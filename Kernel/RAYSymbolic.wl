(* RAY: component covariant derivatives, warped metric products, and
   conservative abstract-index starter (not a replacement for xAct). *)

RAYCovD[tensor_List,config_String] /; rayRequireMetric[]===True :=
 Module[{rank=ArrayDepth[tensor],d=rayDim[],cfg,ga=rayGamma[],
   coords=rayCoords[],output,inds,mu,slots,val,position,term,lam},
  cfg=rayParseConfig[config,rank];
  If[cfg===$Failed || Dimensions[tensor]=!=ConstantArray[d,rank],
    Return[rayFail["RAYCovD: invalid array dimensions or u/d index string."]]];
  output=ConstantArray[0,ConstantArray[d,rank+1]];
  Do[
    mu=inds[[1]];slots=Rest[inds];
    val=D[Extract[tensor,slots],coords[[mu]]];
    Do[
      term=Sum[
        If[cfg[[position]]==1,
          ga[[slots[[position]],mu,lam]]*
            Extract[tensor,ReplacePart[slots,position->lam]],
          -ga[[lam,mu,slots[[position]]]]*
            Extract[tensor,ReplacePart[slots,position->lam]]
        ],{lam,d}];
      val+=term,
      {position,rank}
    ];
    output[[Sequence@@inds]]=raySimp[val],
    {inds,Tuples[Range[d],rank+1]}
  ];
  output
 ];

Options[RAYWarpedMetric]=Options[RAYDefineMetric];
RAYWarpedMetric[name_String,blocks_List,OptionsPattern[]] :=
 Module[{valid,coords,sizes,dim,mat,start=1,b,part,n,i,j},
  valid=blocks=!={} && AllTrue[blocks,
    MatchQ[#,{_List,_List,_}] &&
      MatrixQ[#[[2]]] &&
      Dimensions[#[[2]]]==={Length[#[[1]]],Length[#[[1]]]}&];
  If[!valid,
    Return[rayFail["RAYWarpedMetric: blocks must be {coordinates, metric matrix, full multiplier}."]]];
  coords=Flatten[blocks[[All,1]]];
  If[Length[DeleteDuplicates[coords]]=!=Length[coords],
    Return[rayFail["RAYWarpedMetric: coordinate names must be distinct."]]];
  sizes=Length/@blocks[[All,1]];
  dim=Total[sizes];mat=ConstantArray[0,{dim,dim}];
  Do[
    n=sizes[[b]];
    part=blocks[[b,3]] blocks[[b,2]];
    Do[mat[[start+i-1,start+j-1]]=part[[i,j]],{i,n},{j,n}];
    start+=n,
    {b,Length[blocks]}
  ];
  RAYDefineMetric[name,coords,mat,
    Assumptions->OptionValue[Assumptions],
    "Simplification"->OptionValue["Simplification"]]
 ];

Options[RAYSymbolicMetric]={
 "Signature"->Automatic,"Symmetry"->"General"
};

(* Without coordinates this descriptor contains only abstract tensor
   names, dimension and convention metadata. *)
RAYSymbolicMetric[name_String,dim_Integer?Positive,OptionsPattern[]] :=
 Module[{sgn=OptionValue["Signature"],sym=OptionValue["Symmetry"]},
  If[!MemberQ[{"General","Diagonal"},sym],
    Return[rayFail["RAYSymbolicMetric: Symmetry must be General or Diagonal."]]];
  If[sgn=!=Automatic && (!ListQ[sgn]||Length[sgn]=!=dim),
    Return[rayFail["RAYSymbolicMetric: signature length differs from dimension."]]];
  <|"Name"->name,"Dimension"->dim,
    "Signature"->sgn,"Symmetry"->sym,
    "MetricTensor"->RAYTensor["Metric",{RAYDown["a"],RAYDown["b"]}],
    "InverseMetricTensor"->RAYTensor["Metric",{RAYUp["a"],RAYUp["b"]}],
    "RicciTensor"->RAYTensor["Ricci",{RAYDown["a"],RAYDown["b"]}],
    "RiemannTensor"->RAYTensor["Riemann",
      {RAYUp["a"],RAYDown["b"],RAYDown["c"],RAYDown["d"]}],
    "Convention"->"R^a_bcd = partial_c Gamma^a_db - partial_d Gamma^a_cb + ..."
  |>
 ];

(* Coordinate specification prepares generic symmetric component
   functions, without inverting a huge unconstrained matrix. *)
RAYSymbolicMetric[name_String,coords_List,opts:OptionsPattern[]] :=
 Module[{base=RAYSymbolicMetric[name,Length[coords],opts],d=Length[coords],
   sym=OptionValue["Symmetry"],f,mat},
  If[base===$Failed,Return[$Failed]];
  f=Table[
    If[i<=j,If[sym==="Diagonal" && i=!=j,0,
      Unique["rayMetricComponent$"]@@coords],0],
    {i,d},{j,d}];
  mat=Table[f[[Min[i,j],Max[i,j]]],{i,d},{j,d}];
  Join[base,<|"Coordinates"->coords,"Components"->mat|>]
 ];

RAYInstantiateMetric[descriptor_Association,matrix_:Automatic] :=
 Module[{coords=Lookup[descriptor,"Coordinates",Missing["None"]],
   g=If[matrix===Automatic,Lookup[descriptor,"Components",Missing["None"]],matrix]},
  If[MissingQ[coords] || MissingQ[g],
    Return[rayFail["RAYInstantiateMetric: descriptor requires coordinates and a component matrix."]]];
  RAYDefineMetric[descriptor["Name"],coords,g]
 ];

(* Formal abstract differentiation. No dummy-index canonicalization,
   commutation of covariant derivatives or curvature simplification. *)
RAYAbstractCovD[expr_Plus,mu_] := Map[RAYAbstractCovD[#,mu]&,expr];
RAYAbstractCovD[expr_Times,mu_] := Module[{f=List@@expr},
  Total[Table[
    Times@@ReplacePart[f,k->RAYAbstractCovD[f[[k]],mu]],
    {k,Length[f]}]]
 ];
RAYAbstractCovD[expr_?NumericQ,mu_] := 0;
RAYAbstractCovD[RAYTensor["Metric",_],mu_] := 0;
RAYAbstractCovD[expr_,mu_] := RAYNabla[If[Head[mu]===RAYDown,mu,RAYDown[mu]],expr];

RAYConventions[] := Grid[
 {
  {Style["Dimension",Bold],If[rayMetricQ[],rayDim[],"No active metric"]},
  {Style["Signature",Bold],If[rayMetricQ[],RAYSignature[],"Metric-dependent"]},
  {Style["Riemann",Bold],
   "R^a_(bcd) = partial_c Gamma^a_(db) - partial_d Gamma^a_(cb) + Gamma^a_(ce) Gamma^e_(db) - Gamma^a_(de) Gamma^e_(cb)"},
  {Style["Ricci",Bold],"R_(bd) = R^a_(bad)"},
  {Style["Einstein",Bold],"G_(ab) = R_(ab) - (R/2) g_(ab)"},
  {Style["Hilbert stress",Bold],
   "T_(ab) = g_(ab) L_m - 2 delta L_m / delta g^(ab)"},
  {Style["Einstein equations",Bold],
   "G_(ab) + Lambda g_(ab) = kappa T_(ab)"},
  {Style["Warped metric",Bold],
   "Each block contributes its full multiplier times the block metric"},
  {Style["Abstract status",Bold],
   "Formal tensors/product rule only; xAct-level canonicalization is not implemented"}
 },Frame->All,Alignment->Left
];
