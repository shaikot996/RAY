(* ::Package:: *)
(* RAY notebook presentation, v1.1.1.
   These rules affect notebook BOXES only. All tensors remain untouched
   Wolfram expressions usable by RAYCanonicalize, RAYContract, etc.
   The InterpretationBox retains an exact, copyable interpretation.
   InputForm intentionally remains unaffected so RAW exposes the code. *)

rayPrettyTensorName[name_String] := Switch[name,
  "Metric", "g",
  "InverseMetric", "g",
  "Riemann", "R",
  "Ricci", "R",
  "RicciScalar", "R",
  "Einstein", "G",
  "Weyl", "C",
  "Delta", "\[Delta]",
  "Shear", "\[Sigma]",
  "Vorticity", "\[Omega]",
  "Christoffel", "\[CapitalGamma]",
  _, name
];

rayPrettyIndexBoxes[index_,form_] := MakeBoxes[index,form];

rayPrettyScript[indices_List,form_] := Module[
 {uppers,lowers,upBoxes,downBoxes},
 uppers=Cases[indices,RAYUp[index_] :> index,{1}];
 lowers=Cases[indices,RAYDown[index_] :> index,{1}];
 upBoxes=rayPrettyIndexBoxes[#,form]& /@ uppers;
 downBoxes=rayPrettyIndexBoxes[#,form]& /@ lowers;
 {
   If[upBoxes==={},None,RowBox[upBoxes]],
   If[downBoxes==={},None,RowBox[downBoxes]]
 }
];

rayPrettyTensorBoxes[name_String,indices_List,form_] := Module[
 {base,up,down,output,valid},
 base=StyleBox[rayPrettyTensorName[name],FontSlant->"Italic"];
 valid=AllTrue[indices,MatchQ[#,_RAYUp|_RAYDown]&];
 If[!valid,
   Return[RowBox[{"RAYTensor","[",
     RowBox[{MakeBoxes[name,form],",",MakeBoxes[indices,form]}],"]"}]]];
 {up,down}=rayPrettyScript[indices,form];
 output=Which[
   up===None && down===None,base,
   down===None,SuperscriptBox[base,up],
   up===None,SubscriptBox[base,down],
   True,SubsuperscriptBox[base,down,up]
 ];
 output
];

RAYTensor /: MakeBoxes[RAYTensor[name_String,indices_List],
   form:(StandardForm|TraditionalForm)] :=
 InterpretationBox[
   rayPrettyTensorBoxes[name,indices,form],
   RAYTensor[name,indices],
   Editable->False
 ];

RAYDummy /: MakeBoxes[RAYDummy[n_Integer],
   form:(StandardForm|TraditionalForm)] :=
 InterpretationBox[
   SubscriptBox["\[Lambda]",MakeBoxes[n,form]],
   RAYDummy[n],
   Editable->False
 ];

RAYUp /: MakeBoxes[RAYUp[index_],
   form:(StandardForm|TraditionalForm)] :=
 InterpretationBox[
   RowBox[{"\[UpArrow]",MakeBoxes[index,form]}],
   RAYUp[index],
   Editable->False
 ];

RAYDown /: MakeBoxes[RAYDown[index_],
   form:(StandardForm|TraditionalForm)] :=
 InterpretationBox[
   RowBox[{"\[DownArrow]",MakeBoxes[index,form]}],
   RAYDown[index],
   Editable->False
 ];

rayPrettyNablaBoxes[index_,expression_,form_] := Module[
 {script,derivative,exprBox},
 script=Switch[Head[index],
   RAYDown,SubscriptBox["\[Del]",MakeBoxes[index[[1]],form]],
   RAYUp,SuperscriptBox["\[Del]",MakeBoxes[index[[1]],form]],
   _,SubscriptBox["\[Del]",MakeBoxes[index,form]]
 ];
 exprBox=MakeBoxes[expression,form];
 RowBox[{script,"(",exprBox,")"}]
];

RAYNabla /: MakeBoxes[RAYNabla[index_,expression_],
   form:(StandardForm|TraditionalForm)] :=
 InterpretationBox[
   rayPrettyNablaBoxes[index,expression,form],
   RAYNabla[index,expression],
   Editable->False
 ];

(* Pretty is optional: abstract tensor results already typeset themselves.
   Unlike InputForm, TraditionalForm intentionally provides human notation. *)
RAYPretty[expression_] := TraditionalForm[expression];

(* Any nested TraditionalForm / MatrixForm / TableForm supplied by RAY
   is removed before displaying the exact underlying Wolfram input. *)
rayRemoveDisplayWrappers[expression_] := FixedPoint[
  ReplaceAll[#,{
    HoldPattern[TraditionalForm[x_]] :> x,
    HoldPattern[MatrixForm[x_,___]] :> x,
    HoldPattern[TableForm[x_,___]] :> x,
    HoldPattern[StandardForm[x_]] :> x,
    HoldPattern[InputForm[x_]] :> x
  }]&,
  expression,
  12
];

(* Postfix: a formatted expression // RAW.
   The result is an InputForm DISPLAY for copy/paste. For programmatic
   algebra use the original expression or RAYRaw[...]. *)
RAW[expression_] := InputForm[rayRemoveDisplayWrappers[expression]];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAW[expr] (or expr // RAW)","Display the exact underlying Wolfram Language expression in input notation; strips common presentation wrappers."},
 {"RAYPretty[expr] (or expr // RAYPretty)","Display notebook-friendly traditional mathematical notation."},
 {"RAYTensor[name,indices]","Automatically typeset A^a, g_ab, R^a_bcd, etc. in StandardForm and TraditionalForm."},
 {"RAYNabla[index,expr]","Automatically typeset a covariant derivative with upper/lower derivative index."}
}];
