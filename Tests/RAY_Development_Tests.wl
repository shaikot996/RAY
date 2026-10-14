(* RAY extension regression tests. Run in licensed Wolfram Language:
   Get[".../Tests/RAY_Development_Tests.wl"] *)

Needs["RAY`"];

ClearAll[t,x,r,ph,psi,V,a,u,alpha,kk];

tests={
 VerificationTest[
   Module[{ric},
     RAYDefineMetric["RawTest",{t,x},DiagonalMatrix[{-1,1}]];
     ric=RAYRaw[RAYRicci["dd"]];
     ric===RAYRaw["Ricci","dd"]
   ],True,TestID->"Raw full-command dispatch"
 ],

 VerificationTest[
   Module[{T},
     RAYDefineMetric["ScalarTest",{t,x},DiagonalMatrix[{-1,1}]];
     RAYMatterAction[RAYScalarLagrangian[psi[t,x],V[psi[t,x]]]];
     T=RAYRaw["StressTensor","dd"];
     FullSimplify[{
       T[[1,1]]-(D[psi[t,x],t]^2+D[psi[t,x],x]^2)/2-
         V[psi[t,x]],
       T[[1,2]]-D[psi[t,x],t]D[psi[t,x],x],
       T[[2,1]]-D[psi[t,x],t]D[psi[t,x],x]
     }]
   ],{0,0,0},TestID->"Scalar stress tensor including mixed components"
 ],

 VerificationTest[
   Module[{F,T},
     RAYDefineMetric["MaxwellTest",{t,x},DiagonalMatrix[{-1,1}]];
     F={{0,kk},{-kk,0}};
     RAYMatterAction[RAYMaxwellLagrangian[F]];
     T=RAYRaw["StressTensor","dd"];
     FullSimplify[T]
   ],{{kk^2/2,0},{0,-kk^2/2}},
   TestID->"Maxwell stress tensor in 1+1 dimensions"
 ],

 VerificationTest[
   Module[{eq},
     RAYDefineMetric["EqTest",{t,x},DiagonalMatrix[{-1,1}]];
     eq=RAYEinsteinEquations[RAYRaw["Einstein","dd"]];
     eq
   ],{},TestID->"Vacuum Einstein equation omits identities"
 ],

 VerificationTest[
   Module[{g,der},
     RAYDefineMetric["CovDTest",{r,ph},DiagonalMatrix[{1,r^2}]];
     g=RAYRaw["Metric","dd"];
     der=RAYCovD[g,"dd"];
     FullSimplify[der]
   ],ConstantArray[0,{2,2,2}],
   TestID->"Metric compatibility under component covariant derivative"
 ],

 VerificationTest[
   Module[{g},
     RAYWarpedMetric["WarpTest",{
       {{t},{{-1}},1},{{x},{{1}},Exp[2 alpha[t]]}
     }];
     g=RAYRaw["Metric","dd"];
     g
   ],DiagonalMatrix[{-1,Exp[2 alpha[t]]}],
   TestID->"Warped diagonal block construction"
 ],

 VerificationTest[
   Module[{solution,vals},
     solution=RAYSolve[
       {u''[t]+u[t]==0},{u},{t,0,1},
       {{u[0]==0,u'[0]==1},{u[0]==1,u'[0]==0}}
     ];
     If[solution===$Failed,Return[False]];
     vals=Table[(u[1]/.solution["Solutions"][[i]]),{i,2}];
     Max[Abs[N[vals-{Sin[1],Cos[1]}]]]<10^-6
   ],True,TestID->"Numerical solver with multiple IC sets"
 ],

 VerificationTest[
   RAYAbstractCovD[2 RAYTensor["Metric",{a,b}],c],
   0,TestID->"Formal metric compatibility"
 ],
 VerificationTest[
   Module[{eq,sol,val},
     RAYDefineMetric["deSitterEndToEnd",{t,x,yy,zz},
       DiagonalMatrix[{-1,a[t]^2,a[t]^2,a[t]^2}]];
     eq=RAYEinsteinEquations[RAYRaw[RAYEinstein["dd"]],0,
       "CosmologicalConstant"->3,"Components"->{{1,1}}];
     sol=RAYSolve[eq,{a},{t,0,2},{a[0]==1,a'[0]==1}];
     If[sol===$Failed,Return[False]];
     val=N[a[2]/.sol["Solutions"][[1]]];
     Abs[val-Exp[2]]<10^-5
   ],True,TestID->"Einstein equations to de Sitter numerical solution"
 ],
 VerificationTest[
   Module[{sol,graphic},
     sol=RAYSolve[{u''[t]+u[t]==0},{u},{t,0,2},
       {{u[0]==0,u'[0]==1},{u[0]==1,u'[0]==0}}];
     If[sol===$Failed,Return[False]];
     graphic=RAYPlot[sol,{u[t],u'[t]},
       "Colors"->{Red,Blue},"FrameLabel"->{"t","u"}];
     MemberQ[{Legended,Graphics},Head[graphic]]
   ],True,TestID->"Multi-IC colored numerical plots"
 ],
 VerificationTest[
   Module[{r1,r2},
     RAYDefineMetric["BareRawTest",{t,x},DiagonalMatrix[{-1,1}]];
     r1=RAYRaw[RAYRicci,"dd"];
     r2=RAYRaw["Ricci","dd"];
     r1===r2
   ],True,TestID->"RAYRaw accepts a bare function symbol"
 ]

};

TestReport[tests]
