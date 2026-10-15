(* RAY standalone v1.1.0 — one-file distribution.
  Equivalent to Kernel/RAY.wl and its five extension modules.
  Install/use: Get["C:\\path\\to\\RAYStandalone.wl"]
  Generated from source; edit source modules rather than this bundle. *)

(* ::Package:: *)

BeginPackage["RAY`"];

RAYVersion::usage =
"RAYVersion gives the current version string of the RAY package.";

RAYHelp::usage =
"RAYHelp[] displays a human-readable table of the main RAY commands. RAYHelp[\"command\"] displays focused help for one command.";

RAYAbout::usage =
"RAYAbout[] displays package conventions, curvature sign conventions, and the active metric/congruence.";

RAYDefineMetric::usage =
"RAYDefineMetric[name, coords, g] defines and activates an explicit metric g_(mu nu). The dimension is inferred from g. Use Assumptions -> ... to provide simplification assumptions.";

RAYUseMetric::usage =
"RAYUseMetric[name] activates a previously defined metric.";

RAYMetrics::usage =
"RAYMetrics[] lists all defined metrics.";

RAYCoordinates::usage =
"RAYCoordinates[] returns the coordinates of the active metric.";

RAYDimension::usage =
"RAYDimension[] returns the dimension of the active metric.";

RAYMetric::usage =
"RAYMetric[] displays g_(mu nu). RAYMetric[\"uu\"] displays g^(mu nu). RAYMetric[config, mu, nu] gives a component. Physical indices begin at 0.";

RAYInverseMetric::usage =
"RAYInverseMetric[] displays g^(mu nu). RAYInverseMetric[mu,nu] gives a component.";

RAYMetricDeterminant::usage =
"RAYMetricDeterminant[] gives Det[g_(mu nu)].";

RAYVolumeElement::usage =
"RAYVolumeElement[] gives Sqrt[Abs[Det[g_(mu nu)]]].";

RAYSignature::usage =
"RAYSignature[] attempts to display the signs of the metric eigenvalues under the active assumptions. For diagonal metrics this is direct.";

RAYDefineCongruence::usage =
"RAYDefineCongruence[name, u] defines and activates a contravariant congruence u^mu for the active metric. By default it is normalized automatically. Options: \"Normalize\" -> True|False and \"NormalizationSign\" -> Automatic|-1|1.";

RAYUseCongruence::usage =
"RAYUseCongruence[name] activates a previously defined congruence belonging to the active metric.";

RAYCongruences::usage =
"RAYCongruences[] lists congruences defined for the active metric.";

RAYCongruence::usage =
"RAYCongruence[\"u\"] displays u^mu; RAYCongruence[\"d\"] displays u_mu. RAYCongruence[pos, mu] gives a component.";

RAYCongruenceNorm::usage =
"RAYCongruenceNorm[] gives epsilon = u^mu u_mu, equal to -1 or +1 for a normalized non-null congruence.";

RAYChristoffel::usage =
"RAYChristoffel[] displays all nonzero Christoffel symbols. RAYChristoffel[rho,mu,nu] gives Gamma^rho_(mu nu).";

RAYRiemann::usage =
"RAYRiemann[] displays nonzero R^rho_(sigma mu nu). RAYRiemann[config] uses an index configuration such as \"uddd\" or \"dddd\". RAYRiemann[config,rho,sigma,mu,nu] gives one component.";

RAYRicci::usage =
"RAYRicci[] displays R_(mu nu). RAYRicci[config] supports \"dd\", \"ud\", \"du\", or \"uu\". RAYRicci[config,mu,nu] gives one component.";

RAYRicciScalar::usage =
"RAYRicciScalar[] gives the Ricci scalar R.";

RAYEinstein::usage =
"RAYEinstein[] displays G_(mu nu). RAYEinstein[config] changes index placement. RAYEinstein[config,mu,nu] gives one component.";

RAYWeyl::usage =
"RAYWeyl[] displays nonzero C_(rho sigma mu nu). RAYWeyl[config] changes index placement. In dimensions <= 3 the Weyl tensor is identically zero.";

RAYKretschmann::usage =
"RAYKretschmann[] gives R_(abcd) R^(abcd).";

RAYRicciSquared::usage =
"RAYRicciSquared[] gives R_(ab) R^(ab).";

RAYWeylSquared::usage =
"RAYWeylSquared[] gives C_(abcd) C^(abcd).";

RAYCovariantDerivativeU::usage =
"RAYCovariantDerivativeU[] displays nabla_mu u_nu. RAYCovariantDerivativeU[\"du\"] displays nabla_mu u^nu. Component form is RAYCovariantDerivativeU[config,mu,nu].";

RAYExpansion::usage =
"RAYExpansion[] gives theta = nabla_mu u^mu.";

RAYAcceleration::usage =
"RAYAcceleration[] displays a^mu. RAYAcceleration[\"d\"] displays a_mu. RAYAcceleration[pos,mu] gives one component.";

RAYShear::usage =
"RAYShear[] displays sigma_(mu nu). RAYShear[config] changes index placement. RAYShear[config,mu,nu] gives one component. The implementation uses the expanded fundamental definition and does not introduce a spatial projector tensor.";

RAYVorticity::usage =
"RAYVorticity[] displays omega_(mu nu). RAYVorticity[config] changes index placement. RAYVorticity[config,mu,nu] gives one component. The implementation does not introduce a spatial projector tensor.";

RAYShearScalar::usage =
"RAYShearScalar[] gives (1/2) sigma_(mu nu) sigma^(mu nu).";

RAYVorticityScalar::usage =
"RAYVorticityScalar[] gives (1/2) omega_(mu nu) omega^(mu nu).";

RAYRicciAlongU::usage =
"RAYRicciAlongU[] gives R_(mu nu) u^mu u^nu.";

RAYAccelerationDivergence::usage =
"RAYAccelerationDivergence[] gives nabla_mu a^mu.";

RAYRaychaudhuriTerms::usage =
"RAYRaychaudhuriTerms[] displays every term in the non-null Raychaudhuri equation in a table.";

RAYRaychaudhuriResidual::usage =
"RAYRaychaudhuriResidual[] gives LHS - RHS of the Raychaudhuri equation. It should simplify to zero.";

RAYKinematicChecks::usage =
"RAYKinematicChecks[] checks normalization, acceleration orthogonality, shear trace/orthogonality, vorticity antisymmetry/orthogonality, the kinematic decomposition, and the Raychaudhuri identity.";

RAYNonzeroChristoffel::usage =
"RAYNonzeroChristoffel[] displays only nonzero Christoffel symbols.";

RAYNonzeroRiemann::usage =
"RAYNonzeroRiemann[config:\"uddd\"] displays only nonzero Riemann components.";

RAYNonzeroRicci::usage =
"RAYNonzeroRicci[config:\"dd\"] displays only nonzero Ricci components.";

RAYNonzeroEinstein::usage =
"RAYNonzeroEinstein[config:\"dd\"] displays only nonzero Einstein-tensor components.";

RAYNonzeroWeyl::usage =
"RAYNonzeroWeyl[config:\"dddd\"] displays only nonzero Weyl components.";

RAYNonzeroShear::usage =
"RAYNonzeroShear[config:\"dd\"] displays only nonzero shear components.";

RAYNonzeroVorticity::usage =
"RAYNonzeroVorticity[config:\"dd\"] displays only nonzero vorticity components.";

RAYGeometry::usage =
"RAYGeometry[] gives a compact geometry report for the active metric.";

RAYRaychaudhuri::usage =
"RAYRaychaudhuri[] gives a compact Raychaudhuri/kinematics report for the active congruence.";

RAYReport::usage =
"RAYReport[] produces a full human-readable report containing geometry and Raychaudhuri quantities.";

RAYRaw::usage =
"RAYRaw[quantity, config] returns raw tensor arrays without TraditionalForm wrappers. RAYRaw[quantity] returns raw scalar/vector kinematic quantities where applicable. Examples: RAYRaw[\"Ricci\",\"dd\"], RAYRaw[\"Riemann\",\"uddd\"], RAYRaw[\"Shear\",\"ud\"], RAYRaw[\"Kretschmann\"], RAYRaw[\"Expansion\"].";

RAYClearCache::usage =
"RAYClearCache[] clears all derived tensor caches while keeping defined metrics and congruences.";

RAYMetricVariables::usage = "RAYMetricVariables[] returns independent symmetric formal inverse-metric components for metric variation.";

RAYScalarLagrangian::usage = "RAYScalarLagrangian[field,potential] constructs a scalar matter Lagrangian with the active coordinates.";

RAYMaxwellLagrangian::usage = "RAYMaxwellLagrangian[F] constructs -F_ab F^ab/4 from explicit antisymmetric components.";

RAYMatterAction::usage = "RAYMatterAction[L] computes the Hilbert stress tensor from an explicit matter Lagrangian.";

RAYStressTensor::usage = "RAYStressTensor[config] displays the stored matter stress tensor. RAYRaw of StressTensor gives raw components.";

RAYEinsteinEquations::usage = "RAYEinsteinEquations[G,T] generates component equations G+Lambda g=kappa T. T defaults to zero.";

RAYCovD::usage = "RAYCovD[tensor,config] computes explicit component covariant derivatives; derivative index first.";

RAYWarpedMetric::usage = "RAYWarpedMetric[name,blocks] defines a warped/block-diagonal metric from {coords,metric,multiplier} blocks.";

RAYSymbolicMetric::usage = "RAYSymbolicMetric[name,dimension or coords] constructs a formal metric descriptor without costly inversion.";

RAYInstantiateMetric::usage = "RAYInstantiateMetric[descriptor,optionalMatrix] activates explicit components from a symbolic metric.";

RAYTensor::usage = "RAYTensor[name,indices] denotes a formal abstract tensor, without automatic index contraction.";

RAYNabla::usage = "RAYNabla[index,expr] denotes an unevaluated abstract covariant derivative.";

RAYAbstractCovD::usage = "RAYAbstractCovD[expr,index] applies formal linearity, Leibniz rule, and metric compatibility.";

RAYConventions::usage = "RAYConventions[] reports dimensions, curvature signs, Einstein and stress tensor conventions.";

RAYSolve::usage = "RAYSolve[equations,fields,timeDomain,initialConditionSets] solves ODEs for one or more IC sets.";

RAYPlot::usage = "RAYPlot[solution,quantities] plots multiple numerical solutions; quantities keep color and ICs vary dashing.";

RAYSolveWizard::usage = "RAYSolveWizard[equations,fields,timeDomain] opens interactive front-end input for ICs and plotting.";

RAYUp::usage = "RAYUp[i] marks an upper abstract index.";

RAYDown::usage = "RAYDown[i] marks a lower abstract index.";

RAYDummy::usage = "RAYDummy[n] is an internal normalized dummy-index label.";

RAYDeclareSymmetry::usage = "RAYDeclareSymmetry[name,kind] sets tensor slot symmetry (symmetric or antisymmetric).";

RAYCanonicalize::usage = "RAYCanonicalize[expr] canonicalizes declared tensor symmetries and dummy labels.";

RAYContract::usage = "RAYContract[expr] contracts metric, Kronecker delta and Ricci expressions.";

RAYIndexCheck::usage = "RAYIndexCheck[expr] checks free/repeated abstract indices.";

RAYBianchiReduce::usage = "RAYBianchiReduce[expr] applies first Bianchi identity for covariant Riemann.";

RAYCovDCommutator::usage = "RAYCovDCommutator[tensor,a,b] forms [nabla_a,nabla_b] from Riemann.";

RAYToComponents::usage = "RAYToComponents[expr,free] evaluates indexed tensors against the active explicit metric.";

RAYRegisterTensor::usage = "RAYRegisterTensor[name,array,config] registers explicit components of a user-defined tensor for the active metric.";

RAYUnregisterTensor::usage = "RAYUnregisterTensor[name] removes a user-defined component tensor from the active metric.";

Begin["`Private`"];

$RAYVersion = "1.1.0";
RAYVersion := $RAYVersion;

$rayMetrics = <||>;
$rayCongruences = <||>;
$rayActiveMetric = None;
$rayActiveCongruence = None;
$rayCache = <||>;

rayFail[msg_String] := (Print[Style[msg, Red, Bold]]; $Failed);

rayMetricQ[] := StringQ[$rayActiveMetric] && KeyExistsQ[$rayMetrics, $rayActiveMetric];

rayMetricObj[] := If[
  rayMetricQ[],
  $rayMetrics[$rayActiveMetric],
  Missing["NoActiveMetric"]
];

rayCongruenceKey[metric_String, name_String] := metric <> "::" <> name;

rayCongruenceQ[] := StringQ[$rayActiveCongruence] &&
  rayMetricQ[] &&
  KeyExistsQ[$rayCongruences, rayCongruenceKey[$rayActiveMetric, $rayActiveCongruence]];

rayCongruenceObj[] := If[
  rayCongruenceQ[],
  $rayCongruences[rayCongruenceKey[$rayActiveMetric, $rayActiveCongruence]],
  Missing["NoActiveCongruence"]
];

rayRequireMetric[] := If[rayMetricQ[], True, rayFail["RAY: define or activate a metric first."]];

rayRequireCongruence[] := If[
  rayCongruenceQ[],
  True,
  rayFail["RAY: define or activate a congruence first with RAYDefineCongruence[...]."]
];

rayAssumptions[] := If[rayMetricQ[], Lookup[rayMetricObj[], "Assumptions", True], True];

raySimplificationMode[] := If[rayMetricQ[], Lookup[rayMetricObj[], "Simplification", "Full"], "Full"];

