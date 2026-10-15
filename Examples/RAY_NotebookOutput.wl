(* RAY notebook output demo — evaluate each section as its own cell. *)
Needs["RAY`"];

ClearAll[a,b,c,d,i,j,t,x];
expr=RAYTensor["A",{RAYUp[i]}]RAYTensor["B",{RAYDown[i]}]-
     RAYTensor["A",{RAYUp[j]}]RAYTensor["B",{RAYDown[j]}];

(* Notebook output: A^i B_i - A^j B_j, not function-head syntax. *)
expr
(* Show the underlying Wolfram input syntax: *)
expr // RAW
(* Symbolic operations are unchanged. *)
RAYCanonicalize[expr]   (* 0 *)

(* Tensor typography with correct free index positions. *)
RAYTensor["Metric",{RAYDown[a],RAYDown[b]}]
RAYTensor["Ricci",{RAYDown[a],RAYDown[b]}]
RAYTensor["Riemann",{RAYUp[a],RAYDown[b],RAYDown[c],RAYDown[d]}]
RAYAbstractCovD[RAYTensor["A",{RAYUp[b]}],a]

(* Optional explicit TraditionalForm rendering. *)
RAYPretty[RAYTensor["Delta",{RAYUp[a],RAYDown[b]}]]

(* Old geometry output -> raw InputForm. *)
RAYDefineMetric["Minkowski",{t,x},DiagonalMatrix[{-1,1}]];
RAYRicci["dd"]
RAYRicci["dd"] // RAW

(* Algebra-ready output without a display wrapper. *)
RAYRaw[RAYRicci["dd"]]
