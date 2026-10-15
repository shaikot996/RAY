(* RAY 1.1.2 — readable warped-product curvature in Mathematica. *)
Needs["RAY`"];

ClearAll[t,x,y,z,A,B,P,Q];

RAYWarpedMetric["HumanWarp4D",{
 {{t},{{-1}},1},
 {{x},{{1}},Exp[2 A[t]]},
 {{y,z},{{P[y,z],0},{0,Q[y,z]}},Exp[2 B[t]]}
},"Simplification"->"Simplify"];

(* Preferred human-readable curvature output:
   coordinate-labeled nonzero tensor components, time dots, partials. *)
RAYRicci["dd"]
RAYRicciScalar[]

(* Optional old full matrix, with improved handwritten derivatives. *)
RAYRicci["dd","Matrix"]

(* Mathematica source syntax, e.g. A'[t], A''[t] and P[y,z]. *)
RAYRicciScalar[] // RAW
RAYRicci["dd"] // RAW

(* Raw arrays and scalars remain unchanged and algebra-ready. *)
ricci = RAYRaw["Ricci","dd"];
scalar = RAYRaw["RicciScalar"];
gInverse = RAYRaw["Metric","uu"];

FullSimplify[scalar-Tr[gInverse.ricci]]    (* 0 *)

(* Other computations can be displayed in handwritten form on demand. *)
RAYReadable[scalar]
RAYReadable[RAYRaw["Einstein","dd"][[1,1]]]

(* Exact raw Mathematica code for an abstract-index tensor. *)
RAYTensor["Riemann",{RAYUp[a],RAYDown[b],
                      RAYDown[c],RAYDown[d]}] // RAW
