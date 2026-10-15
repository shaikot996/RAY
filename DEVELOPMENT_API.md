# RAY development API

**Version:** 1.1.0. The explicit-component API is retained while matter, numerical and symbolic tools extend the package.

## 1. Raw expressions

~~~mathematica
Needs["RAY`"];
RAYRaw["Ricci","dd"]
RAYRaw[RAYRicci,"dd"]
RAYRaw[RAYRicci["dd"]]
RAYRaw[RAYRicci["dd",0,0]]
RAYRaw[RAYEinstein["dd"]]
~~~

Return values are algebra-ready expressions, not formatted wrappers. Physical component indices are 0-based (unlike 1-based Mathematica Part positions).

## 2. Explicit matter Lagrangian to stress tensor

~~~mathematica
RAYDefineMetric["Minkowski2",{t,x},DiagonalMatrix[{-1,1}]];
q=RAYMetricVariables[];
Lm=-1/2 (
  q[[1,1]] D[phi[t,x],t]^2
 +2 q[[1,2]] D[phi[t,x],t] D[phi[t,x],x]
 +q[[2,2]] D[phi[t,x],x]^2
 )-V[phi[t,x]];
matter=RAYMatterAction[Lm];
matter["Lagrangian"]
RAYStressTensor["dd"]
RAYStressTensor["dd",0,1]
RAYRaw["StressTensor","dd"]
~~~

Matter convention: T_ab = g_ab L_m - 2 delta L_m/delta g^ab. Symmetric inverse-metric variables account for off-diagonal terms correctly.

Convenience constructors:

~~~mathematica
RAYMatterAction[RAYScalarLagrangian[phi[t,x],V[phi[t,x]]]];
RAYMatterAction[RAYMaxwellLagrangian[{{0,E0},{-E0,0}}]];
~~~

Scope: Hilbert variation for matter Lagrangians with algebraic inverse-metric dependence and explicit field derivatives. Derivative-of-metric, curvature-coupled, spinor/vielbein and connection variations are not yet implemented.

## 3. Einstein equations

~~~mathematica
G=RAYRaw[RAYEinstein["dd"]];
T=RAYRaw["StressTensor","dd"];

eqs=RAYEinsteinEquations[G,T,
 "Coupling"->kappa,
 "CosmologicalConstant"->lambda,
 "Components"->"UpperTriangle"];

vacuum=RAYEinsteinEquations[G];
eqData=RAYEinsteinEquations[G,T,"Return"->"Association"];
~~~

Builds G_ab + Lambda g_ab = kappa T_ab. Missing T defaults to zero. Select "UpperTriangle", "Diagonal", "All" or a list of 0-based index pairs. "DropIdentities"->True omits identities. "Return"->"Residuals" returns residual expressions.

## 4. Multi-IC numerical evolution

