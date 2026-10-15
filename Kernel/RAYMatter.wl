(* Explicit matter action, Hilbert stress tensor, field-equation construction. *)
(* L_m may depend algebraically on the inverse metric, not its derivatives.
   Matter tensors/field strengths must be supplied as explicit components. *)

$rayInverseVariables=<||>;
$rayMatterActions=<||>;

RAYMetricVariables[] /; rayRequireMetric[]===True := Module[
  {key=$rayActiveMetric,d=rayDim[],fresh,q},
  If[KeyExistsQ[$rayInverseVariables,key] &&
    Dimensions[$rayInverseVariables[key]]==={d,d},
    Return[$rayInverseVariables[key]]];
  fresh=Table[If[i<=j,Unique["rayInv$"],0],{i,d},{j,d}];
  q=Table[fresh[[Min[i,j],Max[i,j]]],{i,d},{j,d}];
  AssociateTo[$rayInverseVariables,key->q];
  q
];

RAYScalarLagrangian[field_,potential_:0] /; rayRequireMetric[]===True :=
 Module[{q=RAYMetricVariables[],x=rayCoords[],d=rayDim[]},
   -1/2 Sum[q[[i,j]] D[field,x[[i]]] D[field,x[[j]]],
     {i,d},{j,d}]-potential
 ];

RAYMaxwellLagrangian[F_List] /; rayRequireMetric[]===True :=
 Module[{q=RAYMetricVariables[],d=rayDim[]},
   If[Dimensions[F]=!={d,d},
     Return[rayFail["RAYMaxwellLagrangian: F must be a d x d antisymmetric matrix."]]];
   -1/4 Sum[q[[i,j]]q[[k,l]] F[[i,k]] F[[j,l]],
     {i,d},{j,d},{k,d},{l,d}]
 ];

Options[RAYMatterAction]={"Name"->"Matter","Store"->True};

RAYMatterAction[fn_Function,opts:OptionsPattern[]] /; rayRequireMetric[]===True :=
  RAYMatterAction[fn[RAYMetricVariables[]],opts];

RAYMatterAction[lag_,OptionsPattern[]] /; rayRequireMetric[]===True :=
 Module[{d=rayDim[],q=RAYMetricVariables[],inv=rayGUU[],g=rayGDD[],
    rules,L,stress,deriv,nm=OptionValue["Name"],data},
  If[!StringQ[nm],
    Return[rayFail["RAYMatterAction: \"Name\" must be a string."]]];
  rules=Flatten[Table[q[[i,j]]->inv[[i,j]],{i,d},{j,i,d}]];
  L=raySimp[lag/.rules];
  stress=Table[
    deriv=With[{v=q[[i,j]]},D[lag,v]]/If[i===j,1,2];
    raySimp[g[[i,j]] L-2 (deriv/.rules)],
    {i,d},{j,d}
  ];
  data=<|
   "Name"->nm,"Metric"->$rayActiveMetric,"Dimension"->d,
   "Lagrangian"->L,"StressTensor"->stress,
   "Convention"->"T_ab = g_ab L_m - 2 delta L_m / delta g^ab"
  |>;
  If[TrueQ[OptionValue["Store"]],
    AssociateTo[$rayMatterActions,$rayActiveMetric->data]];
  data
];

rayMatterStressDD[] := Module[{obj=Lookup[$rayMatterActions,$rayActiveMetric,Missing["None"]]},
  If[MissingQ[obj],
    Return[rayFail["RAYStressTensor: store a matter action first."]]];
  obj["StressTensor"]
];

