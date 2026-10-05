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

Begin["`Private`"];

$RAYVersion = "1.0.0";
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

End[];

EndPackage[];