raySimp[expr_] := Module[{ass = rayAssumptions[], mode = raySimplificationMode[]},
  Quiet[
    Check[
      Switch[
        mode,
        "None", expr,
        "Simplify", Simplify[expr, Assumptions -> ass],
        "Full", FullSimplify[expr, Assumptions -> ass],
        _, FullSimplify[expr, Assumptions -> ass]
      ],
      expr
    ]
  ]
];

rayDim[] := Lookup[rayMetricObj[], "Dimension", Missing["NoDimension"]];
rayCoords[] := Lookup[rayMetricObj[], "Coordinates", Missing["NoCoordinates"]];
rayGDD[] := Lookup[rayMetricObj[], "MetricDown", Missing["NoMetric"]];
rayGUU[] := Lookup[rayMetricObj[], "MetricUp", Missing["NoInverseMetric"]];

rayCacheKey[tag_String] := StringRiffle[
  {
    ToString[$rayActiveMetric],
    ToString[$rayActiveCongruence],
    tag
  },
  "::"
];

SetAttributes[rayCached, HoldRest];
rayCached[tag_String, expr_] := Module[{key = rayCacheKey[tag], val},
  If[KeyExistsQ[$rayCache, key],
    $rayCache[key],
    val = expr;
    AssociateTo[$rayCache, key -> val];
    val
  ]
];

RAYClearCache[] := ($rayCache = <||>; Print[Style["RAY cache cleared.", Darker[Green], Bold]];);

rayValidIndexQ[i_] := IntegerQ[i] && rayMetricQ[] && 0 <= i < rayDim[];

