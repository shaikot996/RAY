(* RAY numerical evolution and reproducible multi-IC plotting. *)

Options[RAYSolve]={
 "Method"->Automatic,"WorkingPrecision"->MachinePrecision,
 "AccuracyGoal"->Automatic,"PrecisionGoal"->Automatic,
 "MaxSteps"->Infinity,"Plot"->False,"PlotFields"->Automatic,
 "PlotOptions"->{}
};

RAYSolve[equations_List,fields_List,domain:{_Symbol,_,_},
  icsets_List,OptionsPattern[]] :=
 Module[{sets,solutions={},raw,data,pops},
  sets=If[icsets==={} || AllTrue[icsets,MatchQ[#,_Equal]&],
    {icsets},icsets];
  If[!AllTrue[sets,ListQ[#]&&AllTrue[#,MatchQ[#,_Equal]&]&],
    Return[rayFail["RAYSolve: ICs must be a list of equalities or a list of IC lists."]]];
  If[fields==={},Return[rayFail["RAYSolve: no dependent functions given."]]];
  Do[
    raw=Quiet@Check[
      NDSolve[
        Evaluate[Join[equations,sets[[i]]]],Evaluate[fields],Evaluate[domain],
        Method->OptionValue["Method"],
        WorkingPrecision->OptionValue["WorkingPrecision"],
        AccuracyGoal->OptionValue["AccuracyGoal"],
        PrecisionGoal->OptionValue["PrecisionGoal"],
        MaxSteps->OptionValue["MaxSteps"]
      ],
      $Failed
    ];
    If[raw===$Failed || !ListQ[raw] || raw==={} ||
       !ListQ[First[raw]] ||
       !AllTrue[First[raw],MatchQ[#,_Rule|_RuleDelayed]&],
      Return[rayFail["RAYSolve: NDSolve failed for IC set "<>ToString[i]<>"."]]];
    AppendTo[solutions,First[raw]],
    {i,Length[sets]}
  ];
  data=<|
    "Equations"->equations,"Fields"->fields,"TimeDomain"->domain,
    "InitialConditions"->sets,"Solutions"->solutions|>;
  If[TrueQ[OptionValue["Plot"]],
    pops=OptionValue["PlotOptions"];
    If[!ListQ[pops],
      Return[rayFail["RAYSolve: \"PlotOptions\" must be a list of rules."]]];
    AssociateTo[data,
      "Plot"->RAYPlot[data,OptionValue["PlotFields"],Sequence@@pops]]
  ];
  data
];

Options[RAYPlot]={
 "Colors"->Automatic,"LineStyles"->Automatic,
 "ICLabels"->Automatic,"QuantityLabels"->Automatic,
 "Frame"->True,"Axes"->False,
 "FrameLabel"->Automatic,"AxesLabel"->None,
 "PlotRange"->All,"PlotLabel"->None,
 "ImageSize"->Large,"PlotLegends"->Automatic,
 "GridLines"->None,"AspectRatio"->Automatic
};

RAYPlot[solution_Association,quantities_:Automatic,OptionsPattern[]] :=
 Module[{fields=Lookup[solution,"Fields",{}],
   domain=Lookup[solution,"TimeDomain",Missing["None"]],
   results=Lookup[solution,"Solutions",{}],
   time,lo,hi,q,colors,lines,nc,nq,curves,styles,
   labels,icLabels,quantityLabels,legend,frameLabels},
  If[MissingQ[domain] || results==={},
    Return[rayFail["RAYPlot: the solution association has no numerical solutions."]]];
  {time,lo,hi}=domain;
  q=If[quantities===Automatic,(#[time]& /@ fields),
    If[ListQ[quantities],quantities,{quantities}]];
  If[q==={},Return[rayFail["RAYPlot: provide at least one quantity."]]];
  nq=Length[q];nc=Length[results];
  colors=OptionValue["Colors"];
  If[colors===Automatic,
    colors={RGBColor[0.13,0.36,0.74],RGBColor[0.81,0.27,0.21],
      RGBColor[0.14,0.57,0.36],RGBColor[0.58,0.31,0.66],
      RGBColor[0.89,0.56,0.12],RGBColor[0.17,0.61,0.67]}];
  lines=OptionValue["LineStyles"];
  If[lines===Automatic,lines={Solid,Dotted,Dashed,DotDashed}];
  If[!ListQ[colors] || colors==={} || !ListQ[lines] || lines==={},
    Return[rayFail["RAYPlot: Colors and LineStyles must be nonempty lists."]]];
  icLabels=OptionValue["ICLabels"];
  If[icLabels===Automatic,
    icLabels=("IC "<>ToString[#]& /@ Range[nc])];
  quantityLabels=OptionValue["QuantityLabels"];
  If[quantityLabels===Automatic,
    quantityLabels=ToString[#,InputForm]& /@ q];
  If[Length[icLabels]=!=nc || Length[quantityLabels]=!=nq,
    Return[rayFail["RAYPlot: legend label counts do not match quantities/ICs."]]];
  curves=Flatten[Table[q[[j]]/.results[[i]],{j,nq},{i,nc}],1];
  styles=Flatten[Table[
    Directive[colors[[Mod[j-1,Length[colors]]+1]],
      lines[[Mod[i-1,Length[lines]]+1]],AbsoluteThickness[1.8]],
    {j,nq},{i,nc}],1];
  labels=Flatten[Table[
    ToString[quantityLabels[[j]]]<>" / "<>ToString[icLabels[[i]]],
    {j,nq},{i,nc}],1];
  legend=If[OptionValue["PlotLegends"]===Automatic,labels,
    OptionValue["PlotLegends"]];
  frameLabels=If[OptionValue["FrameLabel"]===Automatic,
    {ToString[time,InputForm],"Value"},OptionValue["FrameLabel"]];
  With[{tt=time,lower=lo,upper=hi,plottedCurves=curves},
    Plot[Evaluate[plottedCurves],{tt,lower,upper},
      PlotStyle->styles,PlotLegends->legend,
      Frame->OptionValue["Frame"],Axes->OptionValue["Axes"],
      FrameLabel->frameLabels,AxesLabel->OptionValue["AxesLabel"],
      PlotRange->OptionValue["PlotRange"],
      PlotLabel->OptionValue["PlotLabel"],
      ImageSize->OptionValue["ImageSize"],
      GridLines->OptionValue["GridLines"],
      AspectRatio->OptionValue["AspectRatio"]
    ]
  ]
];

(* Front-end dialog with editable Expression input fields.
   Use RAYSolve directly in headless environments. *)
(* Guided three-step front-end dialog. Its NDSolve backend is RAYSolve. *)
RAYSolveWizard[equations_List,fields_List,domain:{_Symbol,_,_}] :=
 DialogInput[
  DynamicModule[
   {step=1,ics={},makePlot=True,selection=Automatic,
    colors=Automatic,lines=Automatic,
    frame=True,frameLabels=Automatic,plotTitle=None,
    preview=False},
   Column[{
     Style["RAY numerical solver",Bold,17],
     Dynamic@Style["Step "<>ToString[step]<>" of 3",Bold,13],
     PaneSelector[{
       1->Column[{
         Style["Initial conditions",Bold],
         "One list for a single solution; nested lists for several IC sets.",
         InputField[Dynamic[ics],Expression,FieldSize->{58,5}],
         Style["Example: {{u[0]==0,u'[0]==1},{u[0]==1,u'[0]==0}}",
           Italic,Gray]
       }],
       2->Column[{
         Style["Quantities and output",Bold],
         Row[{Checkbox[Dynamic[makePlot]]," Produce solution plots"}],
         "Choose expressions to plot or Automatic for all dependent fields:",
         InputField[Dynamic[selection],Expression,FieldSize->48],
         "You can pass u[t], u'[t] or several quantities as a list."
       }],
       3->Column[{
         Style["Plot appearance",Bold],
         "Colors (Automatic or list):",
         InputField[Dynamic[colors],Expression,FieldSize->40],
         "Line patterns for IC sets (Automatic or list):",
         InputField[Dynamic[lines],Expression,FieldSize->40],
         Row[{Checkbox[Dynamic[frame]]," Show frame"}],
         "Frame labels (Automatic or {horizontal,vertical}):",
         InputField[Dynamic[frameLabels],Expression,FieldSize->40],
         "Plot title:",
         InputField[Dynamic[plotTitle],Expression,FieldSize->40]
       }]
     },Dynamic[step]],
     Row[{
       Button["Previous",step=Max[1,step-1],Enabled->Dynamic[step>1]],
       Button["Next",step=Min[3,step+1],Enabled->Dynamic[step<3]],
       Spacer[10],
       Button["Solve",DialogReturn[
         RAYSolve[equations,fields,domain,ics,
           "Plot"->makePlot,
           "PlotFields"->selection,
           "PlotOptions"->{
             "Colors"->colors,"LineStyles"->lines,
             "Frame"->frame,"FrameLabel"->frameLabels,
             "PlotLabel"->plotTitle
           }]
         ],Enabled->Dynamic[step===3]],
       Button["Cancel",DialogReturn[$Canceled]]
     },Spacer[8]]
   },Spacings->1.3]
  ]
 ];
