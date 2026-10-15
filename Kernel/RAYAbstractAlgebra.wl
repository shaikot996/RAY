(* RAY abstract-index algebra, v1.2 development.
   Indices are RAYUp[label] / RAYDown[label], e.g.
   RAYTensor["F",{RAYDown[a],RAYDown[b]}].
   Free indices occur once per monomial. A dummy occurs precisely twice,
   once upper and once lower. No implicit contraction from a bare repeated
   variable outside RAYTensor index lists. *)

$rayAbstractSymmetries=<||>;

Options[RAYDeclareSymmetry]={"Slots"->{1,2}};
RAYDeclareSymmetry[name_String,kind_String,OptionsPattern[]] := Module[
  {slots=OptionValue["Slots"]},
  If[!MemberQ[{"Symmetric","Antisymmetric"},kind] ||
     !MatchQ[slots,{_Integer,_Integer}] ||
     slots[[1]]===slots[[2]] || Min[slots]<1,
    Return[rayFail["RAYDeclareSymmetry: use Symmetric/Antisymmetric and two distinct positive slots."]]];
  AssociateTo[$rayAbstractSymmetries,name-><|"Kind"->kind,"Slots"->slots|>];
  name
];

rayAbsIndexQ[RAYUp[_]]:=True;
rayAbsIndexQ[RAYDown[_]]:=True;
rayAbsIndexQ[_]:=False;
rayAbsLabel[RAYUp[x_]]:=x;
rayAbsLabel[RAYDown[x_]]:=x;
rayAbsVariance[RAYUp[_]]:=1;
rayAbsVariance[RAYDown[_]]:=-1;
rayAbsFlip[RAYUp[x_]]:=RAYDown[x];
rayAbsFlip[RAYDown[x_]]:=RAYUp[x];
rayAbsReplaceLabel[RAYUp[x_],rules_]:=RAYUp[x/.rules];
rayAbsReplaceLabel[RAYDown[x_],rules_]:=RAYDown[x/.rules];
rayAbsSortKey[x_]:=ToString[Unevaluated[x],InputForm];

rayAbsSwap[indices_,i_,j_]:=ReplacePart[indices,{
 i->indices[[j]],j->indices[[i]]}];

rayAbsGenerators[name_,idx_List]:=Module[{n=Length[idx],gens={},sym},
  If[MemberQ[{"Metric","Ricci"},name] && n===2 &&
     rayAbsVariance[idx[[1]]]===rayAbsVariance[idx[[2]]],
    AppendTo[gens,{{1,2},1}]];
  If[name==="Riemann" && n===4,
    AppendTo[gens,{{3,4},-1}];
    If[SameQ@@(rayAbsVariance/@idx),
      AppendTo[gens,{{1,2},-1}];
      AppendTo[gens,{{3,4,1,2},1}]]];
  If[KeyExistsQ[$rayAbstractSymmetries,name],
    sym=$rayAbstractSymmetries[name];
    If[Max[sym["Slots"]]<=n,
      AppendTo[gens,{sym["Slots"],
        If[sym["Kind"]==="Symmetric",1,-1]}]]];
  gens
];

(* Generates the orbit under index symmetries; the four-index pair
   interchange is a permutation {3,4,1,2}. *)
