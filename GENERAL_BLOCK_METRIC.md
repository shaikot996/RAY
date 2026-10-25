# RAY 1.5.0: unrestricted d+n block-diagonal metric

## Exact scope

The fully generalized metric is

\[
ds_D^2=e^{2A(x,y)}\hat g_{\mu\nu}(x,y)dx^\mu dx^\nu+
 e^{2B(x,y)}\tilde g_{mn}(x,y)dy^m dy^n,\quad D=d+n.
\]

Both warp functions and **both reference metrics** can independently depend on all x and y. In particular, arbitrary \(\tilde g_{mn}(t,y)\) is supported without an Einstein, Kähler, constant-curvature, isotropy, or diagonal reference-metric restriction. The **full D-dimensional metric is block-diagonal**; off-block \(g_{\mu m}\) vectors are not part of this ansatz.

Write \(H_{\mu\nu}=e^{2A}\hat g_{\mu\nu}\), \(Q_{mn}=e^{2B}\tilde g_{mn}\). Define

\[
C_{m\mu\nu}=\tfrac12\partial_m H_{\mu\nu}
=e^{2A}[(\partial_m A)\hat g_{\mu\nu}+\tfrac12\partial_m\hat g_{\mu\nu}],
\]

\[
K_{\mu mn}=\tfrac12\partial_\mu Q_{mn}
=e^{2B}[(\partial_\mu B)\tilde g_{mn}+\tfrac12\partial_\mu\tilde g_{mn}].
\]

Put \(C_m=H^{\mu\nu}C_{m\mu\nu}\), \(K_\mu=Q^{mn}K_{\mu mn}\). All contractions below use full induced H and Q, not fixed reference tensors. \(D^H\) and \(D^Q\) denote the respective induced Levi-Civita derivatives at fixed y and fixed x:

\[
\begin{aligned}
R_{\mu\nu}&=R[H]_{\mu\nu}-D^H_\nu K_\mu
-K_\mu{}^m{}_pK_\nu{}^p{}_m
-D^Q_mC^m{}_{\mu\nu}-C_mC^m{}_{\mu\nu}
+2C_{m\mu\rho}C^{m\rho}{}_\nu,\\
R_{mn}&=R[Q]_{mn}-D^Q_n C_m
-C_m{}^\mu{}_\rho C_n{}^\rho{}_\mu
-D^H_\mu K^\mu{}_{mn}-K_\mu K^\mu{}_{mn}
+2K_{\mu mp}K^{\mu p}{}_n,\\
R_{\mu m}&=D^H_\rho C_m{}^\rho{}_\mu-\partial_\mu C_m
+D^Q_p K_\mu{}^p{}_m-\partial_m K_\mu
+K_\rho C_m{}^\rho{}_\mu
+C_p K_\mu{}^p{}_m-2 C_p{}^\rho{}_\mu K_\rho{}^p{}_m.
\end{aligned}
\]

\(R=H^{\mu\nu}R_{\mu\nu}+Q^{mn}R_{mn}\);
\(G_{MN}=R_{MN}-\tfrac12g_{MN}R\). The abstract C/K representation is exact in arbitrary symbolic d+n dimensions and includes intrinsic curvatures of both y-dependent and x-dependent blocks. Its covariant derivatives are **not** replaced by partial derivatives without connection corrections.

## Abstract Mathematica

~~~mathematica
Needs["RAY`"];
ClearAll[d,n,A,B];
geo=RAYGeneralBlockGeometry[d,n,A,B];
RAYGeneralBlockReport[geo]
geo["RicciScalar"] // RAYPretty
geo["RicciMixed"] // RAYPretty
~~~

You may pass explanatory reference names with "ExternalReferenceMetric" and "InternalReferenceMetric"; these labels do not alter the abstract formulas. A literal reference matrix is required for component evaluation. The general C/K abstract mode intentionally supports "DerivativeForm"->"Covariant" only, to avoid representing non-tensor partial derivatives as covariant derivatives.

## Explicit reference metric with t,y dependence

~~~mathematica
ClearAll[t,x,y,z];
geo=RAYGeneralBlockGeometry[2,2,0,0];
result=RAYGeneralBlockToComponents[
 geo,"TimeDependentInternal",
 {t,x},{y,z},
 DiagonalMatrix[{-1,1+y^2}],
 DiagonalMatrix[{1+t^2,1+t*y}],
 "Verify"->True
];

result["Verified"]         (* True *)
result["Residuals"]        (* zero matrices and zero scalar *)
result["InducedK"][[1,1,1]]   (* t *)
result["InducedK"][[1,2,2]]   (* y/2 *)
result["RicciTensor"] // MatrixForm
result["EinsteinTensor"] // MatrixForm
~~~

RAY independently constructs the full Levi-Civita curvature and compares **all** Ricci blocks, the Ricci scalar and **all** Einstein blocks to the C/K formulas.

Another independent validation used d=2,n=1, A=t*y, B=x*y,
hat g=diag(-1,1+y^2), tilde g=1+t^2+y^2.
All curvature residuals vanish.

## Old special cases and limitations

RAYDoubleWarpedGeometry and RAYCrossWarpedGeometry are preserved. With fixed base/fiber reference metrics, the v1.5.0 full block formula reduces to v1.4.0 doubly twisted formula; direct 1+1 Ricci, Ricci scalar and Einstein components agree exactly. The block component bridge activates the explicit full metric for existing RAY geometric, matter and Einstein-equation commands. The existing RAYSolve supports reduced ODEs, **not arbitrary PDE evolution**.

## Automatic update upon Needs

Once **v1.5.0** is installed as the single RAY.wl file, every fresh Mathematica kernel doing

~~~mathematica
Needs["RAY`"];
RAYVersion
~~~

checks latest GitHub release. If newer, the loader downloads RAY.wl, verifies the raw-byte SHA256 against SHA256SUMS.txt, backs up the current file to RAY.wl.previous, atomically replaces it and reloads new code into the **same** kernel. On offline access, missing checksum, or checksum mismatch, existing RAY loads intact. To opt out **before Needs**:

~~~mathematica
Global`$RAYAutoUpdateOnLoad=False;
Needs["RAY`"];
~~~

Versions <=1.4.0 need a **one-time manual installation of v1.5.0**, because their older Needs loader does not have auto-check support. A second Needs call within the same kernel is a no-op by Mathematica design; restart kernel to check again. The release manifest is authenticated only insofar as the GitHub repository itself is trusted; SHA256 from the same publisher is not an independent signature.

## Verification

Independently checked in the Wolfram Language kernel with 1+1, 2+1, and 2+2 arbitrary internal metric examples, including nontrivial y-dependence of the external metric, t/y-dependence of the internal metric and mixed warp derivatives. A simulated v1.4.9 -> v1.5.0 Needs-time update confirmed that **both the installed source and active RAYVersion** become v1.5.0; a bad SHA256 leaves existing v1.4.9 intact. Existing tests and 62 numerical/geometric benchmarks remain in the repository.

See also the mathematical framework of coordinate-dependent Kaluza-Klein metrics: https://doi.org/10.1016/j.geomphys.2003.10.001
