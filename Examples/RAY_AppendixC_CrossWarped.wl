(* RAY v1.3.0 — paper-style covariant crossed double warp. *)
(* arXiv:2512.19793 Appendix C (C.20)-(C.26), generalized d+n.
   Use fresh Mathematica kernel and latest standalone asset. *)
Get[FileNameJoin[{$HomeDirectory,"Downloads","RAYStandalone.wl"}]];
RAYVersion

(* The metric convention is:
   ds^2 = Exp[2 A(y)] hat[g]_(mu nu)(x) dx^mu dx^nu
        + Exp[2 B(x)] tilde[g]_(mn)(y) dy^m dy^n.
   The symbols A, B are abstract scalar fields on different factors;
   no explicit matrices or fixed d,n are required. *)
ClearAll[d,n,A,B];

(* CHUNK 1: fully symbolic d+n and covariant Hessians *)
geo=RAYCrossWarpedGeometry[
 d,n,A,B,"DerivativeForm"->"Covariant"];

geo["TotalDimension"]            (* d+n *)
geo["RicciExternal"] // RAYPretty
geo["RicciInternal"] // RAYPretty
geo["RicciMixed"] // RAYPretty
geo["RicciScalar"] // RAYPretty

(* CHUNK 2: Einstein tensors are ALSO pure symbolic. *)
geo["EinsteinExternal"] // RAYPretty
geo["EinsteinInternal"] // RAYPretty
geo["EinsteinMixed"] // RAYPretty

(* All seven formulas as a mathematically typeset table *)
RAYCrossWarpedReport[geo]

(* CHUNK 3: exact conversion to partials plus the connection.
   It NEVER silently discards Gamma. *)
partial=RAYCrossWarpedGeometry[
 d,n,A,B,"DerivativeForm"->"Partial"];

partial["RicciExternal"] // RAYPretty
partial["RicciInternal"] // RAYPretty
partial["RicciMixed"] // RAYPretty
partial["RicciScalar"] // RAYPretty

(* Checks that all transformed expressions are algebraically identical *)
keys={"RicciExternal","RicciInternal","RicciMixed","RicciScalar",
 "EinsteinExternal","EinsteinInternal","EinsteinMixed"};
Table[Expand[RAYCrossToCovariant[partial[key]]-geo[key]],{key,keys}]
(* Seven zeros *)

(* CHUNK 4: specialize to paper's four-plus-six case. *)
paper=RAYCrossWarpedGeometry[4,6,A,B];
paper["RicciExternal"] // RAYPretty     (* Appendix C.23 *)
paper["RicciInternal"] // RAYPretty     (* Appendix C.24 *)
paper["RicciMixed"] // RAYPretty        (* Appendix C.25 *)
paper["RicciScalar"] // RAYPretty       (* Appendix C.26 *)
paper["EinsteinExternal"] // RAYPretty  (* Appendix C.20 *)
paper["EinsteinInternal"] // RAYPretty  (* Appendix C.21 *)
paper["EinsteinMixed"] // RAYPretty     (* Appendix C.22 *)

(* CHUNK 5: when A=0 the crossed warp reduces to the usual
   covariant base/fiber warped product (external x-dependent B).
   Do not substitute A=0 for arbitrary fiber reference curvature
   without also respecting the reference tensors. *)

(* CHUNK 6: download latest published standalone whenever RAY updates.
   The download is SHA256-verified, previous local file backed up.
   This does NOT execute newly downloaded WL code. *)
RAYUpdateStandalone[]
(* Restart Mathematica kernel, then load the file to activate update. *)