~~~mathematica
sol=RAYSolve[
 {u''[t]+u[t]==0},{u},{t,0,12},
 {
  {u[0]==0,u'[0]==1},
  {u[0]==1,u'[0]==0},
  {u[0]==2,u'[0]==0}
 }
];

RAYPlot[sol,{u[t],u'[t]},
 "Colors"->{Blue,Red},
 "Frame"->True,
 "FrameLabel"->{"t","value"}];
~~~

**Plots:** the same quantity keeps the same color across IC sets. Default IC line styles are **solid, dotted, dashed, dot-dashed**. Other options: "LineStyles", "QuantityLabels", "ICLabels", "Frame", "Axes", "FrameLabel", "AxesLabel", "PlotLegends", "PlotRange", "PlotLabel", "ImageSize", "GridLines" and "AspectRatio".

RAYSolve forwards "Method", "WorkingPrecision", "AccuracyGoal", "PrecisionGoal" and "MaxSteps" to NDSolve. Use "Plot"->True, "PlotFields"->... and "PlotOptions"->{...} for single-call solving plus a plot.

~~~mathematica
RAYSolveWizard[{u''[t]+u[t]==0},{u},{t,0,12}]
~~~

The wizard opens an interactive notebook dialog for initial conditions, whether to plot, and requested quantities. In a script/headless kernel use RAYSolve. For a constrained Einstein system, choose a consistent set of dynamical equations and verify the constraints separately.

## 5. Explicit derivatives, warped products, conventions

~~~mathematica
RAYDefineMetric["Polar2",{r,theta},DiagonalMatrix[{1,r^2}]];
RAYCovD[RAYRaw["Metric","dd"],"dd"]

RAYWarpedMetric["Warped1Plus1",{
 {{t},{{-1}},1},
 {{x},{{1}},Exp[2 beta[t]]}
}];
RAYConventions[]
~~~

RAYCovD prepends the lower covariant-derivative index. Warped blocks are {coordinateList, blockMetric, fullMultiplier}; use Exp[2 beta[t]] if that is the factor in the line element.

## 6. Abstract symbolic prototype

~~~mathematica
geom=RAYSymbolicMetric["M",4,"Signature"->{-1,1,1,1}];
RAYAbstractCovD[RAYTensor["A",{a}] RAYTensor["B",{b}],c];

generic=RAYSymbolicMetric["D",{t,x,y,z},
  "Symmetry"->"Diagonal"];
RAYInstantiateMetric[generic];
~~~

Currently supports formal tensor placeholders, covariant product rule, linearity and metric compatibility. Einstein summation, dummy-index canonicalization, covariant-derivative commutators and xAct-like curvature manipulation are future work, not implemented here.

## Tests and examples

- Tests/RAY_Tests.wl: original regression suite.
- Tests/RAY_Development_Tests.wl: new functionality.
- Examples/RAY_Development.wl: complete usage walkthrough.

The new 8-case suite ran in a Wolfram kernel successfully after fixing stress-tensor dispatch.


## 7. Abstract-index algebra, first Bianchi and contractions (v1.1.0)

Use explicit abstract upper/lower index wrappers rather than dummy component strings:

~~~mathematica
A = RAYTensor["A",{RAYUp[a],RAYDown[b]}];
RAYIndexCheck[A]

RAYDeclareSymmetry["F","Antisymmetric"];
RAYCanonicalize[
  RAYTensor["F",{RAYDown[a],RAYDown[b]}]+
  RAYTensor["F",{RAYDown[b],RAYDown[a]}]
] (* 0 *)

RAYCanonicalize[
  RAYTensor["V",{RAYUp[i]}] RAYTensor["W",{RAYDown[i]}]-
  RAYTensor["V",{RAYUp[j]}] RAYTensor["W",{RAYDown[j]}]
] (* 0 *)

RAYContract[
 RAYTensor["Metric",{RAYUp[a],RAYUp[b]}]*
 RAYTensor["F",{RAYDown[b],RAYDown[c]}],
 "Dimension"->4
]

RAYBianchiReduce[
 RAYTensor["Riemann",RAYDown/@{a,b,c,d}]+
 RAYTensor["Riemann",RAYDown/@{a,c,d,b}]+
 RAYTensor["Riemann",RAYDown/@{a,d,b,c}]
] (* 0 *)

RAYCovDCommutator[
 RAYTensor["V",{RAYUp[c]}],a,b]
~~~

The Riemann convention matches RAY's explicit curvature convention. Dummy indices must have exactly one upper and one lower occurrence. Index-checking and abstract algebra are finite-rank symbolic facilities; performance scales with the symmetry and dummy-permutation orbit.

## 8. Register arbitrary tensors and evaluate covariant derivatives

~~~mathematica
RAYDefineMetric["2D",{t,x},
  DiagonalMatrix[{-1,Exp[2t]}]];

RAYRegisterTensor["UserV",{1,Exp[t]},"u"];

RAYToComponents[
  RAYTensor["UserV",{RAYDown[a]}],
  {RAYDown[a]}
] (* {-1, Exp[3t]} *)

RAYToComponents[
  RAYAbstractCovD[RAYTensor["UserV",{RAYUp[b]}],a],
  {RAYDown[a],RAYUp[b]}
] (* matches RAYCovD[{1,Exp[t]},"u"] *)

RAYUnregisterTensor["UserV"]
~~~

The first argument to RAYToComponents is an indexed expression, and the second is the ordered list of free upper/lower index slots; all repeated up/down indices are summed. Registered components are specific to the active metric.

## 9. Single-file installation

Download RAYStandalone.wl and execute:

~~~mathematica
Get["C:\\Users\\YourUser\\Downloads\\RAYStandalone.wl"]
RAYVersion
~~~

Only this file is necessary for direct loading. For automatic Needs loading, install the complete application folder under $UserBaseDirectory/Applications/RAY.

## 10. Verification

The v1.1.0 source was tested in Wolfram Language 15: original regressions 7/7, new regressions 11/11 and timed functional benchmarks 62/62, a total of 80/80 passing cases. Run Tests/RAY_Benchmarks.wl to reproduce the benchmark suite.


## 11. Readable curvature and notebook-style source output (v1.1.2)

Large warp-product curvature expressions should be inspected using the default
`RAYRicci["dd"]` component equations or `RAYRicciScalar[]`. For full matrices:

~~~mathematica
RAYRicci["dd","Matrix"]
RAYEinstein["dd","Matrix"]
MatrixForm[RAYRaw["Ricci","dd"]]
~~~

For mathematical notation of arbitrary expressions:

~~~mathematica
RAYReadable[RAYRaw["RicciScalar"]]
RAYPretty[D[P[y,z],y]]
~~~

For normal Mathematica code as it appears in a notebook input cell, use
`expr // RAW`. This now renders the Mathematica StandardForm equivalent
of the exact raw expression, with single-variable derivatives printed as
`A'[t]` and `A''[t]` rather than `Derivative[1][A][t]`. For abstract tensors
it reveals the actual RAYTensor/RAYUp code rather than the mathematical superscript display.
RAW is for source presentation; use RAYRaw to obtain arrays for computation.

Human display explicitly uses partial fractions for derivatives of multivariate
functions and dot symbols for time derivatives. The display wrapper preserves the
full symbolic expression through its InterpretationBox. The new test suite
Tests/RAY_Handwritten_Tests.wl checks this behavior.
