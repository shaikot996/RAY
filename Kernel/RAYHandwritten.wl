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
   box=MakeBoxes[pretty,TraditionalForm];
   InterpretationBox[box,expr,Editable->False]
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
 If[Length[rows]>maxRows,Take[rows,maxRows],rows]
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
  InterpretationBox[boxes,data,Editable->False]
 ];

RAYReadableTensor[array_List,name_String:"Tensor",
 config_String:"dd"] :=
 RAYComponentDisplay[array,name,config];

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

(* Uniform handwritten presentation of scalar invariants. *)
RAYKretschmann[] /; rayRequireMetric[]===True :=
 RAYReadable[rayKretschmann[]];
RAYRicciSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayRicciSquared[]];
RAYWeylSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayWeylSquared[]];

(* Make RAYComponentDisplay and RAYHandwritten unwrap to their
   algebraic payload. RAW uses Mathematica StandardForm rather
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

RAW[expression_] := StandardForm[
  rayRemoveDisplayWrappers[expression]];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYReadable[expr]","Readable math with dot time derivatives, partial derivative fractions and collected warp factors."},
 {"RAYReadableTensor[matrix,name,config]","List nonzero coordinate-indexed tensor components as equations."},
 {"RAYRicci[dd]","Readable nonzero Ricci components, preserving full underlying tensor data."},
 {"RAW[expr] (or expr // RAW)","Mathematica StandardForm source: primes for time derivatives, square bracket input, full raw tensor arrays."}
}];
