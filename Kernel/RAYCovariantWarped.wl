(* ::Package:: *)
(* RAY warped product with an arbitrary coordinate-dependent base metric:
   G_AB = g_ab(x),  G_ij = Exp[2 B(x)] h_ij(y).
   Base d is explicitly coordinated (integer); fiber n can remain symbolic.
   Independent geometric derivation from Levi-Civita formulas, RAY convention.
   The external metric g_ab may itself contain A[t,x], off-diagonal terms,
   and a nontrivial lapse or spatial curvature. No time-only assumption. *)

Options[RAYCovariantWarpedMetric] = {
 "IntrinsicGeometry" -> "General",
 "Simplification" -> "Simplify",
 Assumptions -> True
};

RAYCovariantWarpedMetric[name_String,coordinates_List,baseMetric_List,
   n_,warp_,OptionsPattern[]] :=
 Module[{d=Length[coordinates],ass=OptionValue[Assumptions],
 mode=OptionValue["Simplification"],geometry=OptionValue["IntrinsicGeometry"],
 simp,baseRic,baseR,ricFullBase,ginv,baseGamma,gradient,hess,box,grad2,
 curvBase,curvInt,curvTensor,refMetric,warpCoefficient,
 metricInverse,baseEinstein,scalar,curv,computed,spatialRic,
 xx,yy},
 If[d<2 || Dimensions[baseMetric]=!={d,d},
  Return[rayFail["RAYCovariantWarpedMetric: base coordinates and metric matrix dimensions must agree, with d>=2."]]];
 If[NumericQ[n] && (!IntegerQ[n] || n<1),
  Return[rayFail["RAYCovariantWarpedMetric: n must be a positive integer or symbolic."]]];
 If[!FreeQ[warp,_RAYTensor|_RAYNabla|_RAYPartialD],
  Return[rayFail["RAYCovariantWarpedMetric: the warp factor must be a coordinate expression, not an abstract tensor."]]];
 If[!FreeQ[baseMetric,Indeterminate|ComplexInfinity],
  Return[rayFail["RAYCovariantWarpedMetric: invalid base metric components."]]];
 simp=Switch[mode,
  "None", Function[v,v],
  "Full",Function[v,FullSimplify[v,ass]],
  _,Function[v,Simplify[v,ass]]];
 computed=RAYDefineMetric[name,coordinates,baseMetric,
    Assumptions->ass,"Simplification"->mode];
 If[computed===$Failed,Return[$Failed]];
 baseRic=RAYRaw["Ricci","dd"];
 baseR=RAYRaw["RicciScalar"];
 ginv=RAYRaw["Metric","uu"];
 baseGamma=rayGamma[];
 gradient=Table[D[warp,coordinates[[a]]],{a,d}];
 hess=Table[
   D[warp,coordinates[[a]],coordinates[[b]]]-
    Sum[baseGamma[[c,a,b]] gradient[[c]],{c,d}],
   {a,d},{b,d}];
 box=simp[Tr[ginv.hess]];
 grad2=simp[gradient.ginv.gradient];
 hess=Map[simp,hess,{2}];
 curv=rayWarpGeometry[geometry,n,"Fiber"];
 If[curv===$Failed,
  Return[rayFail["RAYCovariantWarpedMetric: invalid intrinsic reference geometry."]]];
 curvInt=curv[[1]];
 curvTensor=curv[[2]];
 refMetric=curv[[3]];
 warpCoefficient=simp[box+n grad2];
 ricFullBase=Map[simp,baseRic-n(hess+Outer[Times,gradient,gradient]),{2}];
 scalar=simp[baseR+Exp[-2warp]curvInt-2n box-n(n+1)grad2];
 baseEinstein=Map[simp,ricFullBase-1/2 scalar baseMetric,{2}];
 spatialRic=simp[curvTensor-Exp[2warp]warpCoefficient refMetric];
 <|"Type"->"CovariantWarpedProduct",
  "Name"->name,"Coordinates"->coordinates,
  "BaseDimension"->d,"FiberDimension"->n,
  "TotalDimension"->d+n,"BaseMetric"->baseMetric,
  "InverseBaseMetric"->ginv,
  "Warp"->warp,
  "IntrinsicGeometry"->geometry,
  "IntrinsicRicciScalar"->curvInt,
  "IntrinsicRicciTensor"->curvTensor,
  "FiberReferenceMetric"->refMetric,
  "BaseRicciTensor"->baseRic,
  "BaseRicciScalar"->baseR,
  "WarpPartialDerivative"->gradient,
  "WarpCovariantHessian"->hess,
  "WarpCovariantLaplacian"->box,
  "WarpGradientSquared"->grad2,
  "FullBaseRicciTensor"->ricFullBase,
  "FullFiberRicciTensor"->spatialRic,
  "FullRicciScalar"->scalar,
  "FullBaseEinsteinTensor"->baseEinstein,
  "FullFiberEinsteinTensor"->simp[curvTensor-
      Exp[2warp](warpCoefficient+scalar/2)refMetric],
  "Assumptions"->ass|>
];

(* These are actual covariant components in the supplied base coordinates,
   while RAYPartialD is an unevaluated coordinate derivative marker.
   RAYNabla denotes an abstract covariant derivative, not a partial. *)
RAYPartialD[expression_Plus,index_] := Map[RAYPartialD[#,index]&,expression];
RAYPartialD[expression_?NumericQ,index_] := 0;


(* Deliberately do NOT overwrite the formal RAYNabla algebra or assert
   partial=covariant for non-scalar tensors. A scalar first derivative
   coincides only by evaluation using D[scalar,x]. *)

RAYCovariantWarpedReport[model_Association] /;
 Lookup[model,"Type",None]==="CovariantWarpedProduct" :=
 Column[{
   Style["General coordinate-dependent warped product",Bold,16],
   Grid[{
      {"Total dimension",model["TotalDimension"]},
      {"Covariant Hessian",RAYReadable[model["WarpCovariantHessian"]]},
      {"Covariant Laplacian",RAYReadable[model["WarpCovariantLaplacian"]]},
      {"Gradient norm",RAYReadable[model["WarpGradientSquared"]]},
      {"Ricci scalar",RAYReadable[model["FullRicciScalar"]]}
   },Frame->All,Alignment->Left],
   Style["Ricci tensor blocks",Bold,14],
   MatrixForm[model["FullBaseRicciTensor"]],
   RAYReadable[model["FullFiberRicciTensor"]]
 }];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYCovariantWarpedMetric[name,coords,g,n,B]","Exact warped Ricci from a coordinate-dependent base g_ab(x), with arbitrary symbolic fiber n and covariant Hessian."},
 {"RAYCovariantWarpedReport[model]","Readable coordinate-based warped Ricci/Hessian report."},
 {"RAYPartialD[expr,index]","Formal partial derivative (coordinate-based), distinct from RAYNabla covariant derivative."}
}];
