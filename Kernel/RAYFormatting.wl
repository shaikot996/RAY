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

rayPrettyIndexBoxes[index_String,form_] := index;
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


rayPrettyGeometryLabel[name_String] := Switch[name,
 "External","ext","Internal","int","Fiber","fib",_,name];

rayPrettyTensorBase[name_String] := Module[{geometry,type},
 geometry=Which[
  StringStartsQ[name,"External"],"External",
  StringStartsQ[name,"Internal"],"Internal",
  StringStartsQ[name,"Fiber"],"Fiber",
  True,None];
 If[geometry===None,
  Return[StyleBox[rayPrettyTensorName[name],FontSlant->"Italic"]]];
 type=StringDrop[name,StringLength[geometry]];
 If[!MemberQ[{"Metric","Ricci","Einstein","Riemann","Weyl"},type],
  Return[StyleBox[name,FontSlant->"Italic"]]];
 SuperscriptBox[
   OverscriptBox[
    StyleBox[Switch[type,"Metric","g","Einstein","G","Weyl","C",_,"R"],
      FontSlant->"Italic"],"~"],
   rayPrettyGeometryLabel[geometry]]
];

RAYIntrinsicScalar /: MakeBoxes[RAYIntrinsicScalar[name_String],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=SubscriptBox[OverscriptBox["R","~"],
     rayPrettyGeometryLabel[name]]},
  InterpretationBox[pretty,RAYIntrinsicScalar[name],Editable->False]];

RAYCovariantHessian /: MakeBoxes[
 RAYCovariantHessian[expression_,i_,j_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{
  SubscriptBox["\[Del]",rayPrettyIndexBoxes[
    If[MatchQ[i,_RAYDown|_RAYUp],First[i],i],form]],
  SubscriptBox["\[Del]",rayPrettyIndexBoxes[
    If[MatchQ[j,_RAYDown|_RAYUp],First[j],j],form]],
  "(",MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYCovariantHessian[expression,i,j],
    Editable->False]];

RAYCovariantBox /: MakeBoxes[RAYCovariantBox[expression_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{"\[EmptySquare]","(",
   MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYCovariantBox[expression],Editable->False]];

RAYGradientNorm /: MakeBoxes[RAYGradientNorm[expression_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=SuperscriptBox[
  RowBox[{"(", "\[Del]",MakeBoxes[expression,form],")"}],"2"]},
  InterpretationBox[pretty,RAYGradientNorm[expression],Editable->False]];

RAYPartialD /: MakeBoxes[RAYPartialD[expression_,index_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{
    SubscriptBox["\[PartialD]",rayPrettyIndexBoxes[index,form]],
    "(",MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYPartialD[expression,index],Editable->False]];

rayPrettyTensorBoxes[name_String,indices_List,form_] := Module[
 {base,up,down,output,valid},
 base=rayPrettyTensorBase[name];
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
 With[{boxes=rayPrettyTensorBoxes[name,indices,form]},
   InterpretationBox[boxes,RAYTensor[name,indices],Editable->False]
 ];

RAYDummy /: MakeBoxes[RAYDummy[n_Integer],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=SubscriptBox["\[Lambda]",MakeBoxes[n,form]]},
   InterpretationBox[boxes,RAYDummy[n],Editable->False]
 ];

RAYUp /: MakeBoxes[RAYUp[index_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{"\[UpArrow]",MakeBoxes[index,form]}]},
   InterpretationBox[boxes,RAYUp[index],Editable->False]
 ];

RAYDown /: MakeBoxes[RAYDown[index_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{"\[DownArrow]",MakeBoxes[index,form]}]},
   InterpretationBox[boxes,RAYDown[index],Editable->False]
 ];

rayPrettyNablaBoxes[index_,expression_,form_] := Module[
 {label,indexBox,derivative,exprBox},
 label=If[MatchQ[index,RAYUp[_]|RAYDown[_]],First[index],index];
 indexBox=rayPrettyIndexBoxes[label,form];
 derivative=Which[
   MatchQ[index,_RAYDown],SubscriptBox["\[Del]",indexBox],
   MatchQ[index,_RAYUp],SuperscriptBox["\[Del]",indexBox],
   True,SubscriptBox["\[Del]",indexBox]
 ];
 exprBox=With[{heldExpr=expression},MakeBoxes[heldExpr,form]];
 RowBox[{derivative,"(",exprBox,")"}]
];
RAYNabla /: MakeBoxes[RAYNabla[index_,expression_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=rayPrettyNablaBoxes[index,expression,form]},
   InterpretationBox[boxes,RAYNabla[index,expression],Editable->False]
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