RAYStressTensor[] := RAYStressTensor["dd"];
RAYStressTensor[c_String] /; rayRequireMetric[]===True :=
 Module[{cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[raw===$Failed || cfg===$Failed,
    Return[rayFail["RAYStressTensor: invalid index configuration or missing action."]]];
  rayDisplayMatrix[rayChangeIndices[raw,{-1,-1},cfg]]
 ];
RAYStressTensor[c_String,i_Integer,j_Integer] /; rayRequireMetric[]===True :=
 Module[{cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[raw===$Failed || cfg===$Failed ||
      !And@@(rayValidIndexQ/@{i,j}),Return[$Failed]];
  raySimp[Extract[rayChangeIndices[raw,{-1,-1},cfg],{i,j}+1]]
 ];

RAYRaw["StressTensor"] := rayMatterStressDD[];
RAYRaw["StressTensor",c_String] := Module[
  {cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[cfg===$Failed || raw===$Failed,Return[$Failed]];
  rayChangeIndices[raw,{-1,-1},cfg]
];
RAYRaw[RAYStressTensor[]] := rayMatterStressDD[];
RAYRaw[RAYStressTensor[c_String]] := RAYRaw["StressTensor",c];
RAYRaw[RAYStressTensor[c_String,i_Integer,j_Integer]] :=
 Module[{tensor=RAYRaw["StressTensor",c]},
  If[tensor===$Failed || !And@@(rayValidIndexQ/@{i,j}),Return[$Failed]];
  Extract[tensor,{i,j}+1]
 ];

Options[RAYEinsteinEquations]={
  "Coupling"->1,"CosmologicalConstant"->0,
  "Components"->"UpperTriangle","DropIdentities"->True,
  "Return"->"Equations"
};

RAYEinsteinEquations[opts:OptionsPattern[]] /; rayRequireMetric[]===True :=
  RAYEinsteinEquations[rayEinsteinDD[],0,opts];

RAYEinsteinEquations[einstein_List,opts:OptionsPattern[]] :=
  RAYEinsteinEquations[einstein,0,opts];

RAYEinsteinEquations[einstein_List,stress_,OptionsPattern[]] /;
  rayRequireMetric[]===True :=
 Module[{d=rayDim[],g=rayGDD[],source,chosen,pairs,eq,
  kappa=OptionValue["Coupling"],
  lambda=OptionValue["CosmologicalConstant"],
  components=OptionValue["Components"],
  ret=OptionValue["Return"]},
  If[Dimensions[einstein]=!={d,d},
    Return[rayFail["RAYEinsteinEquations: Einstein tensor must be d x d."]]];
  source=If[stress===0,ConstantArray[0,{d,d}],stress];
  If[Dimensions[source]=!={d,d},
    Return[rayFail["RAYEinsteinEquations: stress tensor must be d x d or zero."]]];
  chosen=Switch[components,
    "UpperTriangle",Select[Tuples[Range[0,d-1],2],#[[1]]<=#[[2]]&],
    "Diagonal",Table[{i,i},{i,0,d-1}],
    "All",Tuples[Range[0,d-1],2],
    _List,components,
    _,Return[rayFail["RAYEinsteinEquations: unknown component selection."]]
  ];
  If[!AllTrue[chosen,
       MatchQ[#,{_Integer,_Integer}] && And@@(rayValidIndexQ/@#)&],
    Return[rayFail["RAYEinsteinEquations: indices must be between 0 and d-1."]]];
  pairs=Table[
    {p,raySimp[
      einstein[[p[[1]]+1,p[[2]]+1]]+
      lambda g[[p[[1]]+1,p[[2]]+1]]-
      kappa source[[p[[1]]+1,p[[2]]+1]]
    ]},
    {p,chosen}
  ];
  If[TrueQ[OptionValue["DropIdentities"]],
    pairs=Select[pairs,!TrueQ[#[[2]]===0]&]];
  eq=(#[[2]]==0)&/@pairs;
  Switch[ret,
   "Association",<|"Equations"->eq,"Components"->(First/@pairs),
      "Residuals"->(Last/@pairs),
      "Coupling"->kappa,"CosmologicalConstant"->lambda|>,
   "Residuals",Last/@pairs,
   _,eq
  ]
];
