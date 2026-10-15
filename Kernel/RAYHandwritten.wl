(* ::Package:: *)
(* Human-readable curvature/field-equation presentation.
   Presentation wrappers preserve the exact Mathematica expression.
   No curvature values, geometry data or tensor algorithms are modified. *)

Options[RAYReadable] = {"FactorTimeWarp" -> True};

rayHandTimeQ[x_] := MatchQ[x,_Symbol] &&
  MemberQ[{"t","time","tau","\[Tau]"},SymbolName[Unevaluated[x]]];

rayHandDerivative[f_, orders_List, args_List] := Module[
  {nn=Total[orders], vars, pairs, bare=f},
  If[Length[orders]=!=Length[args] || nn===0,
    Return[(Derivative@@orders)[f]@@args]];
  If[Length[args]===1 && rayHandTimeQ[First[args]] &&
     1<=nn<=3,
    Return[(Nest[OverDot,bare,nn])@@args]];
  pairs=MapThread[If[#2===1,#1,{#1,#2}]&,{args,orders}];
  pairs=MapThread[If[#2===0,Nothing,
    If[#2===1,#1,{#1,#2}]]&,{args,orders}];
  Inactive[D][f@@args,Sequence@@pairs]
];

(* Replace ordinary Derivative[n1,n2,...][f][args] only for display.
   Inactive[D] renders conventional partial derivative fractions. *)
rayHandExpression[expr_] := expr /. HoldPattern[
  Derivative[orders__Integer][f_][args__]] :>
   rayHandDerivative[f,{orders},{args}];

rayReadableWarpFactors[expr_] :=
 DeleteDuplicates@Cases[Unevaluated[expr],
   e:Power[E,ex_] /;
     !FreeQ[ex,_Symbol?(rayHandTimeQ)] :> e,
   Infinity];

rayReadableSimplify[expr_,factorWarp_:True] := Module[
 {res=expr,exps},
 If[!TrueQ[factorWarp] || LeafCount[Unevaluated[expr]]>1200,
   Return[expr]];
 exps=rayReadableWarpFactors[expr];
 If[exps==={},Return[expr]];
 res=Quiet@Check[
   Collect[Expand[expr],exps,Simplify],expr];
 If[LeafCount[res] > 2 LeafCount[expr],expr,res]
];

(* The Mathematica-generated StandardForm boxes remain the RAW mode.
   Readable mode uses TraditionalForm with dot notation for time derivatives
   and explicit partials for multivariable functions. *)
RAYReadable[expression_,OptionsPattern[]] :=
  RAYHandwritten[rayReadableSimplify[expression,
   OptionValue["FactorTimeWarp"]]];

RAYHandwritten /: MakeBoxes[RAYHandwritten[expr_],
   fmt:(StandardForm|TraditionalForm)] :=
 Module[{pretty,box},
   pretty=rayHandExpression[expr];
   box=With[{displayExpr=pretty},MakeBoxes[displayExpr,TraditionalForm]];
   With[{rendered=box},InterpretationBox[rendered,expr,Editable->False]]
 ];

rayReadableComponentLabel[name_String,config_String,indices_List] :=
 Module[{coords,up,down,symbol,bxUp,bxDown},
  coords=rayCoords[];
  symbol=Switch[name,"Ricci","R","Einstein","G",
    "Metric","g","StressTensor","T",_,name];
  up=Pick[coords[[indices]],Characters[config],"u"];
  down=Pick[coords[[indices]],Characters[config],"d"];
  bxUp=If[up==={},None,RowBox[MakeBoxes[#,TraditionalForm]&/@up]];
  bxDown=If[down==={},None,RowBox[MakeBoxes[#,TraditionalForm]&/@down]];
  Which[
   bxDown===None && bxUp===None,symbol,
   bxDown===None,SuperscriptBox[symbol,bxUp],
   bxUp===None,SubscriptBox[symbol,bxDown],
   True,SubsuperscriptBox[symbol,bxDown,bxUp]
  ]
 ];

rayReadableComponentRows[data_List,config_String,name_String,
 maxRows_Integer:36] := Module[
 {d=Length[data],rows={},v},
 Do[
   v=data[[i,j]];
   If[!TrueQ[v===0] && !TrueQ[PossibleZeroQ[v]],
     AppendTo[rows,{rayReadableComponentLabel[name,config,{i,j}],v}]],
   {i,d},{j,d}];
 rows
];

RAYComponentDisplay /: MakeBoxes[
  RAYComponentDisplay[data_List,name_String,config_String],
  fmt:(StandardForm|TraditionalForm)] :=
 Module[{rows,formatted,boxes,header,max=36},
  rows=rayReadableComponentRows[data,config,name,max];
  formatted=Table[
   With[{lab=rows[[k,1]],
       val=rayReadableSimplify[rows[[k,2]]]},
     {
      lab,
      "=",
      MakeBoxes[RAYHandwritten[val],StandardForm]
     }],
   {k,Length[rows]}];
  boxes=If[rows==={},
   MakeBoxes[Style["All components vanish.",Italic,12],StandardForm],
   GridBox[formatted,
     ColumnAlignments->{"Right","Center","Left"},
     RowSpacings->1.4,ColumnSpacings->1.3]
  ];
  With[{rendered=boxes},InterpretationBox[rendered,data,Editable->False]]
 ];

RAYReadableTensor[array_List,name_String:"Tensor",
 config_String:"dd"] :=
 RAYComponentDisplay[array,name,config];

(* Also improve the explicit pretty-print command: it remains a display
   wrapper, but multivariable derivatives now use partial fractions. *)
RAYPretty[expression_] := RAYReadable[expression];

(* The default tensor display shows readable nonzero components.
   Use RAYRaw for actual arrays; MatrixForm[RAYRaw[...]] for full matrices.
   RAW of this display unwraps the entire original array. *)
RAYRicci[config_String] /; rayRequireMetric[]===True :=
 Module[{data=rayTensorByName["Ricci",config]},
   If[data===$Failed,Return[$Failed]];
   RAYComponentDisplay[data,"Ricci",config]
 ];

RAYEinstein[config_String] /; rayRequireMetric[]===True :=
 Module[{data=rayTensorByName["Einstein",config]},
   If[data===$Failed,Return[$Failed]];
   RAYComponentDisplay[data,"Einstein",config]
 ];

RAYRicciScalar[] /; rayRequireMetric[]===True :=
 RAYReadable[rayRicciScalar[]];


(* Consistent readable boxes for every legacy MatrixForm result and all
   sparse curvature/kinematic grids, not just Ricci and Einstein. *)
rayDisplayMatrix[array_] := RAYHandwritten[MatrixForm[array]];
rayDisplayVector[array_] := RAYHandwritten[array];

rayNonzeroGrid[array_,cfg_List,symbol_,title_String] := Module[
 {d=rayDim[],rank=Length[cfg],tuples,rows},
 tuples=Tuples[Range[0,d-1],rank];
 rows=Reap[Do[
   With[{v=raySimp[rayComponent[array,inds]]},
     If[!TrueQ[v===0] && !TrueQ[PossibleZeroQ[v]],
       Sow[{rayIndexLabel[symbol,inds,cfg],RAYReadable[v]}]]],
   {inds,tuples}]][[2]];
 rows=If[rows==={}, {},First[rows]];
 Column[{
   Style[title,Bold,15],
   If[rows==={},
     Style["All components vanish.",Italic,13],
     Grid[Prepend[rows,
       {Style["Component",Bold],Style["Value",Bold]}],
       Frame->All,Alignment->{{Center,Left}},
       Spacings->{2,1},ItemSize->{{Automatic,UpTo[80]},Automatic}]
   ]
 },Spacings->0.8]
];

(* Component calls remain compact mathematical expressions; full matrices
   remain accessible as MatrixForm[RAYRaw["Ricci","dd"]]. *)
RAYRicci[config_String,mu_Integer,nu_Integer] /;
 rayRequireMetric[]===True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu],Return[$Failed]];
  data=rayTensorByName["Ricci",config];
  If[data===$Failed,Return[$Failed]];
  RAYReadable[data[[mu+1,nu+1]]]
];

RAYEinstein[config_String,mu_Integer,nu_Integer] /;
 rayRequireMetric[]===True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu],Return[$Failed]];
  data=rayTensorByName["Einstein",config];
  If[data===$Failed,Return[$Failed]];
  RAYReadable[data[[mu+1,nu+1]]]
];

(* Explicit opt-in to legacy full-matrix layout in handwritten notation. *)
RAYRicci[config_String,"Matrix"] /;
 rayRequireMetric[]===True :=
  RAYHandwritten[MatrixForm[rayTensorByName["Ricci",config]]];
RAYEinstein[config_String,"Matrix"] /;
 rayRequireMetric[]===True :=
  RAYHandwritten[MatrixForm[rayTensorByName["Einstein",config]]];


(* Uniform handwritten presentation of scalar invariants. *)
RAYKretschmann[] /; rayRequireMetric[]===True :=
 RAYReadable[rayKretschmann[]];
RAYRicciSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayRicciSquared[]];
RAYWeylSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayWeylSquared[]];

(* Make RAYComponentDisplay and RAYHandwritten unwrap to their
   algebraic payload. RAW uses Mathematica StandardForm boxes rather
   than InputForm because StandardForm renders f'[t] instead of
   Derivative[1][f][t], and is the notebook's normal input syntax. *)
rayRemoveDisplayWrappers[expression_] := FixedPoint[
  ReplaceAll[#,{
    HoldPattern[RAYComponentDisplay[array_,___]] :> array,
    HoldPattern[RAYHandwritten[x_]] :> x,
    HoldPattern[TraditionalForm[x_]] :> x,
    HoldPattern[MatrixForm[x_,___]] :> x,
    HoldPattern[TableForm[x_,___]] :> x,
    HoldPattern[StandardForm[x_]] :> x,
    HoldPattern[InputForm[x_]] :> x
  }]&,
  expression,
  12
];

(* StandardForm itself would reapply the pretty RAYTensor MakeBoxes rules.
   Temporarily localize those definitions to show ACTUAL Mathematica input
   while still using primes for derivatives and square brackets for calls. *)
RAYNotebookInput /: MakeBoxes[
  RAYNotebookInput[expr_],
  fmt:(StandardForm|TraditionalForm)] :=
 Module[{boxes},
  boxes=Block[{RAYTensor,RAYUp,RAYDown,RAYNabla,RAYDummy},
    With[{source=expr},MakeBoxes[source,StandardForm]]];
  With[{rendered=boxes},
    InterpretationBox[rendered,expr,Editable->False]]
 ];

RAW[expression_] :=
  RAYNotebookInput[rayRemoveDisplayWrappers[expression]];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYReadable[expr]","Readable math with dot time derivatives, partial derivative fractions and collected warp factors."},
 {"RAYReadableTensor[matrix,name,config]","List nonzero coordinate-indexed tensor components as equations."},
 {"RAYRicci[dd]","Readable nonzero Ricci components, preserving full underlying tensor data."},
 {"RAW[expr] (or expr // RAW)","Mathematica notebook input syntax: primes, square brackets, complete raw expressions and unformatted RAYTensor code."}
}];