rayAbsTensorNormalize[RAYTensor[name_String,idx_List]]:=Catch[Module[
  {gens=rayAbsGenerators[name,idx],queue={{idx,1}},seen=<||>,
   cur,inds,sgn,new,p,rule,ordered},
  If[!AllTrue[idx,rayAbsIndexQ],
    Return[RAYTensor[name,idx]]];
  While[queue=!={},
    cur=First[queue];queue=Rest[queue];
    inds=cur[[1]];sgn=cur[[2]];
    p=rayAbsSortKey[inds];
    If[KeyExistsQ[seen,p],
      If[seen[p][[2]] =!= sgn,Throw[0,"RAYTensorNorm"]];
      Continue[]];
    AssociateTo[seen,p->{inds,sgn}];
    Do[
      rule=g[[1]];
      new=If[Length[rule]===2,
        rayAbsSwap[inds,rule[[1]],rule[[2]]],
        inds[[rule]]];
      AppendTo[queue,{new,sgn*g[[2]]}],
      {g,gens}
    ];
  ];
  ordered=First@SortBy[Values[seen],rayAbsSortKey[#[[1]]]&];
  ordered[[2]] RAYTensor[name,ordered[[1]]]
],"RAYTensorNorm"];
rayAbsTensorNormalize[x_]:=x;

rayAbsFactors[term_]:=If[Head[term]===Times,List@@term,{term}];

rayAbsRenameIndices[expr_,mapping_List] :=
 expr/.{
   RAYUp[x_] :> RAYUp[x/.mapping],
   RAYDown[x_] :> RAYDown[x/.mapping]
 };

rayAbsCanonicalTerm[term_]:=Module[
  {normalized,indices,groups,dummies,mappings,perms,candidates},
  normalized=Times@@(rayAbsTensorNormalize/@rayAbsFactors[term]);
  If[normalized===0,Return[0]];
  indices=Join[Cases[normalized,RAYUp[x_]:>{x,1},Infinity],
    Cases[normalized,RAYDown[x_]:>{x,-1},Infinity]];
  groups=GatherBy[indices,First];
  dummies=First[First[#]]& /@
    Select[groups,Length[#]===2 &&
      Sort[#[[All,2]]] === {-1,1}&];
  If[dummies==={},Return[normalized]];
  (* Stable canonicalization of dummy indices independent of their
     user-supplied spelling. Limit factorial search for large expressions. *)
  perms=If[Length[dummies]<=6,
    Permutations[Range[Length[dummies]]],
    {Range[Length[dummies]]}];
  candidates=Table[
    mappings=Thread[dummies->
      (RAYDummy/@permutation)];
    Times@@(rayAbsTensorNormalize/@rayAbsFactors[
      rayAbsRenameIndices[normalized,mappings]]),
    {permutation,perms}];
  First@SortBy[candidates,rayAbsSortKey]
];

RAYCanonicalize[expr_] := Module[{expanded=Expand[expr],terms},
  terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
  Expand[Total[rayAbsCanonicalTerm/@terms]]
];

RAYIndexCheck[expr_] := Module[{terms,perTerm,indices,groups,invalid},
  terms=rayAbsFactors[Expand[expr]];
  If[Head[Expand[expr]]===Plus,terms=List@@Expand[expr]];
  perTerm=Table[
    indices=Join[Cases[term,RAYUp[x_]:>{x,1},Infinity],
      Cases[term,RAYDown[x_]:>{x,-1},Infinity]];
    groups=GatherBy[indices,First];
    invalid=Select[groups,
      Length[#]>2 || (Length[#]===2 &&
        Sort[#[[All,2]]] =!= {-1,1})&];
    <|"Valid"->(invalid==={}),
      "FreeIndices"->(First/@Select[groups,Length[#]===1&]),
      "DummyIndices"->(First/@Select[groups,Length[#]===2&]),
      "Invalid"->invalid|>,
    {term,terms}];
  <|"Valid"->AllTrue[perTerm,#["Valid"]&],
    "Terms"->perTerm|>
];

rayAbsKnownTensorQ[x_]:=MatchQ[x,RAYTensor[_String,_List]];

(* Contract a single factor pair, metric raising/lowering or delta
   substitution. Missing complementary factors leave an Einstein pair
   as a formal contraction. *)
rayAbsReduceFactors[factors_List,d_Integer] := Catch[Module[
  {f=factors,n=Length[factors],i,j,k,h,idx,other,otherIdx,
   p,q,remain,name,newIndices,newFactor,label,free},
  (* metric traces and algebraic Riemann->Ricci traces *)
  Do[
    If[MatchQ[f[[i]],RAYTensor["Delta",_List]],
      idx=f[[i,2]];
      If[Length[idx]===2 && rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[2]]] &&
        rayAbsVariance[idx[[1]]]===-rayAbsVariance[idx[[2]]],
        Throw[{True,ReplacePart[f,i->d]},"RAYReduction"]]];
    If[MatchQ[f[[i]],RAYTensor["Riemann",_List]],
      idx=f[[i,2]];
      If[Length[idx]===4 && Head[idx[[1]]]===RAYUp,
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[3]]],
          Throw[{True,ReplacePart[f,
            i->RAYTensor["Ricci",idx[[{2,4},"RAYReduction"]]]]}]];
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[4]]],
          Throw[{True,ReplacePart[f,
            i->(-RAYTensor["Ricci",idx[[{2,3},"RAYReduction"]]])]}]];
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[2]]],
          Throw[{True,ReplacePart[f,i->0]},"RAYReduction"]]
      ]
    ],
    {i,n}
  ];
  Do[
    If[!rayAbsKnownTensorQ[f[[i]]],Continue[]];
    name=f[[i,1]];idx=f[[i,2]];
    If[!MemberQ[{"Metric","Delta"},name] || Length[idx]=!=2,
      Continue[]];
    Do[
      If[i===j || !rayAbsKnownTensorQ[f[[j]]],Continue[]];
      other=f[[j]];otherIdx=other[[2]];
      Do[
        p=idx[[k]];
        Do[
          q=otherIdx[[h]];
          If[rayAbsLabel[p]=!=rayAbsLabel[q] ||
             rayAbsVariance[p]=!=-rayAbsVariance[q],Continue[]];
          remain=idx[[3-k]];
          If[name==="Metric" &&
             rayAbsVariance[idx[[1]]]=!=rayAbsVariance[idx[[2]]],
             Continue[]];
          If[name==="Metric" && other[[1]]==="Metric" &&
             Length[otherIdx]===2,
            free=otherIdx[[3-h]];
            newFactor=If[Head[remain]===RAYUp,
              RAYTensor["Delta",{remain,free}],
              RAYTensor["Delta",{free,remain}]],
            newIndices=ReplacePart[otherIdx,h->remain];
            newFactor=RAYTensor[other[[1]],newIndices]
          ];
          Throw[{True,Join[
            Delete[f,{{Max[i,j]},{Min[i,j]}},"RAYReduction"],{newFactor}]}],
          {h,Length[otherIdx]}],
        {k,2}],
      {j,n}],
    {i,n}
  ];
  {False,f}
],"RAYReduction"];

Options[RAYContract]={"Dimension"->Automatic,"MaxIterations"->32};
RAYContract[expr_,OptionsPattern[]] := Module[
 {dim=OptionValue["Dimension"],expanded=Expand[expr],
  terms,outs,factors,changed,next,k},
 If[dim===Automatic,
   dim=If[rayMetricQ[],rayDim[],Missing["NoDimension"]]];
 terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
 outs=Table[
   factors=rayAbsFactors[term];
   Do[
     {changed,next}=rayAbsReduceFactors[factors,dim];
     If[!TrueQ[changed],Break[]];
     factors=rayAbsFactors[Expand[Times@@next]];
     ,{k,OptionValue["MaxIterations"]}];
   Times@@factors,{term,terms}];
 RAYCanonicalize[Total[outs]]
];

RAYCovDCommutator[RAYTensor[name_String,idx_List],a_,b_] :=
 Module[{result=0,dummy,replaced,cur},
  If[name==="Metric" || name==="Delta",Return[0]];
  Do[
    cur=idx[[i]];
    If[!rayAbsIndexQ[cur],Continue[]];
    dummy=Unique["rayCurvIndex$"];
    If[Head[cur]===RAYUp,
      replaced=ReplacePart[idx,i->RAYUp[dummy]];
      result+=RAYTensor["Riemann",
        {cur,RAYDown[dummy],RAYDown[a],RAYDown[b]}]*
        RAYTensor[name,replaced],
      replaced=ReplacePart[idx,i->RAYDown[dummy]];
      result-=RAYTensor["Riemann",
        {RAYUp[dummy],cur,RAYDown[a],RAYDown[b]}]*
        RAYTensor[name,replaced]
    ],{i,Length[idx]}];
  RAYCanonicalize[result]
];
RAYCovDCommutator[expr_Plus,a_,b_] :=
  Map[RAYCovDCommutator[#,a,b]&,expr];
RAYCovDCommutator[expr_Times,a_,b_] :=
  Total[Table[
    Times@@ReplacePart[List@@expr,
      k->RAYCovDCommutator[(List@@expr)[[k]],a,b]],
    {k,Length[List@@expr]}]];
RAYCovDCommutator[expr_?NumericQ,a_,b_]:=0;
RAYCovDCommutator[expr_,a_,b_]:=0;

(* First Bianchi in a 4-lowered-index Levi-Civita Riemann:
   R_abcd + R_acdb + R_adbc = 0. Rewrite the lexicographically
   largest symmetry-reduced basis tensor into the other two. *)
rayAbsBianchiRule[labels_List] := Module[
  {a,b,c,d,terms,pairs,signs,bases,ord,largest,other},
  If[Length[DeleteDuplicates[labels]]=!=4,Return[Nothing]];
  {a,b,c,d}=SortBy[labels,rayAbsSortKey];
  terms={
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}],
    RAYTensor["Riemann",RAYDown/@{a,c,d,b}],
    RAYTensor["Riemann",RAYDown/@{a,d,b,c}]
  };
  pairs=rayAbsTensorNormalize/@terms;
  signs=If[Head[#]===Times,First[List@@#],1]& /@pairs;
  bases=If[Head[#]===Times,Last[List@@#],#]& /@pairs;
  If[!AllTrue[signs,MemberQ[{-1,1},#]&],Return[Nothing]];
  ord=Ordering[rayAbsSortKey/@bases];largest=Last[ord];other=Most[ord];
  bases[[largest]]->
    -Total[Map[(signs[[#]]/signs[[largest]])bases[[#]]&,other]]
];

RAYBianchiReduce[expr_] := Module[{current,sets,rules},
  current=RAYCanonicalize[expr];
  sets=DeleteDuplicates[
    SortBy[#,rayAbsSortKey]& /@
      Cases[current,RAYTensor["Riemann",
        {RAYDown[a_],RAYDown[b_],RAYDown[c_],RAYDown[d_]}] :>
        {a,b,c,d},Infinity]];
  rules=DeleteCases[rayAbsBianchiRule/@sets,Nothing];
  RAYCanonicalize[Expand[current/.rules]]
];

(* Convert a well-formed indexed tensor polynomial to an array of
   explicit components. Free index positions are supplied in order.
   RAYContract can be applied first. Uses active explicit metric. *)
RAYToComponents[expr_,free_List:{}] /; rayRequireMetric[]===True := Module[
  {d=rayDim[],names=rayAbsLabel/@free,out,tuples,comp},
  If[!AllTrue[free,rayAbsIndexQ] ||
     Length[DeleteDuplicates[names]]=!=Length[names],
    Return[rayFail["RAYToComponents: expected distinct RAYUp/RAYDown free indices."]]];
  If[free==={},Return[rayAbsEvaluate[expr,<||>,d]]];
  tuples=Tuples[Range[d],Length[free]];
  out=rayAbsEvaluate[expr,AssociationThread[names->#],d]&/@tuples;
  ArrayReshape[out,ConstantArray[d,Length[free]]]
];

rayAbsEvaluate[expr_,assign_Association,d_Integer] := Module[
  {expanded=Expand[expr],terms},
  terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
  Total[rayAbsEvaluateTerm[#,assign,d]&/@terms]
];

rayAbsEvaluateTerm[term_,assign_Association,d_Integer] := Module[
  {factors=rayAbsFactors[term],indices,groups,dummies,all,tuples},
  indices=Cases[term,RAYUp[x_]:>{x,1} |
    RAYDown[x_]:>{x,-1},Infinity];
  groups=GatherBy[indices,First];
  If[AnyTrue[groups,Length[#]>2 || (Length[#]===2 &&
        Sort[#[[All,2]]] =!= {-1,1})&],Return[$Failed]];
  dummies=First[First[#]]& /@Select[groups,Length[#]===2&];
  If[AnyTrue[Select[groups,Length[#]===1&],
      !KeyExistsQ[assign,First[First[#]]]&],Return[$Failed]];
  tuples=If[dummies==={},{{}},Tuples[Range[d],Length[dummies]]];
  Total[Table[
    all=Join[assign,AssociationThread[dummies->tp]];
    Times@@(rayAbsEvalFactor[#,all,d]&/@factors),
    {tp,tuples}]
  ]
];

rayAbsEvalFactor[RAYTensor[name_String,idx_List],all_Association,d_Integer] :=
  Module[{positions,config,tensor},
    positions=Lookup[all,rayAbsLabel/@idx,Missing["Index"]];
    If[MemberQ[positions,_Missing],Return[$Failed]];
    If[name==="Delta",
      Return[KroneckerDelta@@positions]];
    config=StringJoin[(If[Head[#]===RAYUp,"u","d"]&/@idx)];
    tensor=rayTensorByName[name,config];
    If[tensor===$Failed,Return[$Failed]];
    Extract[tensor,positions]
  ];
rayAbsEvalFactor[x_,all_,d_]:=x;

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYUp[i], RAYDown[i]","Explicit abstract-index variance markers; repeated up/down indices are contracted."},
 {"RAYDeclareSymmetry[name,kind]","Register symmetric/antisymmetric tensor slots."},
 {"RAYCanonicalize[expr]","Canonicalize tensor slot symmetries and rename contracted dummy indices."},
 {"RAYContract[expr]","Simplify metric, Kronecker-delta and Ricci contractions."},
 {"RAYIndexCheck[expr]","Check repeated-index variance and multiplicity."},
 {"RAYBianchiReduce[expr]","Reduce all-lowered Riemann expressions by the first Bianchi identity."},
 {"RAYCovDCommutator[tensor,a,b]","Formal Levi-Civita curvature commutator on a tensor."},
 {"RAYToComponents[expr,freeIndices]","Evaluate an indexed tensor polynomial with the active explicit geometry."}
}];