rayParseConfig[config_String, rank_Integer] := Module[{chars, parsed},
  chars = Characters[ToLowerCase[config]];
  If[Length[chars] =!= rank, Return[$Failed]];
  parsed = chars /. {"u" -> 1, "d" -> -1};
  If[!VectorQ[parsed, MemberQ[{-1, 1}, #] &], Return[$Failed]];
  parsed
];

rayTransformIndex[tensor_, pos_Integer, metric_] := Module[
  {rank = ArrayDepth[tensor], tmp, perm},
  tmp = TensorContract[
    TensorProduct[metric, tensor],
    {{2, 2 + pos}}
  ];

  (* After contraction the free metric index is the first axis.
     TensorTranspose uses the permutation as an old-axis -> new-position map,
     so the inverse of the visually desired ordering is required here. *)
  perm = Join[{pos}, Range[1, pos - 1], Range[pos + 1, rank]];

  TensorTranspose[tmp, perm]
];

rayChangeIndices[tensor_, current_List, target_List] := Module[
  {res = tensor, cfg = current, p, metric},
  If[Length[current] =!= Length[target], Return[$Failed]];
  Do[
    If[cfg[[p]] =!= target[[p]],
      metric = If[target[[p]] == 1, rayGUU[], rayGDD[]];
      res = rayTransformIndex[res, p, metric];
      cfg[[p]] = target[[p]];
    ],
    {p, Length[cfg]}
  ];
  raySimp[res]
];

rayComponent[array_, inds_List] := Extract[array, inds + 1];

rayTraditional[x_] := TraditionalForm[x];

rayDisplayMatrix[array_] := TraditionalForm[MatrixForm[array]];
rayDisplayVector[array_] := TraditionalForm[array];

rayIndexLabel[symbol_, inds_List, cfg_List] := Module[{up, down},
  up = MapThread[If[#2 == 1, #1, " "] &, {inds, cfg}];
  down = MapThread[If[#2 == -1, #1, " "] &, {inds, cfg}];
  TraditionalForm[
    Subsuperscript[
      symbol,
      Row[down, "\[ThinSpace]"],
      Row[up, "\[ThinSpace]"]
    ]
  ]
];

rayNonzeroGrid[array_, cfg_List, symbol_, title_String] := Module[
  {d = rayDim[], rank = Length[cfg], tuples, rows},
  tuples = Tuples[Range[0, d - 1], rank];
  rows = Reap[
      Do[
        With[{val = raySimp[rayComponent[array, inds]]},
          If[!TrueQ[raySimp[val == 0]],
            Sow[{rayIndexLabel[symbol, inds, cfg], TraditionalForm[val]}]
          ]
        ],
        {inds, tuples}
      ]
    ][[2]];
  rows = If[rows === {}, {}, First[rows]];
  Column[
    {
      Style[title, Bold, 15],
      If[
        rows === {},
        Style["All components vanish.", Italic, 13],
        Grid[
          Prepend[rows, {Style["Component", Bold], Style["Value", Bold]}],
          Frame -> All,
          Alignment -> {{Center, Left}},
          Spacings -> {2, 1},
          ItemStyle -> 12
        ]
      ]
    },
    Spacings -> 0.8
  ]
];

Options[RAYDefineMetric] = {Assumptions -> True, "Simplification" -> "Full"};

RAYDefineMetric[name_String, coords_List, metric_List, OptionsPattern[]] := Module[
  {d, inv, symres, ass, simpMode},
  d = Length[coords];
  If[d < 2, Return[rayFail["RAY: metric dimension must be at least 2."]]];
  If[Dimensions[metric] =!= {d, d},
    Return[rayFail["RAY: metric must be a square matrix whose size matches the coordinate list."]]
  ];
  ass = OptionValue[Assumptions];
  simpMode = OptionValue["Simplification"];

  symres = Quiet@FullSimplify[metric - Transpose[metric], Assumptions -> ass];
  If[symres =!= ConstantArray[0, {d, d}],
    Print[Style["RAY warning: metric symmetry was not proved under the supplied assumptions.", Darker[Orange], Bold]]
  ];

  inv = Quiet@Check[
    FullSimplify[Inverse[metric], Assumptions -> ass],
    Return[rayFail["RAY: metric inversion failed. Check that the metric is non-singular."]]
  ];

  AssociateTo[
    $rayMetrics,
    name -> <|
      "Name" -> name,
      "Coordinates" -> coords,
      "Dimension" -> d,
      "MetricDown" -> metric,
      "MetricUp" -> inv,
      "Assumptions" -> ass,
      "Simplification" -> simpMode
    |>
  ];

  $rayActiveMetric = name;
  $rayActiveCongruence = None;
  $rayCache = <||>;

  Print[
    Style["RAY metric defined: ", Bold, 14],
    Style[name, Darker[Blue], Bold],
    "   dimension = ", d
  ];

  Grid[
    {
      {Style["Coordinates", Bold], TraditionalForm[coords]},
      {Style["g_(mu nu)", Bold], TraditionalForm[MatrixForm[metric]]},
      {Style["g^(mu nu)", Bold], TraditionalForm[MatrixForm[inv]]}
    },
    Frame -> All,
    Alignment -> Left
  ]
];

RAYUseMetric[name_String] := If[
  KeyExistsQ[$rayMetrics, name],
  $rayActiveMetric = name;
  $rayActiveCongruence = None;
  Print[Style["Active RAY metric: " <> name, Darker[Green], Bold]];
  name,
  rayFail["RAY: no metric named \"" <> name <> "\" has been defined."]
];

RAYMetrics[] := Module[{names = Keys[$rayMetrics]},
  Grid[
    Prepend[
      ({#, Lookup[$rayMetrics[#], "Dimension", "?"]} & /@ names),
      {Style["Metric", Bold], Style["Dimension", Bold]}
    ],
    Frame -> All,
    Alignment -> Left
  ]
];

RAYCoordinates[] /; rayRequireMetric[] === True := TraditionalForm[rayCoords[]];
RAYDimension[] /; rayRequireMetric[] === True := rayDim[];

RAYMetric[] := RAYMetric["dd"];
RAYMetric["dd"] /; rayRequireMetric[] === True := rayDisplayMatrix[rayGDD[]];
RAYMetric["uu"] /; rayRequireMetric[] === True := rayDisplayMatrix[rayGUU[]];
RAYMetric["du"] /; rayRequireMetric[] === True := rayDisplayMatrix[IdentityMatrix[rayDim[]]];
RAYMetric["ud"] /; rayRequireMetric[] === True := rayDisplayMatrix[IdentityMatrix[rayDim[]]];

RAYMetric[config_String, mu_Integer, nu_Integer] /; rayRequireMetric[] === True := Module[
  {cfg = rayParseConfig[config, 2], data, lc = ToLowerCase[config]},
  If[cfg === $Failed, Return[rayFail["RAYMetric: config must be one of dd, du, ud, uu."]]];
  data = Switch[lc, "dd", rayGDD[], "uu", rayGUU[], _, IdentityMatrix[rayDim[]]];
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYMetric: component index out of range."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

RAYMetric[mu_Integer, nu_Integer] := RAYMetric["dd", mu, nu];

RAYInverseMetric[] := RAYMetric["uu"];
RAYInverseMetric[mu_Integer, nu_Integer] := RAYMetric["uu", mu, nu];

RAYMetricDeterminant[] /; rayRequireMetric[] === True := TraditionalForm[
  rayCached["MetricDeterminant", raySimp[Det[rayGDD[]]]]
];

RAYVolumeElement[] /; rayRequireMetric[] === True := TraditionalForm[
  raySimp[Sqrt[Abs[rayCached["MetricDeterminant", raySimp[Det[rayGDD[]]]]]]]
];

RAYSignature[] /; rayRequireMetric[] === True := Module[{g = rayGDD[], vals, signs},
  vals = If[
    TrueQ[g == DiagonalMatrix[Diagonal[g]]],
    Diagonal[g],
    Quiet@Check[Eigenvalues[g], Return[rayFail["RAYSignature: symbolic eigenvalue computation failed."]]]
  ];
  signs = raySimp[Sign /@ vals];
  Grid[
    {
      {Style["Metric eigenvalue signs", Bold], TraditionalForm[signs]},
      {Style["Convention note", Bold], "The metric itself carries the signature; RAY does not hard-code mostly-plus or mostly-minus."}
    },
    Frame -> All,
    Alignment -> Left
  ]
];

Options[RAYDefineCongruence] = {"Normalize" -> True, "NormalizationSign" -> Automatic};

RAYDefineCongruence[name_String, u_List, OptionsPattern[]] /; rayRequireMetric[] === True := Module[
  {d = rayDim[], g = rayGDD[], rawNorm, eps, normalizeQ, desired, uFinal, normFinal, key},
  If[Length[u] =!= d, Return[rayFail["RAY: congruence vector length must equal the metric dimension."]]];

  rawNorm = raySimp[u . g . u];
  normalizeQ = TrueQ[OptionValue["Normalize"]];
  desired = OptionValue["NormalizationSign"];

  eps = Which[
    TrueQ[raySimp[rawNorm == -1]], -1,
    TrueQ[raySimp[rawNorm == 1]], 1,
    MemberQ[{-1, 1}, desired], desired,
    True,
      With[{sgn = raySimp[Sign[rawNorm]]},
        If[MemberQ[{-1, 1}, sgn], sgn, Automatic]
      ]
  ];

  If[eps === Automatic,
    Return[rayFail[
      "RAY: could not infer whether the congruence is timelike or spacelike. Supply \"NormalizationSign\" -> -1 or 1 and suitable Assumptions."
    ]]
  ];

  uFinal = If[
    normalizeQ,
    raySimp[u/Sqrt[eps rawNorm]],
    u
  ];

  normFinal = raySimp[uFinal . g . uFinal];

  If[!TrueQ[raySimp[normFinal == eps]],
    Return[rayFail[
      "RAY: the congruence is not normalized to epsilon = " <> ToString[eps] <> ". Use \"Normalize\" -> True or provide stronger assumptions."
    ]]
  ];

  key = rayCongruenceKey[$rayActiveMetric, name];
  AssociateTo[
    $rayCongruences,
    key -> <|
      "Name" -> name,
      "Metric" -> $rayActiveMetric,
      "Up" -> uFinal,
      "Down" -> raySimp[g . uFinal],
      "Epsilon" -> eps
    |>
  ];

  $rayActiveCongruence = name;
  $rayCache = <||>;

  Print[
    Style["RAY congruence defined: ", Bold, 14],
    Style[name, Darker[Blue], Bold],
    "   epsilon = ", eps
  ];

  Grid[
    {
      {Style["u^mu", Bold], TraditionalForm[uFinal]},
      {Style["u_mu", Bold], TraditionalForm[raySimp[g . uFinal]]},
      {Style["u^mu u_mu", Bold], TraditionalForm[normFinal]}
    },
    Frame -> All,
    Alignment -> Left
  ]
];

RAYUseCongruence[name_String] /; rayRequireMetric[] === True := Module[
  {key = rayCongruenceKey[$rayActiveMetric, name]},
  If[
    KeyExistsQ[$rayCongruences, key],
    $rayActiveCongruence = name;
    Print[Style["Active RAY congruence: " <> name, Darker[Green], Bold]];
    name,
    rayFail["RAY: no congruence named \"" <> name <> "\" belongs to the active metric."]
  ]
];

RAYCongruences[] /; rayRequireMetric[] === True := Module[{prefix, names},
  prefix = $rayActiveMetric <> "::";
  names = StringDrop[#, StringLength[prefix]] & /@
    Select[Keys[$rayCongruences], StringStartsQ[#, prefix] &];
  Grid[
    Prepend[( {#, Lookup[$rayCongruences[rayCongruenceKey[$rayActiveMetric, #]], "Epsilon", "?"]} & /@ names),
      {Style["Congruence", Bold], Style["epsilon", Bold]}],
    Frame -> All,
    Alignment -> Left
  ]
];

RAYCongruence[] := RAYCongruence["u"];
RAYCongruence[pos_String] /; rayRequireCongruence[] === True := Module[{obj = rayCongruenceObj[]},
  Switch[
    ToLowerCase[pos],
    "u", rayDisplayVector[obj["Up"]],
    "d", rayDisplayVector[obj["Down"]],
    _, rayFail["RAYCongruence: use \"u\" or \"d\"."]
  ]
];

RAYCongruence[pos_String, mu_Integer] /; rayRequireCongruence[] === True := Module[{obj = rayCongruenceObj[], data},
  If[!rayValidIndexQ[mu], Return[rayFail["RAYCongruence: component index out of range."]]];
  data = Switch[ToLowerCase[pos], "u", obj["Up"], "d", obj["Down"], _, Return[rayFail["RAYCongruence: use \"u\" or \"d\"."]]];
  TraditionalForm[raySimp[data[[mu + 1]]]]
];

RAYCongruenceNorm[] /; rayRequireCongruence[] === True := TraditionalForm[rayCongruenceObj[]["Epsilon"]];

rayGamma[] /; rayRequireMetric[] === True := rayCached[
  "Gamma",
  Module[{d = rayDim[], g = rayGDD[], gi = rayGUU[], x = rayCoords[]},
    Table[
      raySimp[
        1/2 Sum[
          gi[[rho, lam]] (
            D[g[[lam, nu]], x[[mu]]] +
            D[g[[lam, mu]], x[[nu]]] -
            D[g[[mu, nu]], x[[lam]]]
          ),
          {lam, d}
        ]
      ],
      {rho, d}, {mu, d}, {nu, d}
    ]
  ]
];

RAYChristoffel[] := RAYNonzeroChristoffel[];
RAYChristoffel[rho_Integer, mu_Integer, nu_Integer] /; rayRequireMetric[] === True := Module[{d = rayDim[]},
  If[!And @@ (rayValidIndexQ /@ {rho, mu, nu}), Return[rayFail["RAYChristoffel: component index out of range."]]];
  TraditionalForm[raySimp[rayGamma[][[rho + 1, mu + 1, nu + 1]]]]
];

rayRiemannUDDD[] /; rayRequireMetric[] === True := rayCached[
  "RiemannUDDD",
  Module[{d = rayDim[], x = rayCoords[], ga = rayGamma[]},
    Table[
      raySimp[
        D[ga[[rho, nu, sig]], x[[mu]]] -
        D[ga[[rho, mu, sig]], x[[nu]]] +
        Sum[
          ga[[rho, mu, lam]] ga[[lam, nu, sig]] -
          ga[[rho, nu, lam]] ga[[lam, mu, sig]],
          {lam, d}
        ]
      ],
      {rho, d}, {sig, d}, {mu, d}, {nu, d}
    ]
  ]
];

rayRicciDD[] /; rayRequireMetric[] === True := rayCached[
  "RicciDD",
  Module[{d = rayDim[], r = rayRiemannUDDD[]},
    Table[
      raySimp[Sum[r[[rho, mu, rho, nu]], {rho, d}]],
      {mu, d}, {nu, d}
    ]
  ]
];

rayRicciScalar[] /; rayRequireMetric[] === True := rayCached[
  "RicciScalar",
  Module[{d = rayDim[], gi = rayGUU[], ric = rayRicciDD[]},
    raySimp[Sum[gi[[mu, nu]] ric[[mu, nu]], {mu, d}, {nu, d}]]
  ]
];

rayEinsteinDD[] /; rayRequireMetric[] === True := rayCached[
  "EinsteinDD",
  raySimp[rayRicciDD[] - (1/2) rayRicciScalar[] rayGDD[]]
];

rayWeylDDDD[] /; rayRequireMetric[] === True := rayCached[
  "WeylDDDD",
  Module[{d = rayDim[], g = rayGDD[], ric = rayRicciDD[], rs = rayRicciScalar[], rdown},
    If[d <= 3, Return[ConstantArray[0, ConstantArray[d, 4]]]];
    rdown = rayChangeIndices[rayRiemannUDDD[], {1, -1, -1, -1}, {-1, -1, -1, -1}];
    Table[
      raySimp[
        rdown[[a, b, c, e]]
        - 1/(d - 2) (
            g[[a, c]] ric[[e, b]]
            - g[[a, e]] ric[[c, b]]
            - g[[b, c]] ric[[e, a]]
            + g[[b, e]] ric[[c, a]]
          )
        + rs/((d - 1) (d - 2)) (
            g[[a, c]] g[[e, b]]
            - g[[a, e]] g[[c, b]]
          )
      ],
      {a, d}, {b, d}, {c, d}, {e, d}
    ]
  ]
];

rayTensorByName[name_String, config_String] := Module[{base, baseCfg, target, rank},
  {base, baseCfg} = Switch[
    ToLowerCase[name],
    "metric", {rayGDD[], {-1, -1}},
    "riemann", {rayRiemannUDDD[], {1, -1, -1, -1}},
    "ricci", {rayRicciDD[], {-1, -1}},
    "einstein", {rayEinsteinDD[], {-1, -1}},
    "stresstensor", {rayMatterStressDD[], {-1, -1}},
    "weyl", {rayWeylDDDD[], {-1, -1, -1, -1}},
    "shear", {rayShearDD[], {-1, -1}},
    "vorticity", {rayVorticityDD[], {-1, -1}},
    _, Return[$Failed]
  ];
  rank = Length[baseCfg];
  target = rayParseConfig[config, rank];
  If[target === $Failed, Return[$Failed]];
  rayChangeIndices[base, baseCfg, target]
];

RAYRaw[quantity_String, config_String] /; rayRequireMetric[] === True := Module[{q = ToLowerCase[quantity], data},
  If[MemberQ[{"shear", "vorticity"}, q] && !rayCongruenceQ[],
    Return[rayFail["RAYRaw: define or activate a congruence before requesting " <> quantity <> "."]]
  ];
  data = rayTensorByName[quantity, config];
  If[data === $Failed,
    rayFail["RAYRaw: unknown tensor quantity or invalid index configuration."],
    data
  ]
];

RAYRaw[quantity_String] /; rayRequireMetric[] === True := Module[{q = ToLowerCase[quantity]},
  Switch[
    q,
    "ricciscalar", rayRicciScalar[],
    "kretschmann", rayKretschmann[],
    "riccisquared", rayRicciSquared[],
    "weylsquared", rayWeylSquared[],
    "metricdeterminant", rayCached["MetricDeterminant", raySimp[Det[rayGDD[]]]],
    "volumeelement", raySimp[Sqrt[Abs[rayCached["MetricDeterminant", raySimp[Det[rayGDD[]]]]]]],

    "expansion",
      If[rayCongruenceQ[], rayExpansion[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "accelerationup",
      If[rayCongruenceQ[], rayAccelerationU[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "accelerationdown",
      If[rayCongruenceQ[], rayAccelerationD[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "shearscalar",
      If[rayCongruenceQ[], raySimp[rayShearContraction[]/2], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "vorticityscalar",
      If[rayCongruenceQ[], raySimp[rayVorticityContraction[]/2], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "riccialongu",
      If[rayCongruenceQ[], rayRicciAlongU[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "accelerationdivergence",
      If[rayCongruenceQ[], rayAccelerationDivergence[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],
    "raychaudhuriresidual",
      If[rayCongruenceQ[], rayRayResidual[], Return[rayFail["RAYRaw: define or activate a congruence first."]]],

    _, rayFail["RAYRaw: unknown quantity \"" <> quantity <> "\"."]
  ]
];

RAYRiemann[] := RAYNonzeroRiemann["uddd"];
RAYRiemann[config_String] := RAYNonzeroRiemann[config];
RAYRiemann[rho_Integer, sig_Integer, mu_Integer, nu_Integer] := RAYRiemann["uddd", rho, sig, mu, nu];

RAYRiemann[config_String, inds__Integer] /; rayRequireMetric[] === True := Module[
  {list = {inds}, cfg, data},
  If[Length[list] =!= 4, Return[rayFail["RAYRiemann: four component indices are required."]]];
  If[!And @@ (rayValidIndexQ /@ list), Return[rayFail["RAYRiemann: component index out of range."]]];
  cfg = rayParseConfig[config, 4];
  If[cfg === $Failed, Return[rayFail["RAYRiemann: config must contain four characters u/d, e.g. \"uddd\" or \"dddd\"."]]];
  data = rayTensorByName["Riemann", config];
  TraditionalForm[raySimp[rayComponent[data, list]]]
];

RAYRicci[] := RAYRicci["dd"];
RAYRicci[config_String] /; rayRequireMetric[] === True := Module[{cfg = rayParseConfig[config, 2], data},
  If[cfg === $Failed, Return[rayFail["RAYRicci: config must contain two characters u/d."]]];
  data = rayTensorByName["Ricci", config];
  rayDisplayMatrix[data]
];
RAYRicci[mu_Integer, nu_Integer] := RAYRicci["dd", mu, nu];
RAYRicci[config_String, mu_Integer, nu_Integer] /; rayRequireMetric[] === True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYRicci: component index out of range."]]];
  data = rayTensorByName["Ricci", config];
  If[data === $Failed, Return[rayFail["RAYRicci: invalid index configuration."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

RAYRicciScalar[] /; rayRequireMetric[] === True := TraditionalForm[rayRicciScalar[]];

RAYEinstein[] := RAYEinstein["dd"];
RAYEinstein[config_String] /; rayRequireMetric[] === True := Module[{data = rayTensorByName["Einstein", config]},
  If[data === $Failed, Return[rayFail["RAYEinstein: invalid index configuration."]]];
  rayDisplayMatrix[data]
];
RAYEinstein[mu_Integer, nu_Integer] := RAYEinstein["dd", mu, nu];
RAYEinstein[config_String, mu_Integer, nu_Integer] /; rayRequireMetric[] === True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYEinstein: component index out of range."]]];
  data = rayTensorByName["Einstein", config];
  If[data === $Failed, Return[rayFail["RAYEinstein: invalid index configuration."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

RAYWeyl[] := RAYNonzeroWeyl["dddd"];
RAYWeyl[config_String] := RAYNonzeroWeyl[config];
RAYWeyl[config_String, inds__Integer] /; rayRequireMetric[] === True := Module[{list = {inds}, data},
  If[Length[list] =!= 4, Return[rayFail["RAYWeyl: four component indices are required."]]];
  If[!And @@ (rayValidIndexQ /@ list), Return[rayFail["RAYWeyl: component index out of range."]]];
  data = rayTensorByName["Weyl", config];
  If[data === $Failed, Return[rayFail["RAYWeyl: invalid index configuration."]]];
  TraditionalForm[raySimp[rayComponent[data, list]]]
];

RAYWeyl[inds__Integer] := RAYWeyl["dddd", inds];

rayKretschmann[] /; rayRequireMetric[] === True := rayCached[
  "Kretschmann",
  Module[{rd, ru, d = rayDim[]},
    rd = rayTensorByName["Riemann", "dddd"];
    ru = rayTensorByName["Riemann", "uuuu"];
    raySimp[
      Sum[
        rd[[a, b, c, e]] ru[[a, b, c, e]],
        {a, d}, {b, d}, {c, d}, {e, d}
      ]
    ]
  ]
];

rayRicciSquared[] /; rayRequireMetric[] === True := rayCached[
  "RicciSquared",
  Module[{rd = rayTensorByName["Ricci", "dd"], ru = rayTensorByName["Ricci", "uu"], d = rayDim[]},
    raySimp[Sum[rd[[a, b]] ru[[a, b]], {a, d}, {b, d}]]
  ]
];

rayWeylSquared[] /; rayRequireMetric[] === True := rayCached[
  "WeylSquared",
  Module[{cd = rayTensorByName["Weyl", "dddd"], cu = rayTensorByName["Weyl", "uuuu"], d = rayDim[]},
    raySimp[
      Sum[
        cd[[a, b, c, e]] cu[[a, b, c, e]],
        {a, d}, {b, d}, {c, d}, {e, d}
      ]
    ]
  ]
];

RAYKretschmann[] /; rayRequireMetric[] === True := TraditionalForm[rayKretschmann[]];
RAYRicciSquared[] /; rayRequireMetric[] === True := TraditionalForm[rayRicciSquared[]];
RAYWeylSquared[] /; rayRequireMetric[] === True := TraditionalForm[rayWeylSquared[]];

rayNablaUD[] /; rayRequireCongruence[] === True := rayCached[
  "NablaUD",
  Module[{d = rayDim[], x = rayCoords[], uD = rayCongruenceObj[]["Down"], ga = rayGamma[]},
    Table[
      raySimp[
        D[uD[[nu]], x[[mu]]] -
        Sum[ga[[rho, mu, nu]] uD[[rho]], {rho, d}]
      ],
      {mu, d}, {nu, d}
    ]
  ]
];

rayNablaUU[] /; rayRequireCongruence[] === True := rayCached[
  "NablaUU",
  Module[{d = rayDim[], x = rayCoords[], uU = rayCongruenceObj[]["Up"], ga = rayGamma[]},
    Table[
      raySimp[
        D[uU[[nu]], x[[mu]]] +
        Sum[ga[[nu, mu, rho]] uU[[rho]], {rho, d}]
      ],
      {mu, d}, {nu, d}
    ]
  ]
];

RAYCovariantDerivativeU[] := RAYCovariantDerivativeU["dd"];
RAYCovariantDerivativeU[config_String] /; rayRequireCongruence[] === True := Switch[
  ToLowerCase[config],
  "dd", rayDisplayMatrix[rayNablaUD[]],
  "du", rayDisplayMatrix[rayNablaUU[]],
  _, rayFail["RAYCovariantDerivativeU: use \"dd\" for nabla_mu u_nu or \"du\" for nabla_mu u^nu."]
];

RAYCovariantDerivativeU[config_String, mu_Integer, nu_Integer] /; rayRequireCongruence[] === True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYCovariantDerivativeU: component index out of range."]]];
  data = Switch[ToLowerCase[config], "dd", rayNablaUD[], "du", rayNablaUU[], _, Return[rayFail["RAYCovariantDerivativeU: use \"dd\" or \"du\"."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

rayExpansion[] /; rayRequireCongruence[] === True := rayCached[
  "Expansion",
  Module[{d = rayDim[], n = rayNablaUU[]},
    raySimp[Sum[n[[mu, mu]], {mu, d}]]
  ]
];

RAYExpansion[] /; rayRequireCongruence[] === True := TraditionalForm[rayExpansion[]];

rayAccelerationD[] /; rayRequireCongruence[] === True := rayCached[
  "AccelerationD",
  Module[{d = rayDim[], u = rayCongruenceObj[]["Up"], nab = rayNablaUD[]},
    Table[
      raySimp[Sum[u[[mu]] nab[[mu, nu]], {mu, d}]],
      {nu, d}
    ]
  ]
];

rayAccelerationU[] /; rayRequireCongruence[] === True := rayCached[
  "AccelerationU",
  raySimp[rayGUU[] . rayAccelerationD[]]
];

RAYAcceleration[] := RAYAcceleration["u"];
RAYAcceleration[pos_String] /; rayRequireCongruence[] === True := Switch[
  ToLowerCase[pos],
  "u", rayDisplayVector[rayAccelerationU[]],
  "d", rayDisplayVector[rayAccelerationD[]],
  _, rayFail["RAYAcceleration: use \"u\" or \"d\"."]
];

RAYAcceleration[pos_String, mu_Integer] /; rayRequireCongruence[] === True := Module[{data},
  If[!rayValidIndexQ[mu], Return[rayFail["RAYAcceleration: component index out of range."]]];
  data = Switch[ToLowerCase[pos], "u", rayAccelerationU[], "d", rayAccelerationD[], _, Return[rayFail["RAYAcceleration: use \"u\" or \"d\"."]]];
  TraditionalForm[raySimp[data[[mu + 1]]]]
];

rayShearDD[] /; rayRequireCongruence[] === True := rayCached[
  "ShearDD",
  Module[
    {d = rayDim[], nab = rayNablaUD[], uD = rayCongruenceObj[]["Down"],
     eps = rayCongruenceObj[]["Epsilon"], aD = rayAccelerationD[], theta = rayExpansion[],
     sym},
    If[d <= 1, Return[$Failed]];
    sym = Table[raySimp[(nab[[mu, nu]] + nab[[nu, mu]])/2], {mu, d}, {nu, d}];
    raySimp[
      sym
      - eps (Outer[Times, uD, aD] + Outer[Times, aD, uD])/2
      - theta rayGDD[]/(d - 1)
      + eps theta Outer[Times, uD, uD]/(d - 1)
    ]
  ]
];

rayVorticityDD[] /; rayRequireCongruence[] === True := rayCached[
  "VorticityDD",
  Module[
    {d = rayDim[], nab = rayNablaUD[], uD = rayCongruenceObj[]["Down"],
     eps = rayCongruenceObj[]["Epsilon"], aD = rayAccelerationD[], anti},
    anti = Table[raySimp[(nab[[mu, nu]] - nab[[nu, mu]])/2], {mu, d}, {nu, d}];
    raySimp[
      anti
      - eps (Outer[Times, uD, aD] - Outer[Times, aD, uD])/2
    ]
  ]
];

RAYShear[] := RAYShear["dd"];
RAYShear[config_String] /; rayRequireCongruence[] === True := Module[{data = rayTensorByName["Shear", config]},
  If[data === $Failed, Return[rayFail["RAYShear: invalid index configuration."]]];
  rayDisplayMatrix[data]
];
RAYShear[mu_Integer, nu_Integer] := RAYShear["dd", mu, nu];
RAYShear[config_String, mu_Integer, nu_Integer] /; rayRequireCongruence[] === True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYShear: component index out of range."]]];
  data = rayTensorByName["Shear", config];
  If[data === $Failed, Return[rayFail["RAYShear: invalid index configuration."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

RAYVorticity[] := RAYVorticity["dd"];
RAYVorticity[config_String] /; rayRequireCongruence[] === True := Module[{data = rayTensorByName["Vorticity", config]},
  If[data === $Failed, Return[rayFail["RAYVorticity: invalid index configuration."]]];
  rayDisplayMatrix[data]
];
RAYVorticity[mu_Integer, nu_Integer] := RAYVorticity["dd", mu, nu];
RAYVorticity[config_String, mu_Integer, nu_Integer] /; rayRequireCongruence[] === True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu], Return[rayFail["RAYVorticity: component index out of range."]]];
  data = rayTensorByName["Vorticity", config];
  If[data === $Failed, Return[rayFail["RAYVorticity: invalid index configuration."]]];
  TraditionalForm[raySimp[data[[mu + 1, nu + 1]]]]
];

rayShearContraction[] /; rayRequireCongruence[] === True := rayCached[
  "ShearContraction",
  Module[{sd = rayTensorByName["Shear", "dd"], su = rayTensorByName["Shear", "uu"], d = rayDim[]},
    raySimp[Sum[sd[[mu, nu]] su[[mu, nu]], {mu, d}, {nu, d}]]
  ]
];

rayVorticityContraction[] /; rayRequireCongruence[] === True := rayCached[
  "VorticityContraction",
  Module[{wd = rayTensorByName["Vorticity", "dd"], wu = rayTensorByName["Vorticity", "uu"], d = rayDim[]},
    raySimp[Sum[wd[[mu, nu]] wu[[mu, nu]], {mu, d}, {nu, d}]]
  ]
];

RAYShearScalar[] /; rayRequireCongruence[] === True := TraditionalForm[raySimp[rayShearContraction[]/2]];
RAYVorticityScalar[] /; rayRequireCongruence[] === True := TraditionalForm[raySimp[rayVorticityContraction[]/2]];

rayRicciAlongU[] /; rayRequireCongruence[] === True := rayCached[
  "RicciAlongU",
  Module[{ric = rayRicciDD[], u = rayCongruenceObj[]["Up"], d = rayDim[]},
    raySimp[Sum[ric[[mu, nu]] u[[mu]] u[[nu]], {mu, d}, {nu, d}]]
  ]
];

RAYRicciAlongU[] /; rayRequireCongruence[] === True := TraditionalForm[rayRicciAlongU[]];

rayAccelerationDivergence[] /; rayRequireCongruence[] === True := rayCached[
  "AccelerationDivergence",
  Module[{a = rayAccelerationU[], ga = rayGamma[], x = rayCoords[], d = rayDim[]},
    raySimp[
      Sum[
        D[a[[mu]], x[[mu]]] +
        Sum[ga[[mu, mu, rho]] a[[rho]], {rho, d}],
        {mu, d}
      ]
    ]
  ]
];

RAYAccelerationDivergence[] /; rayRequireCongruence[] === True := TraditionalForm[rayAccelerationDivergence[]];

rayThetaDot[] /; rayRequireCongruence[] === True := rayCached[
  "ThetaDot",
  Module[{u = rayCongruenceObj[]["Up"], th = rayExpansion[], x = rayCoords[], d = rayDim[]},
    raySimp[Sum[u[[mu]] D[th, x[[mu]]], {mu, d}]]
  ]
];

rayRayTerms[] /; rayRequireCongruence[] === True := Module[
  {d = rayDim[], lhs, e, s, w, r, a, rhs},
  lhs = rayThetaDot[];
  e = raySimp[-rayExpansion[]^2/(d - 1)];
  s = raySimp[-rayShearContraction[]];
  w = raySimp[rayVorticityContraction[]];
  r = raySimp[-rayRicciAlongU[]];
  a = raySimp[rayAccelerationDivergence[]];
  rhs = raySimp[e + s + w + r + a];
  <|"LHS" -> lhs, "Expansion" -> e, "Shear" -> s, "Vorticity" -> w, "Ricci" -> r, "Acceleration" -> a, "RHS" -> rhs|>
];

RAYRaychaudhuriTerms[] /; rayRequireCongruence[] === True := Module[{q = rayRayTerms[]},
  Grid[
    {
      {Style["Raychaudhuri term", Bold], Style["Value", Bold]},
      {"u^alpha nabla_alpha theta", TraditionalForm[q["LHS"]]},
      {"- theta^2/(d-1)", TraditionalForm[q["Expansion"]]},
      {"- sigma_(mu nu) sigma^(mu nu)", TraditionalForm[q["Shear"]]},
      {"+ omega_(mu nu) omega^(mu nu)", TraditionalForm[q["Vorticity"]]},
      {"- R_(mu nu) u^mu u^nu", TraditionalForm[q["Ricci"]]},
      {"+ nabla_mu a^mu", TraditionalForm[q["Acceleration"]]},
      {Style["RHS total", Bold], TraditionalForm[q["RHS"]]},
      {Style["LHS - RHS", Bold], TraditionalForm[raySimp[q["LHS"] - q["RHS"]]]}
    },
    Frame -> All,
    Alignment -> Left,
    Spacings -> {2, 1},
    ItemStyle -> 12
  ]
];

rayRayResidual[] /; rayRequireCongruence[] === True := rayCached[
  "RayResidual",
  Module[{q = rayRayTerms[]}, raySimp[q["LHS"] - q["RHS"]]]
];

RAYRaychaudhuriResidual[] /; rayRequireCongruence[] === True := TraditionalForm[rayRayResidual[]];

rayKinematicDecompositionResidual[] /; rayRequireCongruence[] === True := Module[
  {nab = rayNablaUD[], sig = rayShearDD[], om = rayVorticityDD[], th = rayExpansion[],
   g = rayGDD[], uD = rayCongruenceObj[]["Down"], eps = rayCongruenceObj[]["Epsilon"],
   aD = rayAccelerationD[], d = rayDim[]},
  raySimp[
    nab - (
      sig + om +
      th (g - eps Outer[Times, uD, uD])/(d - 1) +
      eps Outer[Times, uD, aD]
    )
  ]
];

rayCheckPassQ[expr_] := TrueQ[raySimp[expr == 0]] ||
  TrueQ[raySimp[expr == ConstantArray[0, Dimensions[expr]]]];

rayStatus[expr_] := If[
  rayCheckPassQ[expr],
  Style["PASS", Darker[Green], Bold],
  Style["CHECK", Red, Bold]
];

RAYKinematicChecks[] /; rayRequireCongruence[] === True := Module[
  {u = rayCongruenceObj[]["Up"], uD = rayCongruenceObj[]["Down"], eps = rayCongruenceObj[]["Epsilon"],
   aU = rayAccelerationU[], sig = rayShearDD[], om = rayVorticityDD[], gi = rayGUU[], d = rayDim[],
   norm, accOrth, sigTrace, sigOrth, omOrth, omAnti, dec, rr},
  norm = raySimp[u . uD - eps];
  accOrth = raySimp[uD . aU];
  sigTrace = raySimp[Sum[gi[[mu, nu]] sig[[mu, nu]], {mu, d}, {nu, d}]];
  sigOrth = raySimp[u . sig];
  omOrth = raySimp[u . om];
  omAnti = raySimp[om + Transpose[om]];
  dec = rayKinematicDecompositionResidual[];
  rr = rayRayResidual[];

  Grid[
    {
      {Style["Check", Bold], Style["Residual", Bold], Style["Status", Bold]},
      {"u.u - epsilon", TraditionalForm[norm], rayStatus[norm]},
      {"u_mu a^mu", TraditionalForm[accOrth], rayStatus[accOrth]},
      {"trace(sigma)", TraditionalForm[sigTrace], rayStatus[sigTrace]},
      {"u^mu sigma_(mu nu)", TraditionalForm[sigOrth], rayStatus[sigOrth]},
      {"u^mu omega_(mu nu)", TraditionalForm[omOrth], rayStatus[omOrth]},
      {"omega_(mu nu)+omega_(nu mu)", TraditionalForm[MatrixForm[omAnti]], rayStatus[omAnti]},
      {"kinematic decomposition", TraditionalForm[MatrixForm[dec]], rayStatus[dec]},
      {"Raychaudhuri identity", TraditionalForm[rr], rayStatus[rr]}
    },
    Frame -> All,
    Alignment -> {{Left, Left, Center}},
    Spacings -> {2, 1},
    ItemStyle -> 11
  ]
];

RAYNonzeroChristoffel[] /; rayRequireMetric[] === True := Module[
  {ga = rayGamma[], d = rayDim[], tuples, rows},
  tuples = Tuples[Range[0, d - 1], 3];
  rows = Reap[
      Do[
        With[{val = raySimp[rayComponent[ga, inds]]},
          If[!TrueQ[raySimp[val == 0]],
            Sow[
              {
                rayIndexLabel["\[CapitalGamma]", inds, {1, -1, -1}],
                TraditionalForm[val]
              }
            ]
          ]
        ],
        {inds, tuples}
      ]
    ][[2]];
  rows = If[rows === {}, {}, First[rows]];
  Column[
    {
      Style["Nonzero Christoffel symbols", Bold, 15],
      If[
        rows === {},
        Style["All Christoffel symbols vanish.", Italic, 13],
        Grid[
          Prepend[rows, {Style["Component", Bold], Style["Value", Bold]}],
          Frame -> All,
          Alignment -> {{Center, Left}},
          Spacings -> {2, 1},
          ItemStyle -> 12
        ]
      ]
    }
  ]
];

RAYNonzeroRiemann[config_String:"uddd"] /; rayRequireMetric[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 4];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroRiemann: invalid index configuration."]]];
  data = rayTensorByName["Riemann", config];
  rayNonzeroGrid[data, cfg, "R", "Nonzero Riemann components  (" <> config <> ")"]
];

RAYNonzeroRicci[config_String:"dd"] /; rayRequireMetric[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 2];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroRicci: invalid index configuration."]]];
  data = rayTensorByName["Ricci", config];
  rayNonzeroGrid[data, cfg, "R", "Nonzero Ricci components  (" <> config <> ")"]
];

RAYNonzeroEinstein[config_String:"dd"] /; rayRequireMetric[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 2];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroEinstein: invalid index configuration."]]];
  data = rayTensorByName["Einstein", config];
  rayNonzeroGrid[data, cfg, "G", "Nonzero Einstein-tensor components  (" <> config <> ")"]
];

RAYNonzeroWeyl[config_String:"dddd"] /; rayRequireMetric[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 4];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroWeyl: invalid index configuration."]]];
  data = rayTensorByName["Weyl", config];
  rayNonzeroGrid[data, cfg, "C", "Nonzero Weyl components  (" <> config <> ")"]
];

RAYNonzeroShear[config_String:"dd"] /; rayRequireCongruence[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 2];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroShear: invalid index configuration."]]];
  data = rayTensorByName["Shear", config];
  rayNonzeroGrid[data, cfg, "\[Sigma]", "Nonzero shear components  (" <> config <> ")"]
];

RAYNonzeroVorticity[config_String:"dd"] /; rayRequireCongruence[] === True := Module[{cfg, data},
  cfg = rayParseConfig[config, 2];
  If[cfg === $Failed, Return[rayFail["RAYNonzeroVorticity: invalid index configuration."]]];
  data = rayTensorByName["Vorticity", config];
  rayNonzeroGrid[data, cfg, "\[Omega]", "Nonzero vorticity components  (" <> config <> ")"]
];

RAYGeometry[] /; rayRequireMetric[] === True := Column[
  {
    Style["RAY Geometry Report", 18, Bold],
    Grid[
      {
        {Style["Metric", Bold], $rayActiveMetric},
        {Style["Dimension", Bold], rayDim[]},
        {Style["Coordinates", Bold], TraditionalForm[rayCoords[]]},
        {Style["det(g)", Bold], RAYMetricDeterminant[]},
        {Style["sqrt(|g|)", Bold], RAYVolumeElement[]},
        {Style["Ricci scalar R", Bold], RAYRicciScalar[]},
        {Style["R_ab R^ab", Bold], RAYRicciSquared[]},
        {Style["Kretschmann", Bold], RAYKretschmann[]},
        {Style["C_abcd C^abcd", Bold], RAYWeylSquared[]}
      },
      Frame -> All,
      Alignment -> Left
    ],
    RAYNonzeroRicci[],
    RAYNonzeroEinstein[]
  },
  Spacings -> 1.2
];

RAYRaychaudhuri[] /; rayRequireCongruence[] === True := Column[
  {
    Style["RAY Raychaudhuri / Kinematics Report", 18, Bold],
    Grid[
      {
        {Style["Metric", Bold], $rayActiveMetric},
        {Style["Congruence", Bold], $rayActiveCongruence},
        {Style["epsilon = u.u", Bold], RAYCongruenceNorm[]},
        {Style["Expansion theta", Bold], RAYExpansion[]},
        {Style["a^mu", Bold], RAYAcceleration[]},
        {Style["sigma^2", Bold], RAYShearScalar[]},
        {Style["omega^2", Bold], RAYVorticityScalar[]},
        {Style["R_mu nu u^mu u^nu", Bold], RAYRicciAlongU[]},
        {Style["nabla_mu a^mu", Bold], RAYAccelerationDivergence[]},
        {Style["Raychaudhuri residual", Bold], RAYRaychaudhuriResidual[]}
      },
      Frame -> All,
      Alignment -> Left
    ],
    RAYNonzeroShear[],
    RAYNonzeroVorticity[],
    RAYRaychaudhuriTerms[],
    RAYKinematicChecks[]
  },
  Spacings -> 1.2
];

RAYReport[] /; rayRequireMetric[] === True := Column[
  DeleteCases[
    {
      Style["RAY Full Report", 20, Bold],
      RAYAbout[],
      RAYNonzeroChristoffel[],
      RAYNonzeroRiemann["uddd"],
      RAYNonzeroRicci["dd"],
      RAYNonzeroEinstein["dd"],
      RAYNonzeroWeyl["dddd"],
      Grid[
        {
          {Style["Scalar", Bold], Style["Value", Bold]},
          {"R", RAYRicciScalar[]},
          {"R_ab R^ab", RAYRicciSquared[]},
          {"R_abcd R^abcd", RAYKretschmann[]},
          {"C_abcd C^abcd", RAYWeylSquared[]}
        },
        Frame -> All,
        Alignment -> Left
      ],
      If[rayCongruenceQ[], RAYRaychaudhuri[], Nothing]
    },
    Nothing
  ],
  Spacings -> 1.3
];

$rayHelpRows = {
  {"RAYVersion", "Current RAY package version string."},
  {"RAYHelp[]", "Show the complete human-readable command table; RAYHelp[\"Ricci\"] or RAYHelp[\"RAYRicci\"] shows focused help."},
  {"RAYAbout[]", "Show conventions, active metric/congruence, curvature convention, and Raychaudhuri convention."},

  {"RAYDefineMetric[name, coords, g]", "Define and activate an explicit metric; dimension is inferred automatically."},
  {"RAYUseMetric[name]", "Switch to a previously defined metric."},
  {"RAYMetrics[]", "List all metrics currently defined in the session."},
  {"RAYCoordinates[]", "Coordinates of the active metric."},
  {"RAYDimension[]", "Dimension of the active metric."},
  {"RAYMetric[config]", "Metric components. config = dd, du, ud, uu."},
  {"RAYInverseMetric[]", "Display g^(mu nu), or request one inverse-metric component."},
  {"RAYMetricDeterminant[]", "Determinant det(g_mu nu)."},
  {"RAYVolumeElement[]", "Invariant coordinate volume factor sqrt(|det g|)."},
  {"RAYSignature[]", "Attempt to determine metric-eigenvalue signs under the active assumptions."},

  {"RAYDefineCongruence[name, u]", "Define/normalize and activate a non-null congruence u^mu for Raychaudhuri kinematics."},
  {"RAYUseCongruence[name]", "Switch to a previously defined congruence associated with the active metric."},
  {"RAYCongruences[]", "List congruences defined for the active metric."},
  {"RAYCongruence[pos]", "Display u^mu (pos=\"u\") or u_mu (pos=\"d\"), or request one component."},
  {"RAYCongruenceNorm[]", "Return epsilon = u^mu u_mu = +/-1 for the normalized active congruence."},

  {"RAYChristoffel[rho,mu,nu]", "One Christoffel symbol; no arguments lists all nonzero symbols."},
  {"RAYRiemann[config,rho,sigma,mu,nu]", "Riemann tensor component with arbitrary index placement."},
  {"RAYRicci[config,mu,nu]", "Ricci tensor or one Ricci component."},
  {"RAYRicciScalar[]", "Ricci scalar R."},
  {"RAYEinstein[config,mu,nu]", "Einstein tensor with arbitrary index placement."},
  {"RAYWeyl[config,...]", "Weyl tensor; identically zero for dimension d <= 3."},
  {"RAYKretschmann[]", "Kretschmann scalar R_abcd R^abcd."},
  {"RAYRicciSquared[]", "Quadratic Ricci invariant R_ab R^ab."},
  {"RAYWeylSquared[]", "Quadratic Weyl invariant C_abcd C^abcd."},

  {"RAYCovariantDerivativeU[config]", "nabla_mu u_nu (dd) or nabla_mu u^nu (du), including component access."},
  {"RAYExpansion[]", "Expansion theta = nabla_mu u^mu."},
  {"RAYAcceleration[pos,mu]", "Acceleration a^mu or a_mu."},
  {"RAYShear[config,mu,nu]", "Shear sigma_mu nu with arbitrary up/down index placement."},
  {"RAYVorticity[config,mu,nu]", "Vorticity omega_mu nu with arbitrary up/down index placement."},
  {"RAYShearScalar[]", "(1/2) sigma_mu nu sigma^mu nu."},
  {"RAYVorticityScalar[]", "(1/2) omega_mu nu omega^mu nu."},
  {"RAYRicciAlongU[]", "Contraction R_mu nu u^mu u^nu."},
  {"RAYAccelerationDivergence[]", "Divergence nabla_mu a^mu."},
  {"RAYRaychaudhuriTerms[]", "Term-by-term Raychaudhuri equation in a readable table."},
  {"RAYRaychaudhuriResidual[]", "LHS - RHS of the Raychaudhuri identity; should simplify to zero."},
  {"RAYKinematicChecks[]", "Normalization, orthogonality, trace, antisymmetry, decomposition, and Raychaudhuri checks."},

  {"RAYNonzeroChristoffel[]", "Human-readable table of all nonzero Christoffel symbols."},
  {"RAYNonzeroRiemann[config]", "Human-readable table of nonzero Riemann components."},
  {"RAYNonzeroRicci[config]", "Human-readable table of nonzero Ricci components."},
  {"RAYNonzeroEinstein[config]", "Human-readable table of nonzero Einstein-tensor components."},
  {"RAYNonzeroWeyl[config]", "Human-readable table of nonzero Weyl components."},
  {"RAYNonzeroShear[config]", "Human-readable table of nonzero shear components."},
  {"RAYNonzeroVorticity[config]", "Human-readable table of nonzero vorticity components."},

  {"RAYGeometry[]", "Compact geometry report for the active metric."},
  {"RAYRaychaudhuri[]", "Compact congruence/Raychaudhuri report."},
  {"RAYReport[]", "Full geometry + Raychaudhuri report in one command."},
  {"RAYRaw[quantity,config]", "Raw arrays/scalars for algebra and programmatic work; scalar form also supports RAYRaw[quantity]."},
  {"RAYClearCache[]", "Clear all derived-tensor caches while keeping metric and congruence definitions."}
};

RAYHelp[] := Column[
  {
    Style["RAY — Raychaudhuri + General Relativity Package", 18, Bold],
    Style["All displayed tensor components use physical indices 0,1,...,d-1.", Italic, 12],
    Grid[
      Prepend[$rayHelpRows, {Style["Command", Bold], Style["What it does", Bold]}],
      Frame -> All,
      Alignment -> Left,
      Spacings -> {1.5, 0.8},
      ItemStyle -> 11
    ],
    Style["Standard Mathematica help also works: ?RAYRicci, ?RAYShear, ?RAYReport, ...", Italic, 12]
  },
  Spacings -> 1
];

RAYHelp[command_String] := Module[{full, row},
  full = If[StringStartsQ[command, "RAY"], command, "RAY" <> command];

  row = SelectFirst[
    $rayHelpRows,
    Function[r,
      StringStartsQ[r[[1]], full <> "["] ||
      r[[1]] === full
    ],
    Missing["NotFound"]
  ];

  If[
    MissingQ[row],
    rayFail["RAYHelp: unknown command \"" <> command <> "\"."],
    Grid[
      {
        {Style[row[[1]], Bold, 15]},
        {row[[2]]}
      },
      Frame -> All,
      Alignment -> Left,
      Spacings -> {1.5, 0.8}
    ]
  ]
];

RAYAbout[] := Grid[
  {
    {Style["Package", Bold], "RAY — Raychaudhuri + General Relativity"},
    {Style["Version", Bold], $RAYVersion},
    {Style["Active metric", Bold], If[rayMetricQ[], $rayActiveMetric, "None"]},
    {Style["Active congruence", Bold], If[rayCongruenceQ[], $rayActiveCongruence, "None"]},
    {Style["Riemann convention", Bold], "R^rho_(sigma mu nu) = d_mu Gamma^rho_(nu sigma) - d_nu Gamma^rho_(mu sigma) + Gamma^rho_(mu lambda) Gamma^lambda_(nu sigma) - Gamma^rho_(nu lambda) Gamma^lambda_(mu sigma)"},
    {Style["Ricci convention", Bold], "R_(sigma nu) = R^rho_(sigma rho nu)"},
    {Style["Signature", Bold], "Not hard-coded. The explicit metric carries the sign convention."},
    {Style["Raychaudhuri", Bold], "Works for normalized non-null congruences with epsilon = u.u = +/-1 in arbitrary dimension d > 1."},
    {Style["Shear/vorticity implementation", Bold], "Expanded definitions from covariant derivatives; no explicit spatial-projector tensor is introduced."}
  },
  Frame -> All,
  Alignment -> Left,
  Spacings -> {1.5, 0.8}
];

(* Optional development modules: loaded before leaving the private context. *)






$rayHelpRows=Join[$rayHelpRows,{
  {"RAYRaw[RAYRicci[dd]]","Raw form of a complete RAY geometry call."},
  {"RAYMetricVariables[]","Symmetric formal inverse metric variables for varying matter Lagrangians."},
  {"RAYMatterAction[L]","Calculate the Hilbert stress tensor from a matter Lagrangian."},
  {"RAYStressTensor[dd]","Component stress tensor; use RAYRaw for algebra."},
  {"RAYEinsteinEquations[G,T]","Einstein equations with optional cosmological constant/coupling; T defaults to zero."},
  {"RAYCovD[tensor,config]","Component covariant derivative (derivative index first)."},
  {"RAYWarpedMetric[name,blocks]","Metric with independently warped diagonal blocks."},
  {"RAYSymbolicMetric[name,dim]","Formal abstract metric and coordinate-component descriptor."},
  {"RAYAbstractCovD[expr,index]","Formal covariant derivative with product rule and metric compatibility."},
  {"RAYConventions[]","Dimension, signature and field-equation conventions."},
  {"RAYSolve[eqs,fields,domain,ICs]","Numerically solve one or many IC sets."},
  {"RAYPlot[solution,quantities]","Quantity-color-consistent, IC-style-distinct plots."},
  {"RAYSolveWizard[eqs,fields,domain]","Interactive notebook dialog for numeric workflow."}
}];


(* ---- embedded Kernel/RAYRawExtensions.wl ---- *)
(* RAY raw-access extension, evaluated inside the package Private context. *)
SetAttributes[RAYRaw, HoldFirst];

rayRawComponent[name_String,cfg_String,inds_List] := Module[{data,d=rayDim[]},
  If[!AllTrue[inds,IntegerQ[#] && 0<=#<d&],Return[$Failed]];
  data=rayTensorByName[name,cfg];
  If[data===$Failed,Return[$Failed]];
  Extract[data,inds+1]
];

RAYRaw["Ricci"] := rayRicciDD[];
RAYRaw["Einstein"] := rayEinsteinDD[];
RAYRaw["Riemann"] := rayRiemannUDDD[];
RAYRaw["Metric"] := rayGDD[];
RAYRaw["InverseMetric"] := rayGUU[];
RAYRaw["Weyl"] := rayWeylDDDD[];
RAYRaw["Christoffel"] := rayGamma[];

RAYRaw[RAYMetric[]] := rayGDD[];
RAYRaw[RAYMetric[c_String]] := RAYRaw["Metric",c];
RAYRaw[RAYInverseMetric[]] := rayGUU[];
RAYRaw[RAYRicci[]] := rayRicciDD[];
RAYRaw[RAYRicci[c_String]] := RAYRaw["Ricci",c];
RAYRaw[RAYEinstein[]] := rayEinsteinDD[];
RAYRaw[RAYEinstein[c_String]] := RAYRaw["Einstein",c];
RAYRaw[RAYRiemann[]] := rayRiemannUDDD[];
RAYRaw[RAYRiemann[c_String]] := RAYRaw["Riemann",c];
RAYRaw[RAYWeyl[]] := rayWeylDDDD[];
RAYRaw[RAYWeyl[c_String]] := RAYRaw["Weyl",c];
RAYRaw[RAYChristoffel[]] := rayGamma[];
RAYRaw[RAYShear[]] := rayShearDD[];
RAYRaw[RAYShear[c_String]] := RAYRaw["Shear",c];
RAYRaw[RAYVorticity[]] := rayVorticityDD[];
RAYRaw[RAYVorticity[c_String]] := RAYRaw["Vorticity",c];

RAYRaw[RAYMetric[c_String,i_Integer,j_Integer]] := rayRawComponent["Metric",c,{i,j}];
RAYRaw[RAYRicci[c_String,i_Integer,j_Integer]] := rayRawComponent["Ricci",c,{i,j}];
RAYRaw[RAYEinstein[c_String,i_Integer,j_Integer]] := rayRawComponent["Einstein",c,{i,j}];
RAYRaw[RAYRiemann[c_String,i_Integer,j_Integer,k_Integer,l_Integer]] :=
  rayRawComponent["Riemann",c,{i,j,k,l}];
RAYRaw[RAYWeyl[c_String,i_Integer,j_Integer,k_Integer,l_Integer]] :=
  rayRawComponent["Weyl",c,{i,j,k,l}];
RAYRaw[RAYRicciScalar[]] := rayRicciScalar[];
RAYRaw[RAYKretschmann[]] := rayKretschmann[];
RAYRaw[RAYRicciSquared[]] := rayRicciSquared[];
RAYRaw[RAYWeylSquared[]] := rayWeylSquared[];
RAYRaw[RAYExpansion[]] := rayExpansion[];
RAYRaw[RAYShearScalar[]] := rayShearContraction[]/2;
RAYRaw[RAYVorticityScalar[]] := rayVorticityContraction[]/2;
RAYRaw[RAYRaychaudhuriResidual[]] := rayRayResidual[];

(* A symbol holding a string can be evaluated explicitly when desired:
   RAYRaw[Evaluate[name], "dd"]. *)

(* Bare command symbols are also accepted for fast notebook input. *)
RAYRaw[RAYMetric,c_String] := RAYRaw["Metric",c];
RAYRaw[RAYRicci,c_String] := RAYRaw["Ricci",c];
RAYRaw[RAYEinstein,c_String] := RAYRaw["Einstein",c];
RAYRaw[RAYRiemann,c_String] := RAYRaw["Riemann",c];
RAYRaw[RAYWeyl,c_String] := RAYRaw["Weyl",c];
RAYRaw[RAYShear,c_String] := RAYRaw["Shear",c];
RAYRaw[RAYVorticity,c_String] := RAYRaw["Vorticity",c];
RAYRaw[RAYChristoffel] := rayGamma[];
RAYRaw[RAYRicciScalar] := rayRicciScalar[];
RAYRaw[RAYKretschmann] := rayKretschmann[];


(* ---- embedded Kernel/RAYMatter.wl ---- *)
(* Explicit matter action, Hilbert stress tensor, field-equation construction. *)
(* L_m may depend algebraically on the inverse metric, not its derivatives.
   Matter tensors/field strengths must be supplied as explicit components. *)

$rayInverseVariables=<||>;
$rayMatterActions=<||>;

RAYMetricVariables[] /; rayRequireMetric[]===True := Module[
  {key=$rayActiveMetric,d=rayDim[],fresh,q},
  If[KeyExistsQ[$rayInverseVariables,key] &&
    Dimensions[$rayInverseVariables[key]]==={d,d},
    Return[$rayInverseVariables[key]]];
  fresh=Table[If[i<=j,Unique["rayInv$"],0],{i,d},{j,d}];
  q=Table[fresh[[Min[i,j],Max[i,j]]],{i,d},{j,d}];
  AssociateTo[$rayInverseVariables,key->q];
  q
];

RAYScalarLagrangian[field_,potential_:0] /; rayRequireMetric[]===True :=
 Module[{q=RAYMetricVariables[],x=rayCoords[],d=rayDim[]},
   -1/2 Sum[q[[i,j]] D[field,x[[i]]] D[field,x[[j]]],
     {i,d},{j,d}]-potential
 ];

RAYMaxwellLagrangian[F_List] /; rayRequireMetric[]===True :=
 Module[{q=RAYMetricVariables[],d=rayDim[]},
   If[Dimensions[F]=!={d,d},
     Return[rayFail["RAYMaxwellLagrangian: F must be a d x d antisymmetric matrix."]]];
   -1/4 Sum[q[[i,j]]q[[k,l]] F[[i,k]] F[[j,l]],
     {i,d},{j,d},{k,d},{l,d}]
 ];

Options[RAYMatterAction]={"Name"->"Matter","Store"->True};

RAYMatterAction[fn_Function,opts:OptionsPattern[]] /; rayRequireMetric[]===True :=
  RAYMatterAction[fn[RAYMetricVariables[]],opts];

RAYMatterAction[lag_,OptionsPattern[]] /; rayRequireMetric[]===True :=
 Module[{d=rayDim[],q=RAYMetricVariables[],inv=rayGUU[],g=rayGDD[],
    rules,L,stress,deriv,nm=OptionValue["Name"],data},
  If[!StringQ[nm],
    Return[rayFail["RAYMatterAction: \"Name\" must be a string."]]];
  rules=Flatten[Table[q[[i,j]]->inv[[i,j]],{i,d},{j,i,d}]];
  L=raySimp[lag/.rules];
  stress=Table[
    deriv=With[{v=q[[i,j]]},D[lag,v]]/If[i===j,1,2];
    raySimp[g[[i,j]] L-2 (deriv/.rules)],
    {i,d},{j,d}
  ];
  data=<|
   "Name"->nm,"Metric"->$rayActiveMetric,"Dimension"->d,
   "Lagrangian"->L,"StressTensor"->stress,
   "Convention"->"T_ab = g_ab L_m - 2 delta L_m / delta g^ab"
  |>;
  If[TrueQ[OptionValue["Store"]],
    AssociateTo[$rayMatterActions,$rayActiveMetric->data]];
  data
];

rayMatterStressDD[] := Module[{obj=Lookup[$rayMatterActions,$rayActiveMetric,Missing["None"]]},
  If[MissingQ[obj],
    Return[rayFail["RAYStressTensor: store a matter action first."]]];
  obj["StressTensor"]
];

RAYStressTensor[] := RAYStressTensor["dd"];
RAYStressTensor[c_String] /; rayRequireMetric[]===True :=
 Module[{cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[raw===$Failed || cfg===$Failed,
    Return[rayFail["RAYStressTensor: invalid index configuration or missing action."]]];
  rayDisplayMatrix[rayChangeIndices[raw,{-1,-1},cfg]]
 ];
RAYStressTensor[c_String,i_Integer,j_Integer] /; rayRequireMetric[]===True :=
 Module[{cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[raw===$Failed || cfg===$Failed ||
      !And@@(rayValidIndexQ/@{i,j}),Return[$Failed]];
  raySimp[Extract[rayChangeIndices[raw,{-1,-1},cfg],{i,j}+1]]
 ];

RAYRaw["StressTensor"] := rayMatterStressDD[];
RAYRaw["StressTensor",c_String] := Module[
  {cfg=rayParseConfig[c,2],raw=rayMatterStressDD[]},
  If[cfg===$Failed || raw===$Failed,Return[$Failed]];
  rayChangeIndices[raw,{-1,-1},cfg]
];
RAYRaw[RAYStressTensor[]] := rayMatterStressDD[];
RAYRaw[RAYStressTensor[c_String]] := RAYRaw["StressTensor",c];
RAYRaw[RAYStressTensor[c_String,i_Integer,j_Integer]] :=
 Module[{tensor=RAYRaw["StressTensor",c]},
  If[tensor===$Failed || !And@@(rayValidIndexQ/@{i,j}),Return[$Failed]];
  Extract[tensor,{i,j}+1]
 ];

Options[RAYEinsteinEquations]={
  "Coupling"->1,"CosmologicalConstant"->0,
  "Components"->"UpperTriangle","DropIdentities"->True,
  "Return"->"Equations"
};

RAYEinsteinEquations[opts:OptionsPattern[]] /; rayRequireMetric[]===True :=
  RAYEinsteinEquations[rayEinsteinDD[],0,opts];

RAYEinsteinEquations[einstein_List,opts:OptionsPattern[]] :=
  RAYEinsteinEquations[einstein,0,opts];

RAYEinsteinEquations[einstein_List,stress_,OptionsPattern[]] /;
  rayRequireMetric[]===True :=
 Module[{d=rayDim[],g=rayGDD[],source,chosen,pairs,eq,
  kappa=OptionValue["Coupling"],
  lambda=OptionValue["CosmologicalConstant"],
  components=OptionValue["Components"],
  ret=OptionValue["Return"]},
  If[Dimensions[einstein]=!={d,d},
    Return[rayFail["RAYEinsteinEquations: Einstein tensor must be d x d."]]];
  source=If[stress===0,ConstantArray[0,{d,d}],stress];
  If[Dimensions[source]=!={d,d},
    Return[rayFail["RAYEinsteinEquations: stress tensor must be d x d or zero."]]];
  chosen=Switch[components,
    "UpperTriangle",Select[Tuples[Range[0,d-1],2],#[[1]]<=#[[2]]&],
    "Diagonal",Table[{i,i},{i,0,d-1}],
    "All",Tuples[Range[0,d-1],2],
    _List,components,
    _,Return[rayFail["RAYEinsteinEquations: unknown component selection."]]
  ];
  If[!AllTrue[chosen,
       MatchQ[#,{_Integer,_Integer}] && And@@(rayValidIndexQ/@#)&],
    Return[rayFail["RAYEinsteinEquations: indices must be between 0 and d-1."]]];
  pairs=Table[
    {p,raySimp[
      einstein[[p[[1]]+1,p[[2]]+1]]+
      lambda g[[p[[1]]+1,p[[2]]+1]]-
      kappa source[[p[[1]]+1,p[[2]]+1]]
    ]},
    {p,chosen}
  ];
  If[TrueQ[OptionValue["DropIdentities"]],
    pairs=Select[pairs,!TrueQ[#[[2]]===0]&]];
  eq=(#[[2]]==0)&/@pairs;
  Switch[ret,
   "Association",<|"Equations"->eq,"Components"->(First/@pairs),
      "Residuals"->(Last/@pairs),
      "Coupling"->kappa,"CosmologicalConstant"->lambda|>,
   "Residuals",Last/@pairs,
   _,eq
  ]
];


(* ---- embedded Kernel/RAYNumerics.wl ---- *)
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


(* ---- embedded Kernel/RAYSymbolic.wl ---- *)
(* RAY: component covariant derivatives, warped metric products, and
   conservative abstract-index starter (not a replacement for xAct). *)

RAYCovD[tensor_List,config_String] /; rayRequireMetric[]===True :=
 Module[{rank=ArrayDepth[tensor],d=rayDim[],cfg,ga=rayGamma[],
   coords=rayCoords[],output,inds,mu,slots,val,position,term,lam},
  cfg=rayParseConfig[config,rank];
  If[cfg===$Failed || Dimensions[tensor]=!=ConstantArray[d,rank],
    Return[rayFail["RAYCovD: invalid array dimensions or u/d index string."]]];
  output=ConstantArray[0,ConstantArray[d,rank+1]];
  Do[
    mu=inds[[1]];slots=Rest[inds];
    val=D[Extract[tensor,slots],coords[[mu]]];
    Do[
      term=Sum[
        If[cfg[[position]]==1,
          ga[[slots[[position]],mu,lam]]*
            Extract[tensor,ReplacePart[slots,position->lam]],
          -ga[[lam,mu,slots[[position]]]]*
            Extract[tensor,ReplacePart[slots,position->lam]]
        ],{lam,d}];
      val+=term,
      {position,rank}
    ];
    output[[Sequence@@inds]]=raySimp[val],
    {inds,Tuples[Range[d],rank+1]}
  ];
  output
 ];

Options[RAYWarpedMetric]=Options[RAYDefineMetric];
RAYWarpedMetric[name_String,blocks_List,OptionsPattern[]] :=
 Module[{valid,coords,sizes,dim,mat,start=1,b,part,n,i,j},
  valid=blocks=!={} && AllTrue[blocks,
    MatchQ[#,{_List,_List,_}] &&
      MatrixQ[#[[2]]] &&
      Dimensions[#[[2]]]==={Length[#[[1]]],Length[#[[1]]]}&];
  If[!valid,
    Return[rayFail["RAYWarpedMetric: blocks must be {coordinates, metric matrix, full multiplier}."]]];
  coords=Flatten[blocks[[All,1]]];
  If[Length[DeleteDuplicates[coords]]=!=Length[coords],
    Return[rayFail["RAYWarpedMetric: coordinate names must be distinct."]]];
  sizes=Length/@blocks[[All,1]];
  dim=Total[sizes];mat=ConstantArray[0,{dim,dim}];
  Do[
    n=sizes[[b]];
    part=blocks[[b,3]] blocks[[b,2]];
    Do[mat[[start+i-1,start+j-1]]=part[[i,j]],{i,n},{j,n}];
    start+=n,
    {b,Length[blocks]}
  ];
  RAYDefineMetric[name,coords,mat,
    Assumptions->OptionValue[Assumptions],
    "Simplification"->OptionValue["Simplification"]]
 ];

Options[RAYSymbolicMetric]={
 "Signature"->Automatic,"Symmetry"->"General"
};

(* Without coordinates this descriptor contains only abstract tensor
   names, dimension and convention metadata. *)
RAYSymbolicMetric[name_String,dim_Integer?Positive,OptionsPattern[]] :=
 Module[{sgn=OptionValue["Signature"],sym=OptionValue["Symmetry"]},
  If[!MemberQ[{"General","Diagonal"},sym],
    Return[rayFail["RAYSymbolicMetric: Symmetry must be General or Diagonal."]]];
  If[sgn=!=Automatic && (!ListQ[sgn]||Length[sgn]=!=dim),
    Return[rayFail["RAYSymbolicMetric: signature length differs from dimension."]]];
  <|"Name"->name,"Dimension"->dim,
    "Signature"->sgn,"Symmetry"->sym,
    "MetricTensor"->RAYTensor["Metric",{"d","d"}],
    "InverseMetricTensor"->RAYTensor["Metric",{"u","u"}],
    "RicciTensor"->RAYTensor["Ricci",{"d","d"}],
    "RiemannTensor"->RAYTensor["Riemann",{"u","d","d","d"}],
    "Convention"->"R^a_bcd = partial_c Gamma^a_db - partial_d Gamma^a_cb + ..."
  |>
 ];

(* Coordinate specification prepares generic symmetric component
   functions, without inverting a huge unconstrained matrix. *)
RAYSymbolicMetric[name_String,coords_List,opts:OptionsPattern[]] :=
 Module[{base=RAYSymbolicMetric[name,Length[coords],opts],d=Length[coords],
   sym=OptionValue["Symmetry"],f,mat},
  If[base===$Failed,Return[$Failed]];
  f=Table[
    If[i<=j,If[sym==="Diagonal" && i=!=j,0,
      Unique["rayMetricComponent$"]@@coords],0],
    {i,d},{j,d}];
  mat=Table[f[[Min[i,j],Max[i,j]]],{i,d},{j,d}];
  Join[base,<|"Coordinates"->coords,"Components"->mat|>]
 ];

RAYInstantiateMetric[descriptor_Association,matrix_:Automatic] :=
 Module[{coords=Lookup[descriptor,"Coordinates",Missing["None"]],
   g=If[matrix===Automatic,Lookup[descriptor,"Components",Missing["None"]],matrix]},
  If[MissingQ[coords] || MissingQ[g],
    Return[rayFail["RAYInstantiateMetric: descriptor requires coordinates and a component matrix."]]];
  RAYDefineMetric[descriptor["Name"],coords,g]
 ];

(* Formal abstract differentiation. No dummy-index canonicalization,
   commutation of covariant derivatives or curvature simplification. *)
RAYAbstractCovD[expr_Plus,mu_] := Map[RAYAbstractCovD[#,mu]&,expr];
RAYAbstractCovD[expr_Times,mu_] := Module[{f=List@@expr},
  Total[Table[
    Times@@ReplacePart[f,k->RAYAbstractCovD[f[[k]],mu]],
    {k,Length[f]}]]
 ];
RAYAbstractCovD[expr_?NumericQ,mu_] := 0;
RAYAbstractCovD[RAYTensor["Metric",_],mu_] := 0;
RAYAbstractCovD[expr_,mu_] := RAYNabla[If[Head[mu]===RAYDown,mu,RAYDown[mu]],expr];

RAYConventions[] := Grid[
 {
  {Style["Dimension",Bold],If[rayMetricQ[],rayDim[],"No active metric"]},
  {Style["Signature",Bold],If[rayMetricQ[],RAYSignature[],"Metric-dependent"]},
  {Style["Riemann",Bold],
   "R^a_(bcd) = partial_c Gamma^a_(db) - partial_d Gamma^a_(cb) + Gamma^a_(ce) Gamma^e_(db) - Gamma^a_(de) Gamma^e_(cb)"},
  {Style["Ricci",Bold],"R_(bd) = R^a_(bad)"},
  {Style["Einstein",Bold],"G_(ab) = R_(ab) - (R/2) g_(ab)"},
  {Style["Hilbert stress",Bold],
   "T_(ab) = g_(ab) L_m - 2 delta L_m / delta g^(ab)"},
  {Style["Einstein equations",Bold],
   "G_(ab) + Lambda g_(ab) = kappa T_(ab)"},
  {Style["Warped metric",Bold],
   "Each block contributes its full multiplier times the block metric"},
  {Style["Abstract status",Bold],
   "Formal tensors/product rule only; xAct-level canonicalization is not implemented"}
 },Frame->All,Alignment->Left
];


(* ---- embedded Kernel/RAYAbstractAlgebra.wl ---- *)
(* RAY abstract-index algebra, v1.2 development.
   Indices are RAYUp[label] / RAYDown[label], e.g.
   RAYTensor["F",{RAYDown[a],RAYDown[b]}].
   Free indices occur once per monomial. A dummy occurs precisely twice,
   once upper and once lower. No implicit contraction from a bare repeated
   variable outside RAYTensor index lists. *)

$rayAbstractSymmetries=<||>;

Options[RAYDeclareSymmetry]={"Slots"->{1,2}};
RAYDeclareSymmetry[name_String,kind_String,OptionsPattern[]] := Module[
  {slots=OptionValue["Slots"]},
  If[!MemberQ[{"Symmetric","Antisymmetric"},kind] ||
     !MatchQ[slots,{_Integer,_Integer}] ||
     slots[[1]]===slots[[2]] || Min[slots]<1,
    Return[rayFail["RAYDeclareSymmetry: use Symmetric/Antisymmetric and two distinct positive slots."]]];
  AssociateTo[$rayAbstractSymmetries,name-><|"Kind"->kind,"Slots"->slots|>];
  name
];

rayAbsIndexQ[RAYUp[_]]:=True;
rayAbsIndexQ[RAYDown[_]]:=True;
rayAbsIndexQ[_]:=False;
rayAbsLabel[RAYUp[x_]]:=x;
rayAbsLabel[RAYDown[x_]]:=x;
rayAbsVariance[RAYUp[_]]:=1;
rayAbsVariance[RAYDown[_]]:=-1;
rayAbsFlip[RAYUp[x_]]:=RAYDown[x];
rayAbsFlip[RAYDown[x_]]:=RAYUp[x];
rayAbsReplaceLabel[RAYUp[x_],rules_]:=RAYUp[x/.rules];
rayAbsReplaceLabel[RAYDown[x_],rules_]:=RAYDown[x/.rules];
rayAbsSortKey[x_]:=ToString[Unevaluated[x],InputForm];

rayAbsSwap[indices_,i_,j_]:=ReplacePart[indices,{
 i->indices[[j]],j->indices[[i]]}];

rayAbsGenerators[name_,idx_List]:=Module[{n=Length[idx],gens={},sym},
  If[MemberQ[{"Metric","Ricci"},name] && n===2 &&
     rayAbsVariance[idx[[1]]]===rayAbsVariance[idx[[2]]],
    AppendTo[gens,{{1,2},1}]];
  If[name==="Riemann" && n===4,
    AppendTo[gens,{{3,4},-1}];
    If[SameQ@@(rayAbsVariance/@idx),
      AppendTo[gens,{{1,2},-1}];
      AppendTo[gens,{{3,4,1,2},1}]]];
  If[KeyExistsQ[$rayAbstractSymmetries,name],
    sym=$rayAbstractSymmetries[name];
    If[Max[sym["Slots"]]<=n,
      AppendTo[gens,{sym["Slots"],
        If[sym["Kind"]==="Symmetric",1,-1]}]]];
  gens
];

(* Generates the orbit under index symmetries; the four-index pair
   interchange is a permutation {3,4,1,2}. *)
rayAbsTensorNormalize[RAYTensor[name_String,idx_List]]:=Catch[Module[
  {gens=rayAbsGenerators[name,idx],queue={{idx,1}},seen=<||>,
   cur,inds,sgn,new,p,rule,ordered},
  If[!AllTrue[idx,rayAbsIndexQ],
    Return[RAYTensor[name,idx]]];
  While[queue=!={},
    cur=First[queue];queue=Rest[queue];
    inds=cur[[1]];sgn=cur[[2]];
    p=rayAbsSortKey[inds];
    If[KeyExistsQ[seen,p],
      If[seen[p][[2]] =!= sgn,Throw[0,"RAYTensorNorm"]];
      Continue[]];
    AssociateTo[seen,p->{inds,sgn}];
    Do[
      rule=g[[1]];
      new=If[Length[rule]===2,
        rayAbsSwap[inds,rule[[1]],rule[[2]]],
        inds[[rule]]];
      AppendTo[queue,{new,sgn*g[[2]]}],
      {g,gens}
    ];
  ];
  ordered=First@SortBy[Values[seen],rayAbsSortKey[#[[1]]]&];
  ordered[[2]] RAYTensor[name,ordered[[1]]]
],"RAYTensorNorm"];
rayAbsTensorNormalize[x_]:=x;

rayAbsFactors[term_]:=If[Head[term]===Times,List@@term,{term}];

rayAbsRenameIndices[expr_,mapping_List] :=
 expr/.{
   RAYUp[x_] :> RAYUp[x/.mapping],
   RAYDown[x_] :> RAYDown[x/.mapping]
 };

rayAbsCanonicalTerm[term_]:=Module[
  {normalized,indices,groups,dummies,mappings,perms,candidates},
  normalized=Times@@(rayAbsTensorNormalize/@rayAbsFactors[term]);
  If[normalized===0,Return[0]];
  indices=Join[Cases[normalized,RAYUp[x_]:>{x,1},Infinity],
    Cases[normalized,RAYDown[x_]:>{x,-1},Infinity]];
  groups=GatherBy[indices,First];
  dummies=First[First[#]]& /@
    Select[groups,Length[#]===2 &&
      Sort[#[[All,2]]] === {-1,1}&];
  If[dummies==={},Return[normalized]];
  (* Stable canonicalization of dummy indices independent of their
     user-supplied spelling. Limit factorial search for large expressions. *)
  perms=If[Length[dummies]<=6,
    Permutations[Range[Length[dummies]]],
    {Range[Length[dummies]]}];
  candidates=Table[
    mappings=Thread[dummies->
      (RAYDummy/@permutation)];
    Times@@(rayAbsTensorNormalize/@rayAbsFactors[
      rayAbsRenameIndices[normalized,mappings]]),
    {permutation,perms}];
  First@SortBy[candidates,rayAbsSortKey]
];

RAYCanonicalize[expr_] := Module[{expanded=Expand[expr],terms},
  terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
  Expand[Total[rayAbsCanonicalTerm/@terms]]
];

RAYIndexCheck[expr_] := Module[{terms,perTerm,indices,groups,invalid},
  terms=If[Head[Expand[expr]]===Plus,
    List@@Expand[expr],{Expand[expr]}];
  perTerm=Table[
    indices=Join[Cases[term,RAYUp[x_]:>{x,1},Infinity],
      Cases[term,RAYDown[x_]:>{x,-1},Infinity]];
    groups=GatherBy[indices,First];
    invalid=Select[groups,
      Length[#]>2 || (Length[#]===2 &&
        Sort[#[[All,2]]] =!= {-1,1})&];
    <|"Valid"->(invalid==={}),
      "FreeIndices"->(First/@Select[groups,Length[#]===1&]),
      "DummyIndices"->(First/@Select[groups,Length[#]===2&]),
      "Invalid"->invalid|>,
    {term,terms}];
  <|"Valid"->AllTrue[perTerm,#["Valid"]&],
    "Terms"->perTerm|>
];

rayAbsKnownTensorQ[x_]:=MatchQ[x,RAYTensor[_String,_List]];

(* Contract a single factor pair, metric raising/lowering or delta
   substitution. Missing complementary factors leave an Einstein pair
   as a formal contraction. *)
rayAbsReduceFactors[factors_List,d_] := Catch[
 Module[{f=factors,n=Length[factors],i,j,k,h,idx,other,otherIdx,
   p,q,remain,name,newIndices,newFactor,free},
  Do[
    If[MatchQ[f[[i]],RAYTensor["Delta",_List]],
      idx=f[[i,2]];
      If[Length[idx]===2 &&
         rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[2]]] &&
         rayAbsVariance[idx[[1]]]===-rayAbsVariance[idx[[2]]],
        Throw[{True,ReplacePart[f,i->d]},"RAYReduction"]]];
    If[MatchQ[f[[i]],RAYTensor["Riemann",_List]],
      idx=f[[i,2]];
      If[Length[idx]===4 && Head[idx[[1]]]===RAYUp,
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[3]]],
          Throw[{True,ReplacePart[f,
            i->RAYTensor["Ricci",idx[[{2,4}]]]]},"RAYReduction"]];
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[4]]],
          Throw[{True,ReplacePart[f,
            i->(-RAYTensor["Ricci",idx[[{2,3}]]])]},"RAYReduction"]];
        If[rayAbsLabel[idx[[1]]]===rayAbsLabel[idx[[2]]],
          Throw[{True,ReplacePart[f,i->0]},"RAYReduction"]]
      ]
    ],
    {i,n}
  ];
  Do[
    If[!rayAbsKnownTensorQ[f[[i]]],Continue[]];
    name=f[[i,1]];idx=f[[i,2]];
    If[!MemberQ[{"Metric","Delta"},name] || Length[idx]=!=2,
      Continue[]];
    Do[
      If[i===j || !rayAbsKnownTensorQ[f[[j]]],Continue[]];
      other=f[[j]];otherIdx=other[[2]];
      Do[
        p=idx[[k]];
        Do[
          q=otherIdx[[h]];
          If[rayAbsLabel[p]=!=rayAbsLabel[q] ||
             rayAbsVariance[p]=!=-rayAbsVariance[q],Continue[]];
          remain=idx[[3-k]];
          If[name==="Metric" &&
             rayAbsVariance[idx[[1]]]=!=rayAbsVariance[idx[[2]]],
             Continue[]];
          If[name==="Metric" && other[[1]]==="Metric" &&
             Length[otherIdx]===2,
            free=otherIdx[[3-h]];
            newFactor=If[Head[remain]===RAYUp,
              RAYTensor["Delta",{remain,free}],
              RAYTensor["Delta",{free,remain}]],
            newIndices=ReplacePart[otherIdx,h->remain];
            newFactor=RAYTensor[other[[1]],newIndices]
          ];
          Throw[{True,Join[
            Delete[f,{{Max[i,j]},{Min[i,j]}}],{newFactor}]},
            "RAYReduction"],
          {h,Length[otherIdx]}],
        {k,2}],
      {j,n}],
    {i,n}
  ];
  {False,f}
 ],"RAYReduction"
];

Options[RAYContract]={"Dimension"->Automatic,"MaxIterations"->32};
RAYContract[expr_,OptionsPattern[]] := Module[
 {dim=OptionValue["Dimension"],expanded=Expand[expr],
  terms,outs,factors,changed,next,k},
 If[dim===Automatic,
   dim=If[rayMetricQ[],rayDim[],Missing["NoDimension"]]];
 terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
 outs=Table[
   factors=rayAbsFactors[term];
   Do[
     {changed,next}=rayAbsReduceFactors[factors,dim];
     If[!TrueQ[changed],Break[]];
     factors=rayAbsFactors[Expand[Times@@next]];
     ,{k,OptionValue["MaxIterations"]}];
   Times@@factors,{term,terms}];
 RAYCanonicalize[Total[outs]]
];

RAYCovDCommutator[RAYTensor[name_String,idx_List],a_,b_] :=
 Module[{result=0,dummy,replaced,cur},
  If[name==="Metric" || name==="Delta",Return[0]];
  Do[
    cur=idx[[i]];
    If[!rayAbsIndexQ[cur],Continue[]];
    dummy=Unique["rayCurvIndex$"];
    If[Head[cur]===RAYUp,
      replaced=ReplacePart[idx,i->RAYUp[dummy]];
      result+=RAYTensor["Riemann",
        {cur,RAYDown[dummy],RAYDown[a],RAYDown[b]}]*
        RAYTensor[name,replaced],
      replaced=ReplacePart[idx,i->RAYDown[dummy]];
      result-=RAYTensor["Riemann",
        {RAYUp[dummy],cur,RAYDown[a],RAYDown[b]}]*
        RAYTensor[name,replaced]
    ],{i,Length[idx]}];
  RAYCanonicalize[result]
];
RAYCovDCommutator[expr_Plus,a_,b_] :=
  Map[RAYCovDCommutator[#,a,b]&,expr];
RAYCovDCommutator[expr_Times,a_,b_] :=
  Total[Table[
    Times@@ReplacePart[List@@expr,
      k->RAYCovDCommutator[(List@@expr)[[k]],a,b]],
    {k,Length[List@@expr]}]];
RAYCovDCommutator[expr_?NumericQ,a_,b_]:=0;
RAYCovDCommutator[expr_,a_,b_]:=0;

(* First Bianchi in a 4-lowered-index Levi-Civita Riemann:
   R_abcd + R_acdb + R_adbc = 0. Rewrite the lexicographically
   largest symmetry-reduced basis tensor into the other two. *)
rayAbsBianchiRule[labels_List] := Module[
  {a,b,c,d,terms,pairs,signs,bases,ord,largest,other},
  If[Length[DeleteDuplicates[labels]]=!=4,Return[Nothing]];
  {a,b,c,d}=SortBy[labels,rayAbsSortKey];
  terms={
    RAYTensor["Riemann",RAYDown/@{a,b,c,d}],
    RAYTensor["Riemann",RAYDown/@{a,c,d,b}],
    RAYTensor["Riemann",RAYDown/@{a,d,b,c}]
  };
  pairs=rayAbsTensorNormalize/@terms;
  signs=If[Head[#]===Times,First[List@@#],1]& /@pairs;
  bases=If[Head[#]===Times,Last[List@@#],#]& /@pairs;
  If[!AllTrue[signs,MemberQ[{-1,1},#]&],Return[Nothing]];
  ord=Ordering[rayAbsSortKey/@bases];largest=Last[ord];other=Most[ord];
  bases[[largest]]->
    -Total[Map[(signs[[#]]/signs[[largest]])bases[[#]]&,other]]
];

RAYBianchiReduce[expr_] := Module[{current,sets,rules},
  current=RAYCanonicalize[expr];
  sets=DeleteDuplicates[
    SortBy[#,rayAbsSortKey]& /@
      Cases[current,RAYTensor["Riemann",
        {RAYDown[a_],RAYDown[b_],RAYDown[c_],RAYDown[d_]}] :>
        {a,b,c,d},Infinity]];
  rules=DeleteCases[rayAbsBianchiRule/@sets,Nothing];
  RAYCanonicalize[Expand[current/.rules]]
];

(* Convert a well-formed indexed tensor polynomial to an array of
   explicit components. Free index positions are supplied in order.
   RAYContract can be applied first. Uses active explicit metric. *)
RAYToComponents[expr_,free_List:{}] /; rayRequireMetric[]===True := Module[
  {d=rayDim[],names=rayAbsLabel/@free,out,tuples,comp},
  If[!AllTrue[free,rayAbsIndexQ] ||
     Length[DeleteDuplicates[names]]=!=Length[names],
    Return[rayFail["RAYToComponents: expected distinct RAYUp/RAYDown free indices."]]];
  If[free==={},Return[rayAbsEvaluate[expr,<||>,d]]];
  tuples=Tuples[Range[d],Length[free]];
  out=rayAbsEvaluate[expr,AssociationThread[names->#],d]&/@tuples;
  ArrayReshape[out,ConstantArray[d,Length[free]]]
];

rayAbsEvaluate[expr_,assign_Association,d_Integer] := Module[
  {expanded=Expand[expr],terms},
  terms=If[Head[expanded]===Plus,List@@expanded,{expanded}];
  Total[rayAbsEvaluateTerm[#,assign,d]&/@terms]
];

rayAbsEvaluateTerm[term_,assign_Association,d_Integer] := Module[
  {factors=rayAbsFactors[term],indices,groups,dummies,all,tuples},
  indices=Join[Cases[term,RAYUp[x_]:>{x,1},Infinity],
    Cases[term,RAYDown[x_]:>{x,-1},Infinity]];
  groups=GatherBy[indices,First];
  If[AnyTrue[groups,Length[#]>2 || (Length[#]===2 &&
        Sort[#[[All,2]]] =!= {-1,1})&],Return[$Failed]];
  dummies=First[First[#]]& /@Select[groups,Length[#]===2&];
  If[AnyTrue[Select[groups,Length[#]===1&],
      !KeyExistsQ[assign,First[First[#]]]&],Return[$Failed]];
  tuples=If[dummies==={},{{}},Tuples[Range[d],Length[dummies]]];
  Total[Table[
    all=Join[assign,AssociationThread[dummies->tp]];
    Times@@(rayAbsEvalFactor[#,all,d]&/@factors),
    {tp,tuples}]
  ]
];

rayAbsEvalFactor[RAYTensor[name_String,idx_List],all_Association,d_Integer] :=
  Module[{positions,config,tensor},
    positions=Lookup[all,rayAbsLabel/@idx,Missing["Index"]];
    If[MemberQ[positions,_Missing],Return[$Failed]];
    If[name==="Delta",
      Return[KroneckerDelta@@positions]];
    config=StringJoin[(If[Head[#]===RAYUp,"u","d"]&/@idx)];
    tensor=rayAbsGetTensor[name,config];
    If[tensor===$Failed,Return[$Failed]];
    Extract[tensor,positions]
  ];
rayAbsEvalFactor[x_,all_,d_]:=x;

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYUp[i], RAYDown[i]","Explicit abstract-index variance markers; repeated up/down indices are contracted."},
 {"RAYDeclareSymmetry[name,kind]","Register symmetric/antisymmetric tensor slots."},
 {"RAYCanonicalize[expr]","Canonicalize tensor slot symmetries and rename contracted dummy indices."},
 {"RAYContract[expr]","Simplify metric, Kronecker-delta and Ricci contractions."},
 {"RAYIndexCheck[expr]","Check repeated-index variance and multiplicity."},
 {"RAYBianchiReduce[expr]","Reduce all-lowered Riemann expressions by the first Bianchi identity."},
 {"RAYCovDCommutator[tensor,a,b]","Formal Levi-Civita curvature commutator on a tensor."},
 {"RAYToComponents[expr,freeIndices]","Evaluate an indexed tensor polynomial with the active explicit geometry."}
}];


(* User-defined tensor components associated with the active explicit metric.
   Unlike the built-in curvature tensors, these can represent arbitrary
   scalar/vector/form/tensor fields with a declared index placement. *)
$rayAbstractComponents=<||>;

RAYRegisterTensor[name_String,components_List,config_String] /;
    rayRequireMetric[]===True :=
 Module[{d=rayDim[],rank=ArrayDepth[components],cfg,key},
  cfg=rayParseConfig[config,rank];
  If[rank<1 || cfg===$Failed ||
     Dimensions[components]=!=ConstantArray[d,rank],
    Return[rayFail["RAYRegisterTensor: tensor shape and index configuration do not match the active metric."]]];
  If[MemberQ[{"Metric","Riemann","Ricci","Einstein","Weyl",
      "Shear","Vorticity"},name],
    Return[rayFail["RAYRegisterTensor: built-in geometry tensor names are reserved."]]];
  key=$rayActiveMetric<>"::"<>name;
  AssociateTo[$rayAbstractComponents,key->
    <|"Data"->components,"Configuration"->cfg|>];
  name
 ];
RAYUnregisterTensor[name_String] /; rayRequireMetric[]===True :=
  (KeyDropFrom[$rayAbstractComponents,$rayActiveMetric<>"::"<>name];name);

rayAbsGetTensor[name_String,config_String] := Module[
 {key=$rayActiveMetric<>"::"<>name,entry,cfg},
 If[!KeyExistsQ[$rayAbstractComponents,key],
   Return[rayTensorByName[name,config]]];
 entry=$rayAbstractComponents[key];
 cfg=rayParseConfig[config,Length[entry["Configuration"]]];
 If[cfg===$Failed,Return[$Failed]];
 rayChangeIndices[entry["Data"],entry["Configuration"],cfg]
];

(* Explicit component bridge for a covariant derivative: the derivative
   index is first and lower. RAYAbstractCovD[...,a] uses RAYDown[a]. *)
rayAbsEvalFactor[
  RAYNabla[RAYDown[mu_],RAYTensor[name_String,idx_List]],
  all_Association,d_Integer] :=
 Module[{positions,cfg,raw,der},
  positions=Lookup[all,Join[{mu},rayAbsLabel/@idx],Missing["Index"]];
  If[MemberQ[positions,_Missing],Return[$Failed]];
  cfg=StringJoin[If[Head[#]===RAYUp,"u","d"]&/@idx];
  raw=rayAbsGetTensor[name,cfg];
  If[raw===$Failed,Return[$Failed]];
  der=RAYCovD[raw,cfg];
  If[der===$Failed,Return[$Failed]];
  Extract[der,positions]
 ];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYRegisterTensor[name,array,config]","Register explicit arbitrary tensor components for RAYToComponents."},
 {"RAYUnregisterTensor[name]","Remove a registered arbitrary tensor from the active metric."},
 {"RAYToComponents[RAYAbstractCovD[...],free]","Evaluate an abstract covariant derivative as explicit RAYCovD components."}
}];


End[];

EndPackage[];

