# RAY development API

**Branch:** feature/matter-equations-numerics-symbolic. This branch retains existing explicit-component commands and adds matter, equation, numerical and symbolic tools. It is not yet a tagged release.

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
