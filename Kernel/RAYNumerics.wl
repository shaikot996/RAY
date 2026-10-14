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
  q=If[quantities===Automatic,(#[time]&/@fields),
    If[ListQ[quantities],quantities,{quantities}]];
  If[q==={},Return[rayFail["RAYPlot: provide at least one quantity."]]];
  nq=Length[q];nc=Length[results];
  colors=OptionValue["Colors"];
  If[colors===Automatic,
    colors={RGBColor[0.13,0.36,0.74],RGBColor[0.81,0.27,0.21],
      RGBColor[0.14,0.57,0.36],RGBColor[0.58,0.31,0.66],
      RGBColor[0.89,0.56,0.12],RGBColor[0.17,0.61,0.67]}];
  lines=OptionValue["LineStyles"];
  If[lines===Automatic,lines={Solid,Dashed,Dotted,DotDashed}];
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
RAYSolveWizard[equations_List,fields_List,domain:{_Symbol,_,_}] :=
 DialogInput[
  DynamicModule[{ics={},makePlot=True,selection=Automatic},
   Column[{
     Style["RAY numerical solver",Bold,16],
     "Enter one IC list, or a list of IC lists to compare:",
     InputField[Dynamic[ics],Expression,FieldSize->{55,5}],
     Row[{Checkbox[Dynamic[makePlot]]," Plot after solving"}],
     Row[{"Quantities to plot (Automatic = dependent fields): ",
       InputField[Dynamic[selection],Expression,FieldSize->30]}],
     Row[{
       DefaultButton[DialogReturn[RAYSolve[equations,fields,domain,ics,
         "Plot"->makePlot,"PlotFields"->selection]]],
       CancelButton[]
     }]
   },Spacings->1.2]
  ]
 ];
