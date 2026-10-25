(* RAY standalone v1.5.0 — exact constant-field derivatives in crossed warped products. *)

(* --- Embedded Kernel/RAYAutoBootstrap.wl --- *)
(* ::Package:: *)
(* Standalone source bootstrap, ahead of BeginPackage.
   New versions are installed with SHA256 comparison and a backup.
   Turn off with Global`$RAYAutoUpdateOnLoad=False before Needs. *)

If[!TrueQ[Global`$RAYAutoUpdateOnLoad===False]&&
   !TrueQ[Global`$RAYAutoUpdateReenter]&&
   StringQ[$InputFileName]&&FileExistsQ[$InputFileName]&&
   FileNameTake[$InputFileName]==="RAY.wl",
 Global`$RAYAutoUpdateLoadResult=Quiet@Check[TimeConstrained[
 Module[{target=$InputFileName,
   url="https://github.com/shaikot996/RAY/releases/latest/download/",
   candidate,checksumFile,stage,backup,installedText,currentVersions,
   newText,newVersions,expected,hash,entries,selected,status,tmpOk},
  candidate=CreateTemporary[];
  checksumFile=CreateTemporary[];
  status=Catch[
   tmpOk=Quiet@Check[TimeConstrained[
     URLDownload[url<>"RAY.wl",candidate],12,$Failed],$Failed];
   If[tmpOk===$Failed||!FileExistsQ[candidate]||
      FileByteCount[candidate]<20000,Throw["Offline"]];
   newText=Quiet@Check[Import[candidate,"Text"],$Failed];
   installedText=Quiet@Check[Import[target,"Text"],$Failed];
   If[!StringQ[newText]||!StringQ[installedText],
     Throw["Unchanged"]];
   currentVersions=StringCases[installedText,
     RegularExpression["\\$RAYVersion\\s*=\\s*\"([0-9]+\\.[0-9]+\\.[0-9]+)\""]->"$1"];
   newVersions=StringCases[newText,
     RegularExpression["\\$RAYVersion\\s*=\\s*\"([0-9]+\\.[0-9]+\\.[0-9]+)\""]->"$1"];
   If[Length[currentVersions]=!=1||Length[newVersions]=!=1,
     Throw["Unchanged"]];
   If[!TrueQ[OrderedQ[{
      ToExpression/@StringSplit[currentVersions[[1]],"."],
      ToExpression/@StringSplit[newVersions[[1]],"."]}]]||
      currentVersions[[1]]===newVersions[[1]],Throw["Unchanged"]];
   If[!StringContainsQ[newText,"BeginPackage[\"RAY`\"]"]||
      !StringContainsQ[newText,"EndPackage[]"]||
      !StringStartsQ[newText,"(* RAY standalone v"],
     Throw["Unchanged"]];
   tmpOk=Quiet@Check[TimeConstrained[
     URLDownload[url<>"SHA256SUMS.txt",checksumFile],12,$Failed],$Failed];
   If[tmpOk===$Failed||!FileExistsQ[checksumFile],
     Throw["Offline"]];
   entries=StringSplit[StringTrim[#]]&/@
       StringSplit[Import[checksumFile,"Text"],"\n"];
   selected=Select[entries,Length[#]>=2&&Last[#]==="RAY.wl"&];
   If[Length[selected]=!=1||
      !StringMatchQ[First[selected[[1]]],
        RegularExpression["[0-9a-fA-F]{64}"]],
     Throw["InvalidChecksum"]];
   expected=ToLowerCase[First[selected[[1]]]];
   hash=ToLowerCase[FileHash[candidate,"SHA256","HexString"]];
   If[expected=!=hash,Throw["InvalidChecksum"]];
   stage=target<>".new";backup=target<>".previous";
   If[FileExistsQ[stage],DeleteFile[stage]];
   If[Quiet@Check[CopyFile[candidate,stage];True,$Failed]=!=True,
     Throw["Unchanged"]];
   If[ToLowerCase[FileHash[stage,"SHA256","HexString"]]=!=expected,
     DeleteFile[stage];Throw["InvalidChecksum"]];
   If[FileExistsQ[backup],DeleteFile[backup]];
   If[Quiet@Check[CopyFile[target,backup];True,$Failed]=!=True,
     DeleteFile[stage];Throw["Unchanged"]];
   If[Quiet@Check[
     RenameFile[stage,target,OverwriteTarget->True];True,$Failed]=!=True,
     If[FileExistsQ[stage],DeleteFile[stage]];
     Throw["Unchanged"]];
   If[ToLowerCase[FileHash[target,"SHA256","HexString"]]=!=expected,
     CopyFile[backup,target,OverwriteTarget->True];
     Throw["InvalidChecksum"]];
   "Reload"
  ];
  If[FileExistsQ[candidate],DeleteFile[candidate]];
  If[FileExistsQ[checksumFile],DeleteFile[checksumFile]];
  status
 ],35,"Offline"],"Offline"];
 If[Global`$RAYAutoUpdateLoadResult==="Reload",
   Print["RAY updated to a newer verified release during Needs loading."];
   Block[{Global`$RAYAutoUpdateReenter=True},
      Get[$InputFileName]];
   Return[Null];
 ];
];

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

RAW::usage = "expr // RAW shows normal Mathematica notebook input syntax (StandardForm), including f'[t], and unwraps large RAY tensor displays into raw arrays. Use RAYRaw[...] to obtain algebra-ready arrays.";

RAYPretty::usage = "expr // RAYPretty shows handwritten math, dot time derivatives and conventional partial derivative fractions. The underlying algebra is unchanged.";

RAYReadable::usage = "RAYReadable[expr] prints formulas like handwritten mathematics, using dot time derivatives and partial derivative fractions. The algebra remains unchanged.";

RAYReadableTensor::usage = "RAYReadableTensor[matrix, name, config] displays nonzero coordinate-indexed components as labeled equations without a giant matrix.";

RAYGeneralWarpedMetric::usage = "RAYGeneralWarpedMetric[d,n,A[t],B[t],opts] derives exact Ricci/Einstein formulas with symbolic external dimension d and internal dimension n. Options: Time, Lapse, ExternalGeometry, InternalGeometry. No finite metric array is constructed.";

RAYWarpedBlocks::usage = "RAYWarpedBlocks[{{name,m,warp,geometry},...},opts] derives curvature for arbitrary symbolic dimensions of multiple time-dependent warped spatial blocks.";

RAYWarpedToComponents::usage = "RAYWarpedToComponents[model,name,{{coords,referenceMetric},...}] instantiates a symbolic warped model when block dimensions are concrete integers.";

RAYWarpedReport::usage = "RAYWarpedReport[model] displays general warped-product Ricci/Einstein formulas as a readable physics report.";

RAYIntrinsicScalar::usage = "RAYIntrinsicScalar[name] is an inert placeholder for the intrinsic scalar curvature of an unspecified spatial reference metric.";

RAYWarpedFieldEquations::usage = "RAYWarpedFieldEquations[model,source] derives Einstein equations with Lambda and homogeneous energy density/pressures for symbolic d+n blocks, retaining full tensor equations for non-Einstein reference geometries.";


RAYCovariantWarpedMetric::usage = "RAYCovariantWarpedMetric[name,coordinates,baseMetric,n,B,opts] computes the exact warped-product Ricci and Einstein tensors for an arbitrary coordinate-dependent base metric and a fiber of symbolic dimension n, including Hessian and gradient contributions.";
RAYCovariantWarpedReport::usage = "RAYCovariantWarpedReport[model] displays the fully coordinate-covariant warped curvature and derivatives.";
RAYPartialD::usage = "RAYPartialD[expression,index] is a formal coordinate partial derivative, distinct from the tensorial covariant derivative RAYNabla[index,expression].";
RAYAbstractWarpedCurvature::usage = "RAYAbstractWarpedCurvature[d,n,B] derives exact covariant base/fiber Ricci formulas with d,n symbolic, using a base covariant Hessian and Laplace-Beltrami operator.";
RAYWeylRescale::usage = "RAYWeylRescale[d,omega] derives exact Ricci tensor and scalar transformations under g' = Exp[2 omega] g in arbitrary symbolic dimension d.";
RAYCovariantHessian::usage = "RAYCovariantHessian[f,a,b] formally represents nabla_a nabla_b f with respect to the base metric.";
RAYCovariantBox::usage = "RAYCovariantBox[f] formally represents the base metric Laplace-Beltrami operator on f.";
RAYGradientNorm::usage = "RAYGradientNorm[f] formally represents (nabla f)^2 = g^ab partial_a f partial_b f.";


RAYGeneralBlockGeometry::usage = "RAYGeneralBlockGeometry[d,n,A,B] is an exact d+n general orthogonal-block curvature model; both reference metrics may depend on ALL coordinates.";
RAYGeneralBlockReport::usage = "RAYGeneralBlockReport[model] displays the full Ricci, scalar and Einstein tensor decomposition in C=partial_y H/2 and K=partial_x Q/2.";
RAYGeneralBlockToComponents::usage = "RAYGeneralBlockToComponents[model,name,x,y,hatg,tildeg] evaluates arbitrary cross-dependent block metrics and verifies all Ricci and Einstein components.";
RAYBlockTerm::usage = "RAYBlockTerm[name,indices] represents a named covariant derivative or contraction in the full orthogonal-block tensor identities.";
RAYBlockTrace::usage = "RAYBlockTrace[sector,expr] denotes contraction with H inverse or Q inverse.";

RAYDoubleWarpedGeometry::usage = "RAYDoubleWarpedGeometry[d,n,A,B] derives fully general d+n doubly twisted Ricci and Einstein tensor blocks for A(x,y),B(x,y), with arbitrary reference metrics.";
RAYDoubleWarpedReport::usage = "RAYDoubleWarpedReport[model] displays fully general abstract crossed warp curvature identities.";
RAYDoubleWarpedToComponents::usage = "RAYDoubleWarpedToComponents[model,name,externalCoordinates,internalCoordinates,externalMetric,internalMetric] builds and verifies concrete tensor components.";
RAYFrameInner::usage = "RAYFrameInner[frame,A,B] denotes reference-metric contraction of gradients of two scalar fields.";
RAYMixedPartial::usage = "RAYMixedPartial[mu,m,A] denotes the mixed second coordinate derivative of a warp scalar.";

RAYCrossWarpedGeometry::usage = "RAYCrossWarpedGeometry[d,n,A,B,opts] returns Appendix-C-style external/internal/mixed Ricci and Einstein tensors for crossed double warp Exp[2A(y)] hatg(x) + Exp[2B(x)] tildeg(y), with symbolic d,n and DerivativeForm Covariant or Partial.";
RAYCrossToCovariant::usage = "RAYCrossToCovariant[expr] converts the exact partial-plus-connection symbolic representation back to covariant operators.";
RAYCrossWarpedReport::usage = "RAYCrossWarpedReport[model] shows paper-style symbolic Ricci tensor, Ricci scalar and Einstein tensor blocks.";
RAYFrameTensor::usage = "RAYFrameTensor[Hat|Tilde,type,indices] is an inert indexed reference metric or curvature tensor with geometric accent.";
RAYFrameScalar::usage = "RAYFrameScalar[Hat|Tilde,Ricci] is an inert intrinsic curvature scalar with frame accent.";
RAYFramePartial::usage = "RAYFramePartial[frame,index,phi] formally denotes a coordinate partial derivative.";
RAYFrameHessian::usage = "RAYFrameHessian[frame,index1,index2,phi] denotes the scalar covariant Hessian for the frame reference metric.";
RAYFramePartialHessian::usage = "RAYFramePartialHessian[frame,index1,index2,phi] is a formal second coordinate partial derivative.";
RAYFrameConnectionTerm::usage = "RAYFrameConnectionTerm[frame,index1,index2,phi] is Gamma^k_ij partial_k phi, the needed correction in the covariant Hessian.";
RAYFrameBox::usage = "RAYFrameBox[frame,phi] denotes the Laplace-Beltrami operator of the frame.";
RAYFramePartialBox::usage = "RAYFramePartialBox[frame,phi] displays the Laplace-Beltrami operator as a partial-plus-connection contraction.";
RAYFrameNorm::usage = "RAYFrameNorm[frame,phi] denotes g^ij partial_i phi partial_j phi on the frame.";
RAYUpdate::usage = "RAYUpdate[] installs the latest self-contained RAY.wl with SHA256 verification."; 
RAYUpdateStandalone::usage = "RAYUpdateStandalone[] is a compatibility alias for RAYUpdate[].";

Begin["`Private`"];

$RAYVersion = "1.5.0";
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


(* --- Embedded Kernel/RAYRawExtensions.wl --- *)
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


(* --- Embedded Kernel/RAYMatter.wl --- *)
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


(* --- Embedded Kernel/RAYNumerics.wl --- *)
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


(* --- Embedded Kernel/RAYSymbolic.wl --- *)
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
    "MetricTensor"->RAYTensor["Metric",{RAYDown["a"],RAYDown["b"]}],
    "InverseMetricTensor"->RAYTensor["Metric",{RAYUp["a"],RAYUp["b"]}],
    "RicciTensor"->RAYTensor["Ricci",{RAYDown["a"],RAYDown["b"]}],
    "RiemannTensor"->RAYTensor["Riemann",
      {RAYUp["a"],RAYDown["b"],RAYDown["c"],RAYDown["d"]}],
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


(* --- Embedded Kernel/RAYAbstractAlgebra.wl --- *)
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


(* --- Embedded Kernel/RAYFormatting.wl --- *)
(* ::Package:: *)
(* RAY notebook presentation, v1.1.1.
   These rules affect notebook BOXES only. All tensors remain untouched
   Wolfram expressions usable by RAYCanonicalize, RAYContract, etc.
   The InterpretationBox retains an exact, copyable interpretation.
   InputForm intentionally remains unaffected so RAW exposes the code. *)

rayPrettyTensorName[name_String] := Switch[name,
  "Metric", "g",
  "InverseMetric", "g",
  "Riemann", "R",
  "Ricci", "R",
  "RicciScalar", "R",
  "Einstein", "G",
  "Weyl", "C",
  "Delta", "\[Delta]",
  "Shear", "\[Sigma]",
  "Vorticity", "\[Omega]",
  "Christoffel", "\[CapitalGamma]",
  _, name
];

rayPrettyIndexBoxes[index_String,form_] := index;
rayPrettyIndexBoxes[index_,form_] := MakeBoxes[index,form];

rayPrettyScript[indices_List,form_] := Module[
 {uppers,lowers,upBoxes,downBoxes},
 uppers=Cases[indices,RAYUp[index_] :> index,{1}];
 lowers=Cases[indices,RAYDown[index_] :> index,{1}];
 upBoxes=rayPrettyIndexBoxes[#,form]& /@ uppers;
 downBoxes=rayPrettyIndexBoxes[#,form]& /@ lowers;
 {
   If[upBoxes==={},None,RowBox[upBoxes]],
   If[downBoxes==={},None,RowBox[downBoxes]]
 }
];


rayPrettyGeometryLabel[name_String] := Switch[name,
 "External","ext","Internal","int","Fiber","fib",_,name];

rayPrettyTensorBase[name_String] := Module[{geometry,type},
 geometry=Which[
  StringStartsQ[name,"External"],"External",
  StringStartsQ[name,"Internal"],"Internal",
  StringStartsQ[name,"Fiber"],"Fiber",
  True,None];
 If[geometry===None,
  Return[StyleBox[rayPrettyTensorName[name],FontSlant->"Italic"]]];
 type=StringDrop[name,StringLength[geometry]];
 If[!MemberQ[{"Metric","Ricci","Einstein","Riemann","Weyl"},type],
  Return[StyleBox[name,FontSlant->"Italic"]]];
 SuperscriptBox[
   OverscriptBox[
    StyleBox[Switch[type,"Metric","g","Einstein","G","Weyl","C",_,"R"],
      FontSlant->"Italic"],"~"],
   rayPrettyGeometryLabel[geometry]]
];

RAYIntrinsicScalar /: MakeBoxes[RAYIntrinsicScalar[name_String],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=SubscriptBox[OverscriptBox["R","~"],
     rayPrettyGeometryLabel[name]]},
  InterpretationBox[pretty,RAYIntrinsicScalar[name],Editable->False]];

RAYCovariantHessian /: MakeBoxes[
 RAYCovariantHessian[expression_,i_,j_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{
  SubscriptBox["\[Del]",rayPrettyIndexBoxes[
    If[MatchQ[i,_RAYDown|_RAYUp],First[i],i],form]],
  SubscriptBox["\[Del]",rayPrettyIndexBoxes[
    If[MatchQ[j,_RAYDown|_RAYUp],First[j],j],form]],
  "(",MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYCovariantHessian[expression,i,j],
    Editable->False]];

RAYCovariantBox /: MakeBoxes[RAYCovariantBox[expression_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{"\[EmptySquare]","(",
   MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYCovariantBox[expression],Editable->False]];

RAYGradientNorm /: MakeBoxes[RAYGradientNorm[expression_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=SuperscriptBox[
  RowBox[{"(", "\[Del]",MakeBoxes[expression,form],")"}],"2"]},
  InterpretationBox[pretty,RAYGradientNorm[expression],Editable->False]];

RAYPartialD /: MakeBoxes[RAYPartialD[expression_,index_],
 form:(StandardForm|TraditionalForm)] :=
 With[{pretty=RowBox[{
    SubscriptBox["\[PartialD]",rayPrettyIndexBoxes[index,form]],
    "(",MakeBoxes[expression,form],")"}]},
  InterpretationBox[pretty,RAYPartialD[expression,index],Editable->False]];

rayPrettyTensorBoxes[name_String,indices_List,form_] := Module[
 {base,up,down,output,valid},
 base=rayPrettyTensorBase[name];
 valid=AllTrue[indices,MatchQ[#,_RAYUp|_RAYDown]&];
 If[!valid,
   Return[RowBox[{"RAYTensor","[",
     RowBox[{MakeBoxes[name,form],",",MakeBoxes[indices,form]}],"]"}]]];
 {up,down}=rayPrettyScript[indices,form];
 output=Which[
   up===None && down===None,base,
   down===None,SuperscriptBox[base,up],
   up===None,SubscriptBox[base,down],
   True,SubsuperscriptBox[base,down,up]
 ];
 output
];

RAYTensor /: MakeBoxes[RAYTensor[name_String,indices_List],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=rayPrettyTensorBoxes[name,indices,form]},
   InterpretationBox[boxes,RAYTensor[name,indices],Editable->False]
 ];

RAYDummy /: MakeBoxes[RAYDummy[n_Integer],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=SubscriptBox["\[Lambda]",MakeBoxes[n,form]]},
   InterpretationBox[boxes,RAYDummy[n],Editable->False]
 ];

RAYUp /: MakeBoxes[RAYUp[index_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{"\[UpArrow]",MakeBoxes[index,form]}]},
   InterpretationBox[boxes,RAYUp[index],Editable->False]
 ];

RAYDown /: MakeBoxes[RAYDown[index_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{"\[DownArrow]",MakeBoxes[index,form]}]},
   InterpretationBox[boxes,RAYDown[index],Editable->False]
 ];

rayPrettyNablaBoxes[index_,expression_,form_] := Module[
 {label,indexBox,derivative,exprBox},
 label=If[MatchQ[index,RAYUp[_]|RAYDown[_]],First[index],index];
 indexBox=rayPrettyIndexBoxes[label,form];
 derivative=Which[
   MatchQ[index,_RAYDown],SubscriptBox["\[Del]",indexBox],
   MatchQ[index,_RAYUp],SuperscriptBox["\[Del]",indexBox],
   True,SubscriptBox["\[Del]",indexBox]
 ];
 exprBox=With[{heldExpr=expression},MakeBoxes[heldExpr,form]];
 RowBox[{derivative,"(",exprBox,")"}]
];
RAYNabla /: MakeBoxes[RAYNabla[index_,expression_],
   form:(StandardForm|TraditionalForm)] :=
 With[{boxes=rayPrettyNablaBoxes[index,expression,form]},
   InterpretationBox[boxes,RAYNabla[index,expression],Editable->False]
 ];

(* Pretty is optional: abstract tensor results already typeset themselves.
   Unlike InputForm, TraditionalForm intentionally provides human notation. *)
RAYPretty[expression_] := TraditionalForm[expression];

(* Any nested TraditionalForm / MatrixForm / TableForm supplied by RAY
   is removed before displaying the exact underlying Wolfram input. *)
rayRemoveDisplayWrappers[expression_] := FixedPoint[
  ReplaceAll[#,{
    HoldPattern[TraditionalForm[x_]] :> x,
    HoldPattern[MatrixForm[x_,___]] :> x,
    HoldPattern[TableForm[x_,___]] :> x,
    HoldPattern[StandardForm[x_]] :> x,
    HoldPattern[InputForm[x_]] :> x
  }]&,
  expression,
  12
];

(* Postfix: a formatted expression // RAW.
   The result is an InputForm DISPLAY for copy/paste. For programmatic
   algebra use the original expression or RAYRaw[...]. *)
RAW[expression_] := InputForm[rayRemoveDisplayWrappers[expression]];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAW[expr] (or expr // RAW)","Display the exact underlying Wolfram Language expression in input notation; strips common presentation wrappers."},
 {"RAYPretty[expr] (or expr // RAYPretty)","Display notebook-friendly traditional mathematical notation."},
 {"RAYTensor[name,indices]","Automatically typeset A^a, g_ab, R^a_bcd, etc. in StandardForm and TraditionalForm."},
 {"RAYNabla[index,expr]","Automatically typeset a covariant derivative with upper/lower derivative index."}
}];


(* --- Embedded Kernel/RAYHandwritten.wl --- *)
(* ::Package:: *)
(* Human-readable curvature/field-equation presentation.
   Presentation wrappers preserve the exact Mathematica expression.
   No curvature values, geometry data or tensor algorithms are modified. *)

Options[RAYReadable] = {"FactorTimeWarp" -> True, "DerivativeNotation" -> "Partial"};

rayHandTimeQ[x_] := MatchQ[x,_Symbol] &&
  MemberQ[{"t","time","tau","\[Tau]"},SymbolName[Unevaluated[x]]];

rayHandDerivative[f_, orders_List, args_List,notation_:"Partial"] := Module[
  {nn=Total[orders], vars, pairs, bare=f},
  If[Length[orders]=!=Length[args] || nn===0,
    Return[(Derivative@@orders)[f]@@args]];
  If[notation==="Dot" && Length[args]===1 && rayHandTimeQ[First[args]] &&
     1<=nn<=3,
    Return[(Nest[OverDot,bare,nn])@@args]];
  pairs=MapThread[If[#2===1,#1,{#1,#2}]&,{args,orders}];
  pairs=MapThread[If[#2===0,Nothing,
    If[#2===1,#1,{#1,#2}]]&,{args,orders}];
  Inactive[D][f@@args,Sequence@@pairs]
];

(* Replace ordinary Derivative[n1,n2,...][f][args] only for display.
   Inactive[D] renders conventional partial derivative fractions. *)
rayHandExpression[expr_,notation_:"Partial"] := expr /. HoldPattern[
  Derivative[orders__Integer][f_][args__]] :>
   rayHandDerivative[f,{orders},{args},notation];

rayReadableWarpFactors[expr_] :=
 DeleteDuplicates@Cases[Unevaluated[expr],
   e:Power[E,ex_] /;
     !FreeQ[ex,_Symbol?(rayHandTimeQ)] :> e,
   Infinity];

rayReadableSimplify[expr_,factorWarp_:True] := Module[
 {res=expr,exps},
 If[!TrueQ[factorWarp] || LeafCount[Unevaluated[expr]]>1200,
   Return[expr]];
 exps=rayReadableWarpFactors[expr];
 If[exps==={},Return[expr]];
 res=Quiet@Check[
   Collect[Expand[expr],exps,Simplify],expr];
 If[LeafCount[res] > 2 LeafCount[expr],expr,res]
];

(* The Mathematica-generated StandardForm boxes remain the RAW mode.
   Readable mode uses TraditionalForm with dot notation for time derivatives
   and explicit partials for multivariable functions. *)
RAYReadable[expression_,OptionsPattern[]] :=
  RAYHandwritten[rayReadableSimplify[expression,
   OptionValue["FactorTimeWarp"]],OptionValue["DerivativeNotation"]];

RAYHandwritten /: MakeBoxes[RAYHandwritten[expr_,notation_],
   fmt:(StandardForm|TraditionalForm)] :=
 Module[{pretty,box},
   pretty=rayHandExpression[expr,notation];
   box=With[{displayExpr=pretty},MakeBoxes[displayExpr,TraditionalForm]];
   With[{rendered=box},InterpretationBox[rendered,expr,Editable->False]]
 ];

RAYHandwritten /: MakeBoxes[RAYHandwritten[expr_],
   fmt:(StandardForm|TraditionalForm)] :=
 Module[{pretty,box},
   pretty=rayHandExpression[expr];
   box=With[{displayExpr=pretty},MakeBoxes[displayExpr,TraditionalForm]];
   With[{rendered=box},InterpretationBox[rendered,expr,Editable->False]]
 ];

rayReadableComponentLabel[name_String,config_String,indices_List] :=
 Module[{coords,up,down,symbol,bxUp,bxDown},
  coords=rayCoords[];
  symbol=Switch[name,"Ricci","R","Einstein","G",
    "Metric","g","StressTensor","T",_,name];
  up=Pick[coords[[indices]],Characters[config],"u"];
  down=Pick[coords[[indices]],Characters[config],"d"];
  bxUp=If[up==={},None,RowBox[MakeBoxes[#,TraditionalForm]&/@up]];
  bxDown=If[down==={},None,RowBox[MakeBoxes[#,TraditionalForm]&/@down]];
  Which[
   bxDown===None && bxUp===None,symbol,
   bxDown===None,SuperscriptBox[symbol,bxUp],
   bxUp===None,SubscriptBox[symbol,bxDown],
   True,SubsuperscriptBox[symbol,bxDown,bxUp]
  ]
 ];

rayReadableComponentRows[data_List,config_String,name_String,
 maxRows_Integer:36] := Module[
 {d=Length[data],rows={},v},
 Do[
   v=data[[i,j]];
   If[!TrueQ[v===0] && !TrueQ[PossibleZeroQ[v]],
     AppendTo[rows,{rayReadableComponentLabel[name,config,{i,j}],v}]],
   {i,d},{j,d}];
 rows
];

RAYComponentDisplay /: MakeBoxes[
  RAYComponentDisplay[data_List,name_String,config_String],
  fmt:(StandardForm|TraditionalForm)] :=
 Module[{rows,formatted,boxes,header,max=36},
  rows=rayReadableComponentRows[data,config,name,max];
  formatted=Table[
   With[{lab=rows[[k,1]],
       val=rayReadableSimplify[rows[[k,2]]]},
     {
      lab,
      "=",
      MakeBoxes[RAYHandwritten[val],StandardForm]
     }],
   {k,Length[rows]}];
  boxes=If[rows==={},
   MakeBoxes[Style["All components vanish.",Italic,12],StandardForm],
   GridBox[formatted,
     ColumnAlignments->{"Right","Center","Left"},
     RowSpacings->1.4,ColumnSpacings->1.3]
  ];
  With[{rendered=boxes},InterpretationBox[rendered,data,Editable->False]]
 ];

RAYReadableTensor[array_List,name_String:"Tensor",
 config_String:"dd"] :=
 RAYComponentDisplay[array,name,config];

(* Also improve the explicit pretty-print command: it remains a display
   wrapper, but multivariable derivatives now use partial fractions. *)
RAYPretty[expression_] := RAYReadable[expression];

(* The default tensor display shows readable nonzero components.
   Use RAYRaw for actual arrays; MatrixForm[RAYRaw[...]] for full matrices.
   RAW of this display unwraps the entire original array. *)
RAYRicci[config_String] /; rayRequireMetric[]===True :=
 Module[{data=rayTensorByName["Ricci",config]},
   If[data===$Failed,Return[$Failed]];
   RAYComponentDisplay[data,"Ricci",config]
 ];

RAYEinstein[config_String] /; rayRequireMetric[]===True :=
 Module[{data=rayTensorByName["Einstein",config]},
   If[data===$Failed,Return[$Failed]];
   RAYComponentDisplay[data,"Einstein",config]
 ];

RAYRicciScalar[] /; rayRequireMetric[]===True :=
 RAYReadable[rayRicciScalar[]];


(* Consistent readable boxes for every legacy MatrixForm result and all
   sparse curvature/kinematic grids, not just Ricci and Einstein. *)
rayDisplayMatrix[array_] := RAYHandwritten[MatrixForm[array]];
rayDisplayVector[array_] := RAYHandwritten[array];

rayNonzeroGrid[array_,cfg_List,symbol_,title_String] := Module[
 {d=rayDim[],rank=Length[cfg],tuples,rows},
 tuples=Tuples[Range[0,d-1],rank];
 rows=Reap[Do[
   With[{v=raySimp[rayComponent[array,inds]]},
     If[!TrueQ[v===0] && !TrueQ[PossibleZeroQ[v]],
       Sow[{rayIndexLabel[symbol,inds,cfg],RAYReadable[v]}]]],
   {inds,tuples}]][[2]];
 rows=If[rows==={}, {},First[rows]];
 Column[{
   Style[title,Bold,15],
   If[rows==={},
     Style["All components vanish.",Italic,13],
     Grid[Prepend[rows,
       {Style["Component",Bold],Style["Value",Bold]}],
       Frame->All,Alignment->{{Center,Left}},
       Spacings->{2,1},ItemSize->{{Automatic,UpTo[80]},Automatic}]
   ]
 },Spacings->0.8]
];

(* Component calls remain compact mathematical expressions; full matrices
   remain accessible as MatrixForm[RAYRaw["Ricci","dd"]]. *)
RAYRicci[config_String,mu_Integer,nu_Integer] /;
 rayRequireMetric[]===True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu],Return[$Failed]];
  data=rayTensorByName["Ricci",config];
  If[data===$Failed,Return[$Failed]];
  RAYReadable[data[[mu+1,nu+1]]]
];

RAYEinstein[config_String,mu_Integer,nu_Integer] /;
 rayRequireMetric[]===True := Module[{data},
  If[!rayValidIndexQ[mu] || !rayValidIndexQ[nu],Return[$Failed]];
  data=rayTensorByName["Einstein",config];
  If[data===$Failed,Return[$Failed]];
  RAYReadable[data[[mu+1,nu+1]]]
];

(* Explicit opt-in to legacy full-matrix layout in handwritten notation. *)
RAYRicci[config_String,"Matrix"] /;
 rayRequireMetric[]===True :=
  RAYHandwritten[MatrixForm[rayTensorByName["Ricci",config]]];
RAYEinstein[config_String,"Matrix"] /;
 rayRequireMetric[]===True :=
  RAYHandwritten[MatrixForm[rayTensorByName["Einstein",config]]];


(* Uniform handwritten presentation of scalar invariants. *)
RAYKretschmann[] /; rayRequireMetric[]===True :=
 RAYReadable[rayKretschmann[]];
RAYRicciSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayRicciSquared[]];
RAYWeylSquared[] /; rayRequireMetric[]===True :=
 RAYReadable[rayWeylSquared[]];

(* Make RAYComponentDisplay and RAYHandwritten unwrap to their
   algebraic payload. RAW uses Mathematica StandardForm boxes rather
   than InputForm because StandardForm renders f'[t] instead of
   Derivative[1][f][t], and is the notebook's normal input syntax. *)
rayRemoveDisplayWrappers[expression_] := FixedPoint[
  ReplaceAll[#,{
    HoldPattern[RAYComponentDisplay[array_,___]] :> array,
    HoldPattern[RAYHandwritten[x_,___]] :> x,
    HoldPattern[TraditionalForm[x_]] :> x,
    HoldPattern[MatrixForm[x_,___]] :> x,
    HoldPattern[TableForm[x_,___]] :> x,
    HoldPattern[StandardForm[x_]] :> x,
    HoldPattern[InputForm[x_]] :> x
  }]&,
  expression,
  12
];

(* StandardForm itself would reapply the pretty RAYTensor MakeBoxes rules.
   Temporarily localize those definitions to show ACTUAL Mathematica input
   while still using primes for derivatives and square brackets for calls. *)
RAYNotebookInput /: MakeBoxes[
  RAYNotebookInput[expr_],
  fmt:(StandardForm|TraditionalForm)] :=
 Module[{boxes},
  boxes=Block[{RAYTensor,RAYUp,RAYDown,RAYNabla,RAYDummy},
    With[{source=expr},MakeBoxes[source,StandardForm]]];
  With[{rendered=boxes},
    InterpretationBox[rendered,expr,Editable->False]]
 ];

RAW[expression_] :=
  RAYNotebookInput[rayRemoveDisplayWrappers[expression]];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYReadable[expr]","Readable partial derivative fractions by default; choose \"DerivativeNotation\"->\"Dot\" for time derivatives."},
 {"RAYReadableTensor[matrix,name,config]","List nonzero coordinate-indexed tensor components as equations."},
 {"RAYRicci[dd]","Readable nonzero Ricci components, preserving full underlying tensor data."},
 {"RAW[expr] (or expr // RAW)","Mathematica notebook input syntax: primes, square brackets, complete raw expressions and unformatted RAYTensor code."}
}];


(* --- Embedded Kernel/RAYSymbolicWarped.wl --- *)
(* ::Package:: *)
(* RAY: dimension-independent warped-product curvature algebra.
   Metric: ds^2 = -L(t)^2 dt^2 + Sum_i Exp[2 a_i(t)] h^(i).
   Each h^(i) is time-independent, nondegenerate and block diagonal.
   Dimensions m_i are symbolic; no tensor arrays of size m_i are built.
   Curvature convention agrees with Kernel/RAY.wl.
   All formulas are exact for Levi-Civita warped products. *)

Options[RAYWarpedBlocks]={"Time"->Automatic,"Lapse"->1,
 "Assumptions"->True,"Simplification"->"Simplify",
 "Parameters"->{}};

rayWarpSpecQ[spec_] := MatchQ[spec,{_String,_,_,_}];

rayWarpGeometry[geometry_,dim_,name_] := Module[
 {g=RAYTensor[name<>"Metric",{RAYDown["i"],RAYDown["j"]}],
  r=RAYTensor[name<>"Ricci",{RAYDown["i"],RAYDown["j"]}],
  scalar=RAYIntrinsicScalar[name],curv},
 Switch[geometry,
  "Flat", {0,0,g},
  "General", {scalar,r,g},
  {"General",_}, {geometry[[2]],r,g},
  {"ConstantCurvature",_},
    curv=geometry[[2]];
    {dim (dim-1) curv,(dim-1)curv g,g},
  {"Einstein",_},
    curv=geometry[[2]];
    {dim curv,curv g,g},
  _, $Failed
 ]
];

rayWarpTime[specs_,lapse_,time_] := Module[{candidates},
 If[time=!=Automatic && Head[time]===Symbol,Return[time]];
 If[time=!=Automatic,Return[$Failed]];
 candidates=Cases[{specs[[All,3]],lapse},
     HoldPattern[f_Symbol[z_Symbol]] /; f=!=Exp :> z,Infinity];
 candidates=DeleteDuplicates[candidates];
 If[Length[candidates]===1,First[candidates],$Failed]
];


(* The symbolic Hubble-block formulas assume that each warp is a function
   of the common time alone. Reject multivariable coordinate-dependent
   functions instead of silently dropping their spatial gradients.
   Bare symbols are parameters unless users supply separate coordinates. *)
rayWarpTimeOnlyQ[warp_,time_Symbol,parameters_List:{}] :=
 Module[{symbols},
  symbols=DeleteDuplicates@Cases[HoldComplete[warp],
    s_Symbol /; Context[s]=!="System`" :> s,Infinity];
  Complement[symbols,Join[{time},parameters]]==={}
 ];


RAYWarpedBlocks[specs_List,OptionsPattern[]] := Module[
 {time,lapse=OptionValue["Lapse"],ass=OptionValue["Assumptions"],
  mode=OptionValue["Simplification"],parameters=OptionValue["Parameters"],simple,geom,dimensions,warps,
  H,Hdot,sumH,sumH2,curvTerm,timeRic,scalar,einTime,blocks,
  spatialRic,EinCoeffs,coords,vol},
 If[specs==={}||!AllTrue[specs,rayWarpSpecQ],
   Return[rayFail["RAYWarpedBlocks: use {{name,dimension,warp,geometry},...}."]]];
 If[Length[DeleteDuplicates[specs[[All,1]]]]=!=Length[specs],
   Return[rayFail["RAYWarpedBlocks: block names must be unique."]]];
 dimensions=specs[[All,2]];warps=specs[[All,3]];
 If[AnyTrue[dimensions,(NumericQ[#]&&(!IntegerQ[#]||#<1))&],
   Return[rayFail["RAYWarpedBlocks: each block dimension must be a positive integer or symbolic."]]];
 If[TrueQ[PossibleZeroQ[lapse]],
   Return[rayFail["RAYWarpedBlocks: the lapse cannot vanish."]]];
 time=rayWarpTime[specs,lapse,OptionValue["Time"]];
 If[time===$Failed,
   Return[rayFail["RAYWarpedBlocks: specify \"Time\"->t or use a single time variable in all warps."]]];
 If[!ListQ[parameters] || !AllTrue[parameters,MatchQ[#,_Symbol]&],
  Return[rayFail["RAYWarpedBlocks: \"Parameters\" must be a list of constant parameter symbols."]]];
 If[!AllTrue[warps,rayWarpTimeOnlyQ[#,time,parameters]&] ||
   !rayWarpTimeOnlyQ[lapse,time,parameters],
  Return[rayFail[
   "RAYWarpedBlocks: warp factors and lapse must depend on time only. For spatial coordinate dependence, use RAYCovariantWarpedMetric; for constant symbolic coefficients explicitly supply \"Parameters\"->{c1,c2}."
  ]]];
 geom=Map[rayWarpGeometry[#[[4]],#[[2]],#[[1]]]&,specs];
 If[MemberQ[geom,$Failed],
   Return[rayFail["RAYWarpedBlocks: geometry must be Flat, General, {General,R}, {Einstein,lambda}, or {ConstantCurvature,K}."]]];
 simple=Switch[mode,
   "None",Function[x,x],
   "Full",Function[x,FullSimplify[x,ass]],
   _,Function[x,Simplify[x,ass]]];
 H=simple/@(D[#,time]/lapse&/@warps);
 Hdot=simple/@(D[#,time]/lapse&/@H);
 sumH=simple[Total[dimensions H]];
 sumH2=simple[Total[dimensions H^2]];
 curvTerm=simple[Total[MapThread[Exp[-2 #1] #2[[1]]&,{warps,geom}]]];
 timeRic=simple[-lapse^2 Total[dimensions (Hdot+H^2)]];
 scalar=simple[curvTerm+2 Total[dimensions Hdot]+sumH^2+sumH2];
 einTime=simple[timeRic+(lapse^2/2)scalar];
 blocks=Table[
  With[{name=specs[[q,1]],mi=dimensions[[q]],a=warps[[q]],
    geometry=specs[[q,4]],intr=geom[[q,2]],g=geom[[q,3]],
    sc=geom[[q,1]],hi=H[[q]],dh=Hdot[[q]],
    c=simple[Hdot[[q]]+H[[q]]sumH]},
   <|"Name"->name,"Dimension"->mi,"Warp"->a,"Geometry"->geometry,
    "IntrinsicRicciScalar"->sc,"IntrinsicRicciTensor"->intr,
    "ReferenceMetric"->g,"Hubble"->hi,
    "HubbleDerivative"->dh,
    "RicciCoefficient"->c,
    "RicciTensor"->simple[intr+Exp[2a] c g],
    "EinsteinCoefficient"->simple[c-scalar/2],
    "EinsteinTensor"->simple[intr+Exp[2a](c-scalar/2)g]
   |>
  ],{q,Length[specs]}];
 vol=simple[lapse Exp[Total[dimensions warps]]];
 <|"Type"->"SymbolicWarpedBlocks",
   "Time"->time,"Lapse"->lapse,"Blocks"->blocks,
   "BlockCount"->Length[specs],
   "Dimensions"->dimensions,
   "SpatialDimension"->Total[dimensions],
   "TotalDimension"->1+Total[dimensions],
   "TotalHubble"->sumH,
   "SumWeightedHubbleSquares"->sumH2,
   "IntrinsicCurvatureContribution"->curvTerm,
   "RicciTimeTime"->timeRic,
   "RicciScalar"->scalar,
   "EinsteinTimeTime"->einTime,
   "VolumeFactor"->vol,
   "MetricSignature"->"One timelike direction; spatial block signatures follow their reference metrics",
   "Assumptions"->ass|>
];

Options[RAYGeneralWarpedMetric]=Join[
  Options[RAYWarpedBlocks],{"ExternalGeometry"->"Flat",
   "InternalGeometry"->"General"}];

RAYGeneralWarpedMetric[d_,n_,extWarp_,intWarp_,OptionsPattern[]] :=
 Module[{specs,options},
 If[NumericQ[d]&&(!IntegerQ[d]||d<2),
  Return[rayFail["RAYGeneralWarpedMetric: external spacetime dimension d must be at least 2."]]];
 If[NumericQ[n]&&(!IntegerQ[n]||n<1),
  Return[rayFail["RAYGeneralWarpedMetric: internal dimension n must be at least 1."]]];
 specs={
  {"External",d-1,extWarp,OptionValue["ExternalGeometry"]},
  {"Internal",n,intWarp,OptionValue["InternalGeometry"]}};
 RAYWarpedBlocks[specs,
  "Time"->OptionValue["Time"],"Lapse"->OptionValue["Lapse"],
  "Assumptions"->OptionValue["Assumptions"],
  "Simplification"->OptionValue["Simplification"],
  "Parameters"->OptionValue["Parameters"]]
];

(* Instantiate a symbolic model at fixed INTEGER block dimensions by
   supplying {coordinates, referenceMetric} for each spatial block.
   The model is not an arbitrary-sized matrix until these are supplied.
   The intrinsic curvature classification is a mathematical declaration,
   not an automatic validation of the supplied reference metrics. *)
Options[RAYWarpedToComponents]=Options[RAYDefineMetric];
RAYWarpedToComponents[model_Association,name_String,
  metricBlocks_List,opts:OptionsPattern[]] :=
 Module[{blocks=Lookup[model,"Blocks",{}],time,lapse,part,warpSpec,
  dim,good},
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
  Return[rayFail["RAYWarpedToComponents: a symbolic warped-block descriptor is required."]]];
 If[Length[blocks]=!=Length[metricBlocks],
  Return[rayFail["RAYWarpedToComponents: provide one coordinate/metric pair per spatial block."]]];
 good=And@@Table[
   MatchQ[metricBlocks[[k]],{_List,_List}] &&
   IntegerQ[blocks[[k,"Dimension"]]] &&
   blocks[[k,"Dimension"]]>=1 &&
   Length[metricBlocks[[k,1]]]==blocks[[k,"Dimension"]] &&
   Dimensions[metricBlocks[[k,2]]]==
     {blocks[[k,"Dimension"]],blocks[[k,"Dimension"]]},
   {k,Length[blocks]}];
 If[!good,Return[rayFail["RAYWarpedToComponents: block dimensions must be concrete positive integers matching their matrices."]]];
 time=model["Time"];lapse=model["Lapse"];
 warpSpec=Join[{{{time},{{-lapse^2}},1}},
   Table[{metricBlocks[[k,1]],metricBlocks[[k,2]],
    Exp[2 blocks[[k,"Warp"]]]},{k,Length[blocks]}]];
 RAYWarpedMetric[name,warpSpec,
  Assumptions->OptionValue[Assumptions],
  "Simplification"->OptionValue["Simplification"]]
];

(* Convenience: readable summary; formulas remain exact algebraic expressions. *)
RAYWarpedReport[model_Association] :=
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
  rayFail["RAYWarpedReport: expected a RAYWarpedBlocks result."],
  Column[{
   Style["Symbolic warped geometry",Bold,16],
   Grid[{
    {"Total dimension",model["TotalDimension"]},
    {"Time coordinate",model["Time"]},
    {"Lapse",model["Lapse"]},
    {"Ricci time-time",RAYReadable[model["RicciTimeTime"]]},
    {"Ricci scalar",RAYReadable[model["RicciScalar"]]},
    {"Einstein time-time",RAYReadable[model["EinsteinTimeTime"]]},
    {"Volume factor",RAYReadable[model["VolumeFactor"]]}
   },Frame->All,Alignment->Left],
   Style["Spatial blocks",Bold,13],
   Grid[Prepend[
    Table[{bl["Name"],bl["Dimension"],
      RAYReadable[bl["RicciTensor"]],
      RAYReadable[bl["EinsteinTensor"]]},{bl,model["Blocks"]}],
     {"Name","Dimension","Ricci tensor","Einstein tensor"}],
    Frame->All,Alignment->Left]
  },Spacings->1]
 ];


(* Einstein equations for comoving homogeneous diagonal matter.
   T_tt = lapse^2 rho,  T^(i)_ab = p_i Exp[2 a_i] h^(i)_ab.
   General intrinsic reference geometry is not automatically Einstein;
   preserve its full tensor equation as well as the scalar trace. *)
Options[RAYWarpedFieldEquations]={
 "Coupling"->1,"CosmologicalConstant"->0,
 "Simplification"->"Simplify"};
RAYWarpedFieldEquations[model_Association,source_:Automatic,OptionsPattern[]] :=
 Module[{blocks=Lookup[model,"Blocks",{}],rho=0,pressures,
  coupling=OptionValue["Coupling"],lambda=OptionValue["CosmologicalConstant"],
  timeRes,spatial,vars,curv,coeff,scalarPart,res,tensorRes,
  nsp,mode=OptionValue["Simplification"],simp},
 If[Lookup[model,"Type",None]=!="SymbolicWarpedBlocks",
   Return[rayFail["RAYWarpedFieldEquations: expected a symbolic warped-block model."]]];
 nsp=Length[blocks];
 If[source===Automatic,
   pressures=ConstantArray[0,nsp],
   If[!AssociationQ[source],
     Return[rayFail["RAYWarpedFieldEquations: source must be an Association or Automatic."]]];
   rho=Lookup[source,"EnergyDensity",0];
   pressures=Lookup[source,"Pressures",ConstantArray[0,nsp]];
   If[AssociationQ[pressures],
     If[!AllTrue[blocks,KeyExistsQ[pressures,#["Name"]]&],
       Return[rayFail["RAYWarpedFieldEquations: missing a pressure for one or more named blocks."]]];
     pressures=Lookup[pressures,blocks[[All,"Name"]]]];
   If[!ListQ[pressures]||Length[pressures]=!=nsp,
     Return[rayFail["RAYWarpedFieldEquations: one pressure per block is required."]]]
 ];
 simp=Switch[mode,
   "None",Function[q,q],
   "Full",Function[q,FullSimplify[q,model["Assumptions"]]],
   _,Function[q,Simplify[q,model["Assumptions"]]]];
 timeRes=simp[model["EinsteinTimeTime"]-
    model["Lapse"]^2(lambda+coupling rho)];
 spatial=Table[
   vars=blocks[[k]];curv=vars["Geometry"];
   coeff=Switch[curv,
      "Flat",0,
      {"ConstantCurvature",_},(vars["Dimension"]-1)curv[[2]],
      {"Einstein",_},curv[[2]],
      _,Missing["NonEinstein"]];
   scalarPart=simp[vars["EinsteinCoefficient"]+
      Exp[-2vars["Warp"]]vars["IntrinsicRicciScalar"]/vars["Dimension"]+
      lambda-coupling pressures[[k]]];
   tensorRes=simp[vars["EinsteinTensor"]+
      Exp[2 vars["Warp"]](lambda-coupling pressures[[k]])vars["ReferenceMetric"]];
   res=If[MissingQ[coeff],tensorRes,
     simp[Exp[-2vars["Warp"]]coeff+
       vars["EinsteinCoefficient"]+lambda-coupling pressures[[k]]]];
   <|"Name"->vars["Name"],
     "EquationType"->If[MissingQ[coeff],"FullTensor","Scalar"],
     "Equation"->(res==0),
     "Residual"->res,
     "TraceResidual"->scalarPart,
     "TensorResidual"->tensorRes|>,
   {k,nsp}];
 <|"Type"->"WarpedEinsteinEquations",
   "TimeTime"->(timeRes==0),"TimeTimeResidual"->timeRes,
   "Spatial"->spatial,"Coupling"->coupling,
   "CosmologicalConstant"->lambda,
   "EnergyDensity"->rho,"Pressures"->pressures|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYGeneralWarpedMetric[d,n,A[t],B[t]]","Exact Ricci and Einstein formulas with symbolic d,n; time lapse and spatial curvature configurable."},
 {"RAYWarpedBlocks[{{name,m,a[t],geometry},...}]","Dimension-independent warped product with any number of time-dependent spatial factors."},
 {"RAYWarpedToComponents[model,name,blocks]","Specialize integer block dimensions into the existing explicit metric engine."},
 {"RAYWarpedReport[model]","Readable symbolic Ricci/Einstein formulas and block descriptions."},
 {"RAYWarpedFieldEquations[model,source]","Einstein equations with Lambda and comoving rho, p_i; retains full tensor equations for non-Einstein blocks."},
 {"RAYIntrinsicScalar[name]","Placeholder for an unspecified intrinsic scalar curvature of a spatial reference metric."}
}];


(* --- Embedded Kernel/RAYCovariantWarped.wl --- *)
(* ::Package:: *)
(* RAY warped product with an arbitrary coordinate-dependent base metric:
   G_AB = g_ab(x),  G_ij = Exp[2 B(x)] h_ij(y).
   Base d is explicitly coordinated (integer); fiber n can remain symbolic.
   Independent geometric derivation from Levi-Civita formulas, RAY convention.
   The external metric g_ab may itself contain A[t,x], off-diagonal terms,
   and a nontrivial lapse or spatial curvature. No time-only assumption. *)

Options[RAYCovariantWarpedMetric] = {
 "IntrinsicGeometry" -> "General",
 "Simplification" -> "Simplify",
 Assumptions -> True
};

RAYCovariantWarpedMetric[name_String,coordinates_List,baseMetric_List,
   n_,warp_,OptionsPattern[]] :=
 Module[{d=Length[coordinates],ass=OptionValue[Assumptions],
 mode=OptionValue["Simplification"],geometry=OptionValue["IntrinsicGeometry"],
 simp,baseRic,baseR,ricFullBase,ginv,baseGamma,gradient,hess,box,grad2,
 curvBase,curvInt,curvTensor,refMetric,warpCoefficient,
 metricInverse,baseEinstein,scalar,curv,computed,spatialRic,
 xx,yy},
 If[d<2 || Dimensions[baseMetric]=!={d,d},
  Return[rayFail["RAYCovariantWarpedMetric: base coordinates and metric matrix dimensions must agree, with d>=2."]]];
 If[NumericQ[n] && (!IntegerQ[n] || n<1),
  Return[rayFail["RAYCovariantWarpedMetric: n must be a positive integer or symbolic."]]];
 If[!FreeQ[warp,_RAYTensor|_RAYNabla|_RAYPartialD],
  Return[rayFail["RAYCovariantWarpedMetric: the warp factor must be a coordinate expression, not an abstract tensor."]]];
 If[!FreeQ[baseMetric,Indeterminate|ComplexInfinity],
  Return[rayFail["RAYCovariantWarpedMetric: invalid base metric components."]]];
 simp=Switch[mode,
  "None", Function[v,v],
  "Full",Function[v,FullSimplify[v,ass]],
  _,Function[v,Simplify[v,ass]]];
 computed=RAYDefineMetric[name,coordinates,baseMetric,
    Assumptions->ass,"Simplification"->mode];
 If[computed===$Failed,Return[$Failed]];
 baseRic=RAYRaw["Ricci","dd"];
 baseR=RAYRaw["RicciScalar"];
 ginv=RAYRaw["Metric","uu"];
 baseGamma=rayGamma[];
 gradient=Table[D[warp,coordinates[[a]]],{a,d}];
 hess=Table[
   D[warp,coordinates[[a]],coordinates[[b]]]-
    Sum[baseGamma[[c,a,b]] gradient[[c]],{c,d}],
   {a,d},{b,d}];
 box=simp[Tr[ginv.hess]];
 grad2=simp[gradient.ginv.gradient];
 hess=Map[simp,hess,{2}];
 curv=rayWarpGeometry[geometry,n,"Fiber"];
 If[curv===$Failed,
  Return[rayFail["RAYCovariantWarpedMetric: invalid intrinsic reference geometry."]]];
 curvInt=curv[[1]];
 curvTensor=curv[[2]];
 refMetric=curv[[3]];
 warpCoefficient=simp[box+n grad2];
 ricFullBase=Map[simp,baseRic-n(hess+Outer[Times,gradient,gradient]),{2}];
 scalar=simp[baseR+Exp[-2warp]curvInt-2n box-n(n+1)grad2];
 baseEinstein=Map[simp,ricFullBase-1/2 scalar baseMetric,{2}];
 spatialRic=simp[curvTensor-Exp[2warp]warpCoefficient refMetric];
 <|"Type"->"CovariantWarpedProduct",
  "Name"->name,"Coordinates"->coordinates,
  "BaseDimension"->d,"FiberDimension"->n,
  "TotalDimension"->d+n,"BaseMetric"->baseMetric,
  "InverseBaseMetric"->ginv,
  "Warp"->warp,
  "IntrinsicGeometry"->geometry,
  "IntrinsicRicciScalar"->curvInt,
  "IntrinsicRicciTensor"->curvTensor,
  "FiberReferenceMetric"->refMetric,
  "BaseRicciTensor"->baseRic,
  "BaseRicciScalar"->baseR,
  "WarpPartialDerivative"->gradient,
  "WarpCovariantHessian"->hess,
  "WarpCovariantLaplacian"->box,
  "WarpGradientSquared"->grad2,
  "FullBaseRicciTensor"->ricFullBase,
  "FullFiberRicciTensor"->spatialRic,
  "FullRicciScalar"->scalar,
  "FullBaseEinsteinTensor"->baseEinstein,
  "FullFiberEinsteinTensor"->simp[curvTensor-
      Exp[2warp](warpCoefficient+scalar/2)refMetric],
  "Assumptions"->ass|>
];

(* These are actual covariant components in the supplied base coordinates,
   while RAYPartialD is an unevaluated coordinate derivative marker.
   RAYNabla denotes an abstract covariant derivative, not a partial. *)
RAYPartialD[expression_Plus,index_] := Map[RAYPartialD[#,index]&,expression];
RAYPartialD[expression_?NumericQ,index_] := 0;


(* Deliberately do NOT overwrite the formal RAYNabla algebra or assert
   partial=covariant for non-scalar tensors. A scalar first derivative
   coincides only by evaluation using D[scalar,x]. *)

RAYCovariantWarpedReport[model_Association] /;
 Lookup[model,"Type",None]==="CovariantWarpedProduct" :=
 Column[{
   Style["General coordinate-dependent warped product",Bold,16],
   Grid[{
      {"Total dimension",model["TotalDimension"]},
      {"Covariant Hessian",RAYReadable[model["WarpCovariantHessian"]]},
      {"Covariant Laplacian",RAYReadable[model["WarpCovariantLaplacian"]]},
      {"Gradient norm",RAYReadable[model["WarpGradientSquared"]]},
      {"Ricci scalar",RAYReadable[model["FullRicciScalar"]]}
   },Frame->All,Alignment->Left],
   Style["Ricci tensor blocks",Bold,14],
   MatrixForm[model["FullBaseRicciTensor"]],
   RAYReadable[model["FullFiberRicciTensor"]]
 }];


(* Abstract base dimension d and fiber n may BOTH remain symbolic.
   These are mathematically defined formal covariant operators, not ordinary
   partial differentiation. They do not accidentally evaluate into D[]. *)
RAYAbstractWarpedCurvature[d_,n_,warp_] := Module[
 {a=RAYDown["a"],b=RAYDown["b"],
  gb=RAYTensor["BaseMetric",{RAYDown["a"],RAYDown["b"]}],
  gf=RAYTensor["FiberMetric",{RAYDown["i"],RAYDown["j"]}],
  rb=RAYTensor["BaseRicci",{RAYDown["a"],RAYDown["b"]}],
  rf=RAYTensor["FiberRicci",{RAYDown["i"],RAYDown["j"]}],
  lap=RAYCovariantBox[warp],norm=RAYGradientNorm[warp],
  baseScalar=RAYIntrinsicScalar["Base"],
  fiberScalar=RAYIntrinsicScalar["Fiber"]},
 <|"Type"->"AbstractCovariantWarpedProduct",
   "BaseDimension"->d,"FiberDimension"->n,"TotalDimension"->d+n,
   "BaseMetric"->gb,"FiberMetric"->gf,
   "RicciBaseTensor"->rb-n(
     RAYCovariantHessian[warp,a,b]+
     RAYPartialD[warp,"a"] RAYPartialD[warp,"b"]),
   "RicciFiberTensor"->rf-Exp[2warp](lap+n norm)gf,
   "RicciScalar"->baseScalar+Exp[-2warp]fiberScalar-
     2n lap-n(n+1)norm,
   "CovariantLaplacian"->lap,"GradientSquared"->norm|>
];

(* Exact Weyl rescaling of a dimension-d base metric:
   g'_ab = Exp[2 omega]g_ab, all geometric derivatives use g.
   No identification of tensorial nabla_a nabla_b with partial_a partial_b. *)
RAYWeylRescale[d_,omega_] := Module[
 {g=RAYTensor["BaseMetric",{RAYDown["a"],RAYDown["b"]}],
  r=RAYTensor["BaseRicci",{RAYDown["a"],RAYDown["b"]}],
  h=RAYCovariantHessian[omega,RAYDown["a"],RAYDown["b"]],
  box=RAYCovariantBox[omega],grad=RAYGradientNorm[omega],
  v=RAYPartialD[omega,"a"] RAYPartialD[omega,"b"]},
 <|"Type"->"WeylRescaling",
   "Dimension"->d,"ConformalFactor"->Exp[2omega],
   "RicciTensor"->r-(d-2)h-g box+
     (d-2)(v-g grad),
   "RicciScalar"->Exp[-2omega](
     RAYIntrinsicScalar["Base"]-
     2(d-1)box-(d-1)(d-2)grad),
   "CovariantHessian"->h,
   "CovariantLaplacian"->box,
   "GradientSquared"->grad|>
];


$rayHelpRows=Join[$rayHelpRows,{
 {"RAYCovariantWarpedMetric[name,coords,g,n,B]","Exact warped Ricci from a coordinate-dependent base g_ab(x), with arbitrary symbolic fiber n and covariant Hessian."},
 {"RAYCovariantWarpedReport[model]","Readable coordinate-based warped Ricci/Hessian report."},
 {"RAYPartialD[expr,index]","Formal coordinate partial derivative, distinct from RAYNabla."},
 {"RAYAbstractWarpedCurvature[d,n,B]","Exact covariant warped Ricci formulas with both d and n symbolic and abstract base curvature."},
 {"RAYWeylRescale[d,omega]","Exact d-dimensional conformal transformation of Ricci tensor/scalar using base covariant derivatives."}
}];


(* --- Embedded Kernel/RAYCrossWarped.wl --- *)
(* ::Package:: *)
(* Paper-style crossed double warp: e^(2 A(y)) hat g_mu nu(x) +
   e^(2 B(x)) tilde g_mn(y). Exact for independent base/fiber
   geometries, any symbolic dimensions d+n and orthogonal blocks.
   Both A and B are scalars on their own reference manifolds.
   The Riemann sign follows the core RAY convention. *)

Options[RAYCrossWarpedGeometry]={"DerivativeForm"->"Covariant",
  "Simplification"->"Simplify",
  "ConstantInternalWarp"->False,
  "ConstantExternalWarp"->False,
  "WarpDependence"->"Separated"};

(* These objects are formal differential operators. Numerically constant
   scalars have identically zero first/second derivatives, Hessian,
   Laplace–Beltrami operator, connection corrections, and gradient norm.
   Do NOT infer that an arbitrary symbolic field is constant. *)
RAYFramePartial[_,_,v_?NumericQ] := 0;
RAYFrameHessian[_,_,_,v_?NumericQ] := 0;
RAYFramePartialHessian[_,_,_,v_?NumericQ] := 0;
RAYFrameConnectionTerm[_,_,_,v_?NumericQ] := 0;
RAYFrameBox[_,v_?NumericQ] := 0;
RAYFramePartialBox[_,v_?NumericQ] := 0;
RAYFrameNorm[_,v_?NumericQ] := 0;

RAYCrossWarpedGeometry[d_,n_,internalWarp_,externalWarp_,
  OptionsPattern[]] := Module[
 {form=OptionValue["DerivativeForm"],aa=internalWarp,bb=externalWarp,
  hmu="μ",hnu="ν",tm="m",tn="n",RH,RT,gh,gt,
  boxH,boxT,normH,normT,hessH,hessT,gradH1,gradH2,gradT1,gradT2,
  ricH,ricT,ricMix,ricScalar,einH,einT,einMix,
  constantA,constantB},
 If[OptionValue["WarpDependence"]==="General",
  Return[RAYDoubleWarpedGeometry[d,n,internalWarp,externalWarp,
    "DerivativeForm"->form,
    "ConstantA"->OptionValue["ConstantInternalWarp"],
    "ConstantB"->OptionValue["ConstantExternalWarp"]]]];
 If[OptionValue["WarpDependence"]=!="Separated",
  Return[rayFail["RAYCrossWarpedGeometry: WarpDependence must be General or Separated."]]];
 If[!MemberQ[{"Covariant","Partial"},form],
   Return[rayFail[
    "RAYCrossWarpedGeometry: \"DerivativeForm\" must be \"Covariant\" or \"Partial\"."]]];
 constantA=TrueQ[OptionValue["ConstantInternalWarp"]]||TrueQ[NumericQ[aa]];
 constantB=TrueQ[OptionValue["ConstantExternalWarp"]]||TrueQ[NumericQ[bb]];
 If[NumericQ[d]&&(!IntegerQ[d]||d<1)||
    NumericQ[n]&&(!IntegerQ[n]||n<1),
   Return[rayFail["RAYCrossWarpedGeometry: d and n must be positive dimensions."]]];
 RH=RAYFrameTensor["Hat","Ricci",{hmu,hnu}];
 RT=RAYFrameTensor["Tilde","Ricci",{tm,tn}];
 gh=RAYFrameTensor["Hat","Metric",{hmu,hnu}];
 gt=RAYFrameTensor["Tilde","Metric",{tm,tn}];
 boxH=If[constantB,0,If[form==="Covariant",
   RAYFrameBox["Hat",bb],RAYFramePartialBox["Hat",bb]]];
 boxT=If[constantA,0,If[form==="Covariant",
   RAYFrameBox["Tilde",aa],RAYFramePartialBox["Tilde",aa]]];
 normH=If[constantB,0,RAYFrameNorm["Hat",bb]];
 normT=If[constantA,0,RAYFrameNorm["Tilde",aa]];
 hessH=If[constantB,0,If[form==="Covariant",
   RAYFrameHessian["Hat",hmu,hnu,bb],
   RAYFramePartialHessian["Hat",hmu,hnu,bb]-
   RAYFrameConnectionTerm["Hat",hmu,hnu,bb]]];
 hessT=If[constantA,0,If[form==="Covariant",
   RAYFrameHessian["Tilde",tm,tn,aa],
   RAYFramePartialHessian["Tilde",tm,tn,aa]-
   RAYFrameConnectionTerm["Tilde",tm,tn,aa]]];
 gradH1=If[constantB,0,RAYFramePartial["Hat",hmu,bb]];
 gradH2=If[constantB,0,RAYFramePartial["Hat",hnu,bb]];
 gradT1=If[constantA,0,RAYFramePartial["Tilde",tm,aa]];
 gradT2=If[constantA,0,RAYFramePartial["Tilde",tn,aa]];
 ricH=RH-n (hessH+gradH1 gradH2)-
    gh Exp[2 aa-2 bb](boxT+d normT);
 ricT=RT-d (hessT+gradT1 gradT2)-
    gt Exp[2 bb-2 aa](boxH+n normH);
 ricMix=(d+n-2)gradH1 gradT1;
 ricScalar=Exp[-2aa]RAYFrameScalar["Hat","Ricci"]+
    Exp[-2bb]RAYFrameScalar["Tilde","Ricci"]-
    n Exp[-2aa](2 boxH+(n+1)normH)-
    d Exp[-2bb](2 boxT+(d+1)normT);
 einH=RAYFrameTensor["Hat","Einstein",{hmu,hnu}]-
    n(hessH+gradH1 gradH2)+
    n gh (boxH+(n+1)/2 normH)+
    Exp[2aa-2bb]gh ((d-1)boxT+d(d-1)/2 normT-
      1/2 RAYFrameScalar["Tilde","Ricci"]);
 einT=RAYFrameTensor["Tilde","Einstein",{tm,tn}]-
    d(hessT+gradT1 gradT2)+
    d gt (boxT+(d+1)/2 normT)+
    Exp[2bb-2aa]gt ((n-1)boxH+n(n-1)/2 normH-
      1/2 RAYFrameScalar["Hat","Ricci"]);
 einMix=ricMix;
 <|"Type"->"CrossWarpedGeometry","ExternalDimension"->d,
   "InternalDimension"->n,"TotalDimension"->d+n,
   "ExternalWarp"->aa,"InternalWarp"->bb,
   "Metric"->"Exp[2 A(y)] hat[g](x) + Exp[2 B(x)] tilde[g](y)",
   "DerivativeForm"->form,
   "InternalWarpConstant"->constantA,
   "ExternalWarpConstant"->constantB,
   "RicciExternal"->ricH,"RicciInternal"->ricT,
   "RicciMixed"->ricMix,"RicciScalar"->ricScalar,
   "EinsteinExternal"->einH,"EinsteinInternal"->einT,
   "EinsteinMixed"->einMix,
   "ExternalBox"->boxH,"InternalBox"->boxT,
   "ExternalGradientSquared"->normH,
   "InternalGradientSquared"->normT|>
];

(* Exact partial-to-covariant conversion.  Partial covariant Hessian
   = partial_mu partial_nu f - Gamma^rho_mu nu partial_rho f,
   while the Laplace-Beltrami box is the inverse-metric trace. *)
RAYCrossToCovariant[expression_] :=
 Expand[expression /. {
  HoldPattern[RAYFramePartialHessian[f_,i_,j_,phi_]] :>
   RAYFrameHessian[f,i,j,phi]+RAYFrameConnectionTerm[f,i,j,phi],
  HoldPattern[RAYFramePartialBox[f_,phi_]] :>
   RAYFrameBox[f,phi]
 }] // Expand;

(* Input notation is an intentional display policy, not a rewrite of
   any computed tensor's interpretation. *)
rayCrossAccent[name_] := If[name==="Hat","^","~"];
rayCrossSymbol[name_,type_] :=
  OverscriptBox[
   StyleBox[Switch[type,"Ricci","R","Einstein","G",
    "Metric","g",_ ,type],FontSlant->"Italic"],
   rayCrossAccent[name]];

rayCrossIndices[i_List,fmt_] :=
 RowBox[Map[If[StringQ[#],#,
    MakeBoxes[#,fmt]]&,i]];

RAYFrameTensor /: MakeBoxes[RAYFrameTensor[frame_String,
   type_String, indices_List],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=SubscriptBox[rayCrossSymbol[frame,type],
    rayCrossIndices[indices,fmt]]},
   InterpretationBox[boxes,RAYFrameTensor[frame,type,indices],
   Editable->False]];

RAYFrameScalar /: MakeBoxes[
 RAYFrameScalar[frame_String,type_String],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=rayCrossSymbol[frame,type]},
  InterpretationBox[boxes,RAYFrameScalar[frame,type],Editable->False]];

rayCrossOperator[frame_,"Nabla"] :=
 OverscriptBox["\[Del]",rayCrossAccent[frame]];
rayCrossOperator[frame_,"Partial"] := "\[PartialD]";
rayCrossOperator[frame_,"Box"] :=
 OverscriptBox["\[EmptySquare]",rayCrossAccent[frame]];

RAYFramePartial /: MakeBoxes[RAYFramePartial[frame_String,
 idx_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{SubscriptBox[
   rayCrossOperator[frame,"Partial"],If[StringQ[idx],idx,
   MakeBoxes[idx,fmt]]],MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartial[frame,idx,expr],Editable->False]];

RAYFrameHessian /: MakeBoxes[RAYFrameHessian[frame_String,
  i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubscriptBox[rayCrossOperator[frame,"Nabla"],
    If[StringQ[i],i,MakeBoxes[i,fmt]]],
  SubscriptBox[rayCrossOperator[frame,"Nabla"],
    If[StringQ[j],j,MakeBoxes[j,fmt]]],MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFrameHessian[frame,i,j,expr],
   Editable->False]];

RAYFramePartialHessian /: MakeBoxes[RAYFramePartialHessian[
 frame_String,i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubscriptBox[rayCrossOperator[frame,"Partial"],i],
  SubscriptBox[rayCrossOperator[frame,"Partial"],j],
   MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartialHessian[frame,i,j,expr],
  Editable->False]];

RAYFrameConnectionTerm /: MakeBoxes[RAYFrameConnectionTerm[
 frame_String,i_,j_,expr_],fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SubsuperscriptBox[OverscriptBox["\[CapitalGamma]",rayCrossAccent[frame]],
    RowBox[{i,j}],"\[Rho]"],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"\[Rho]"],
  MakeBoxes[expr,fmt]}]},
 InterpretationBox[boxes,RAYFrameConnectionTerm[frame,i,j,expr],
 Editable->False]];

RAYFrameBox /: MakeBoxes[RAYFrameBox[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{rayCrossOperator[frame,"Box"],
    MakeBoxes[expr,fmt]}]},
   InterpretationBox[boxes,RAYFrameBox[frame,expr],Editable->False]];

RAYFramePartialBox /: MakeBoxes[RAYFramePartialBox[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],
    RowBox[{"a","b"}]],
  "(",SubscriptBox[rayCrossOperator[frame,"Partial"],"a"],
    SubscriptBox[rayCrossOperator[frame,"Partial"],"b"],
    "-",SubsuperscriptBox[
     OverscriptBox["\[CapitalGamma]",rayCrossAccent[frame]],
     RowBox[{"a","b"}],"c"],
   SubscriptBox[rayCrossOperator[frame,"Partial"],"c"],
  ")",MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFramePartialBox[frame,expr],
   Editable->False]];

RAYFrameNorm /: MakeBoxes[RAYFrameNorm[frame_String,expr_],
 fmt:(StandardForm|TraditionalForm)] :=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],
    RowBox[{"a","b"}]],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"a"],
   MakeBoxes[expr,fmt],
  SubscriptBox[rayCrossOperator[frame,"Partial"],"b"],
   MakeBoxes[expr,fmt]}]},
  InterpretationBox[boxes,RAYFrameNorm[frame,expr],
  Editable->False]];

(* Paper-style grouped equations; component matrix calculations belong to
   RAYCovariantWarpedMetric or RAYDefineMetric. *)
RAYCrossWarpedReport[model_Association] /;
 Lookup[model,"Type",None]==="CrossWarpedGeometry" :=
 Column[{
  Style["Crossed double warp: exact d+n tensor identities",Bold,15],
  Grid[{
   {"External Ricci",RAYPretty[model["RicciExternal"]]},
   {"Internal Ricci",RAYPretty[model["RicciInternal"]]},
   {"Mixed Ricci",RAYPretty[model["RicciMixed"]]},
   {"Ricci scalar",RAYPretty[model["RicciScalar"]]},
   {"External Einstein",RAYPretty[model["EinsteinExternal"]]},
   {"Internal Einstein",RAYPretty[model["EinsteinInternal"]]},
   {"Mixed Einstein",RAYPretty[model["EinsteinMixed"]]}
  },Frame->All,Alignment->Left]
 }];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYCrossWarpedGeometry[d,n,A,B]","Exact Appendix-C-style crossed double warped tensors with d,n symbolic and covariant/partial derivative notation."},
 {"RAYCrossToCovariant[expr]","Translate the partial-plus-connection representation to covariant-form tensor expressions."},
 {"RAYCrossWarpedReport[model]","Display Ricci and Einstein block equations in paper-style symbolic notation."}
}];


(* --- Embedded Kernel/RAYDownloads.wl --- *)
(* ::Package:: *)
(* Verified RAY.wl updater; FileHash uses raw file bytes. *)
Options[RAYUpdateStandalone]={"Destination"->Automatic,"VerifySHA256"->True};
Options[RAYUpdate]=Options[RAYUpdateStandalone];
RAYUpdate[opts:OptionsPattern[]]:=RAYUpdateStandalone[
 "Destination"->OptionValue["Destination"],
 "VerifySHA256"->OptionValue["VerifySHA256"]];
RAYUpdateStandalone[OptionsPattern[]]:=Module[
 {dest=OptionValue["Destination"],verify=OptionValue["VerifySHA256"],
  uri="https://github.com/shaikot996/RAY/releases/latest/download/",
  sourceTemp,shaTemp,dl,shaDl,checks,entries,matched,
  expected,actual,txt,result,back="",ok=False},
 If[dest===Automatic,
   dest=FileNameJoin[{$UserBaseDirectory,"Applications","RAY.wl"}]];
 If[!StringQ[dest]||StringLength[dest]===0,
  Return[rayFail["RAYUpdate: invalid destination."]]];
 If[!DirectoryQ[DirectoryName[dest]],
  If[Quiet@Check[CreateDirectory[DirectoryName[dest],
    CreateIntermediateDirectories->True];True,$Failed]=!=True,
   Return[rayFail["RAYUpdate: cannot create destination directory."]]]];
 sourceTemp=CreateTemporary[];shaTemp=CreateTemporary[];
 result=Catch[
  dl=Quiet@Check[URLDownload[uri<>"RAY.wl",sourceTemp],$Failed];
  If[dl===$Failed||!FileExistsQ[sourceTemp]||FileByteCount[sourceTemp]<20000,
    Throw[rayFail["RAYUpdate: unable to download RAY.wl."]]];
  txt=Quiet@Check[Import[sourceTemp,"Text"],$Failed];
  If[txt===$Failed||!StringContainsQ[txt,"BeginPackage["]||
    !StringContainsQ[txt,"EndPackage[]"]||
    !StringContainsQ[txt,"$RAYVersion"],
    Throw[rayFail["RAYUpdate: invalid downloaded package."]]];
  If[TrueQ[verify],
   shaDl=Quiet@Check[URLDownload[uri<>"SHA256SUMS.txt",shaTemp],$Failed];
   If[shaDl===$Failed||!FileExistsQ[shaTemp],
     Throw[rayFail["RAYUpdate: checksum file unavailable."]]];
   checks=Quiet@Check[Import[shaTemp,"Text"],$Failed];
   If[!StringQ[checks],
     Throw[rayFail["RAYUpdate: cannot read checksums."]]];
   entries=StringSplit[StringTrim[#]]& /@ StringSplit[checks,"\n"];
   matched=Select[entries,Length[#]>=2&&Last[#]==="RAY.wl"&];
   If[Length[matched]=!=1||
      !StringMatchQ[First[matched[[1]]],
       RegularExpression["[A-Fa-f0-9]{64}"]],
     Throw[rayFail["RAYUpdate: missing or ambiguous RAY.wl checksum."]]];
   expected=ToLowerCase[First[matched[[1]]]];
   actual=ToLowerCase[FileHash[sourceTemp,"SHA256","HexString"]];
   If[!StringQ[actual]||actual=!=expected,
     Throw[rayFail["RAYUpdate: SHA256 mismatch. Existing file preserved."]]];
  ];
  If[FileExistsQ[dest],
   back=dest<>".previous";
   If[FileExistsQ[back],DeleteFile[back]];
   If[Quiet@Check[CopyFile[dest,back];True,$Failed]=!=True,
     Throw[rayFail["RAYUpdate: backup failed."]]]];
  If[Quiet@Check[CopyFile[sourceTemp,dest,OverwriteTarget->True];True,$Failed]=!=True,
     Throw[rayFail["RAYUpdate: installation failed."]]];
  If[TrueQ[verify]&&
     ToLowerCase[FileHash[dest,"SHA256","HexString"]]=!=expected,
    If[back=!=""&&FileExistsQ[back],
      CopyFile[back,dest,OverwriteTarget->True],
      If[FileExistsQ[dest],DeleteFile[dest]]];
    Throw[rayFail["RAYUpdate: installed checksum mismatch; original restored."]]];
  ok=True;dest
 ];
 If[FileExistsQ[sourceTemp],DeleteFile[sourceTemp]];
 If[FileExistsQ[shaTemp],DeleteFile[shaTemp]];
 If[ok,Print["RAY.wl verified and installed: ",dest,
   ". Restart kernel and run Needs[\"RAY"<>FromCharacterCode[96]<>"\"]."]];
 result
];
$rayHelpRows=Join[$rayHelpRows,{
 {"RAYUpdate[]","Verify SHA256 and install the latest RAY.wl, backing up the previous version."},
 {"RAYUpdateStandalone[]","Compatibility alias of RAYUpdate[]; the installed file is RAY.wl."}
}];

(* --- Embedded Kernel/RAYDoublyTwisted.wl --- *)
(* ::Package:: *)
(* RAY General Doubly Twisted Product — independent A(x,y), B(x,y).
   Metric G=e^(2 A(x,y)) hat[g](x) (+) e^(2 B(x,y)) tilde[g](y).
   NO constraint on either warp's coordinate dependence.
   d,n symbolic; both reference geometries arbitrary nondegenerate.
   Curvature R^rho_(sigma mu nu) matches RAY.
   Reference: universal conformal transformation of twisted products. *)

Options[RAYDoubleWarpedGeometry]={"DerivativeForm"->"Covariant",
 "ConstantA"->False,"ConstantB"->False,
 "ExternalCoordinates"->Automatic,"InternalCoordinates"->Automatic};

RAYFrameInner[_,a_?NumericQ,_]:=0;
RAYFrameInner[_,_,a_?NumericQ]:=0;
RAYFrameInner[frame_,a_,a_]:=RAYFrameNorm[frame,a];
RAYMixedPartial[_,_,field_?NumericQ]:=0;

RAYFrameInner /: MakeBoxes[
 RAYFrameInner[frame_String,a_,b_],fmt:(StandardForm|TraditionalForm)]:=
 With[{boxes=RowBox[{
  SuperscriptBox[rayCrossSymbol[frame,"Metric"],RowBox[{"a","b"}]],
  SubscriptBox["\[PartialD]","a"],MakeBoxes[a,fmt],
  SubscriptBox["\[PartialD]","b"],MakeBoxes[b,fmt]}]},
  InterpretationBox[boxes,RAYFrameInner[frame,a,b],Editable->False]];
RAYMixedPartial /: MakeBoxes[
 RAYMixedPartial[i_,m_,field_],fmt:(StandardForm|TraditionalForm)]:=
 With[{boxes=RowBox[{
  SubscriptBox["\[PartialD]",If[StringQ[i],i,MakeBoxes[i,fmt]]],
  SubscriptBox["\[PartialD]",If[StringQ[m],m,MakeBoxes[m,fmt]]],
  MakeBoxes[field,fmt]}]},
  InterpretationBox[boxes,RAYMixedPartial[i,m,field],Editable->False]];

rayDTPartial[frame_,index_,field_,constant_]:=
 If[constant,0,RAYFramePartial[frame,index,field]];
rayDTHess[frame_,i_,j_,field_,constant_,form_]:=
 If[constant,0,If[form==="Covariant",RAYFrameHessian[frame,i,j,field],
   RAYFramePartialHessian[frame,i,j,field]-
    RAYFrameConnectionTerm[frame,i,j,field]]];
rayDTBox[frame_,field_,constant_,form_]:=
 If[constant,0,If[form==="Covariant",RAYFrameBox[frame,field],
   RAYFramePartialBox[frame,field]]];
rayDTNorm[frame_,field_,constant_]:=
 If[constant,0,RAYFrameNorm[frame,field]];
rayDTInner[frame_,a_,b_,ca_,cb_]:=
 If[ca||cb,0,If[SameQ[a,b],RAYFrameNorm[frame,a],
    RAYFrameInner[frame,a,b]]];
rayDTMixed[i_,m_,field_,constant_]:=
 If[constant,0,RAYMixedPartial[i,m,field]];

RAYDoubleWarpedGeometry[d_,n_,A_,B_,OptionsPattern[]]:=Module[
 {form=OptionValue["DerivativeForm"],ca,cb,
 mu="μ",nu="ν",m="m",nn="n",h="Hat",tt="Tilde",
 gh,gt,rh,rt,scH,scT,ha,hb,ta,tb,pa1,pa2,pb1,pb2,
 qa1,qa2,qb1,qb2,naH,nbH,naT,nbT,abH,abT,
 xaH,xbH,xaT,xbT,coefH,coefT,RE,RI,RM,RS,GE,GI,
 xs=OptionValue["ExternalCoordinates"],ys=OptionValue["InternalCoordinates"],
 registered,caH,caT,cbH,cbT},
 If[!MemberQ[{"Covariant","Partial"},form],
   Return[rayFail["RAYDoubleWarpedGeometry: DerivativeForm must be Covariant or Partial."]]];
 If[(NumericQ[d]&&(!IntegerQ[d]||d<1))||
    (NumericQ[n]&&(!IntegerQ[n]||n<1)),
   Return[rayFail["RAYDoubleWarpedGeometry: dimensions must be positive."]]];
 ca=TrueQ[OptionValue["ConstantA"]]||TrueQ[NumericQ[A]];
 cb=TrueQ[OptionValue["ConstantB"]]||TrueQ[NumericQ[B]];
 registered=ListQ[xs]&&ListQ[ys]&&
   AllTrue[Join[xs,ys],Head[#]===Symbol&]&&
   Length[DeleteDuplicates[Join[xs,ys]]]==Length[Join[xs,ys]]&&
   IntegerQ[d]&&IntegerQ[n]&&Length[xs]==d&&Length[ys]==n;
 If[!(xs===Automatic&&ys===Automatic)&&!registered,
  Return[rayFail["RAYDoubleWarpedGeometry: both complete disjoint ExternalCoordinates and InternalCoordinates lists are required to infer dependence, and sizes must agree with d,n."]]];
 (* Bare symbolic tensor fields are never silently considered constant.
    Only explicit coordinates can certify sector-wise independence. *)
 caH=ca||(registered&&Head[A]=!=Symbol&&
    AllTrue[xs,TrueQ[PossibleZeroQ[D[A,#]]]&]);
 caT=ca||(registered&&Head[A]=!=Symbol&&
    AllTrue[ys,TrueQ[PossibleZeroQ[D[A,#]]]&]);
 cbH=cb||(registered&&Head[B]=!=Symbol&&
    AllTrue[xs,TrueQ[PossibleZeroQ[D[B,#]]]&]);
 cbT=cb||(registered&&Head[B]=!=Symbol&&
    AllTrue[ys,TrueQ[PossibleZeroQ[D[B,#]]]&]);
 gh=RAYFrameTensor[h,"Metric",{mu,nu}];
 gt=RAYFrameTensor[tt,"Metric",{m,nn}];
 rh=RAYFrameTensor[h,"Ricci",{mu,nu}];
 rt=RAYFrameTensor[tt,"Ricci",{m,nn}];
 scH=RAYFrameScalar[h,"Ricci"];
 scT=RAYFrameScalar[tt,"Ricci"];
 ha=rayDTHess[h,mu,nu,A,caH,form];
 hb=rayDTHess[h,mu,nu,B,cbH,form];
 ta=rayDTHess[tt,m,nn,A,caT,form];
 tb=rayDTHess[tt,m,nn,B,cbT,form];
 pa1=rayDTPartial[h,mu,A,caH];pa2=rayDTPartial[h,nu,A,caH];
 pb1=rayDTPartial[h,mu,B,cbH];pb2=rayDTPartial[h,nu,B,cbH];
 qa1=rayDTPartial[tt,m,A,caT];qa2=rayDTPartial[tt,nn,A,caT];
 qb1=rayDTPartial[tt,m,B,cbT];qb2=rayDTPartial[tt,nn,B,cbT];
 naH=rayDTNorm[h,A,caH];nbH=rayDTNorm[h,B,cbH];
 naT=rayDTNorm[tt,A,caT];nbT=rayDTNorm[tt,B,cbT];
 abH=rayDTInner[h,A,B,caH,cbH];
 abT=rayDTInner[tt,A,B,caT,cbT];
 xaH=rayDTBox[h,A,caH,form];xbH=rayDTBox[h,B,cbH,form];
 xaT=rayDTBox[tt,A,caT,form];xbT=rayDTBox[tt,B,cbT,form];
 coefH=xaH+(d-2)naH+n abH+
    Exp[2A-2B](xaT+d naT+(n-2)abT);
 coefT=xbT+(n-2)nbT+d abT+
    Exp[2B-2A](xbH+n nbH+(d-2)abH);
 RE=rh-(d-2)ha-n hb+
    (d-2)pa1 pa2-n pb1 pb2+n(pa1 pb2+pb1 pa2)-gh coefH;
 RI=rt-(n-2)tb-d ta+
    (n-2)qb1 qb2-d qa1 qa2+d(qb1 qa2+qa1 qb2)-gt coefT;
 RM=-(d-1)rayDTMixed[mu,m,A,caH||caT]-
    (n-1)rayDTMixed[mu,m,B,cbH||cbT]+
    (d+n-2)pb1 qa1;
 RS=Exp[-2A](scH-2(d-1)xaH-2n xbH-
     (d-1)(d-2)naH-n(n+1)nbH-2n(d-2)abH)+
    Exp[-2B](scT-2d xaT-2(n-1)xbT-
     d(d+1)naT-(n-1)(n-2)nbT-2d(n-2)abT);
 GE=RE-Exp[2A] gh RS/2;
 GI=RI-Exp[2B] gt RS/2;
 <|"Type"->"GeneralDoubleWarpedGeometry",
  "ExternalDimension"->d,"InternalDimension"->n,"TotalDimension"->d+n,
  "WarpA"->A,"WarpB"->B,
  "ExternalWarp"->A,"InternalWarp"->B,
  "DerivativeForm"->form,
  "CoordinateDependence"->"Unrestricted external and internal dependence for both scalar warp functions",
  "ConstantA"->ca,"ConstantB"->cb,
  "ExternalCoordinates"->xs,"InternalCoordinates"->ys,
  "CoordinatesRegistered"->registered,
  "Metric"->"Exp[2 A(x,y)] hat[g](x) + Exp[2 B(x,y)] tilde[g](y)",
  "RicciExternal"->RE,"RicciInternal"->RI,"RicciMixed"->RM,
  "RicciScalar"->RS,
  "EinsteinExternal"->GE,"EinsteinInternal"->GI,"EinsteinMixed"->RM,
  "ExternalBoxA"->xaH,"ExternalBoxB"->xbH,
  "InternalBoxA"->xaT,"InternalBoxB"->xbT,
  "ExternalGradientA"->naH,"ExternalGradientB"->nbH,
  "InternalGradientA"->naT,"InternalGradientB"->nbT|>
];

RAYDoubleWarpedReport[model_Association]/;
 Lookup[model,"Type",None]==="GeneralDoubleWarpedGeometry":=
 Column[{
  Style["General doubly twisted geometry: arbitrary A(x,y), B(x,y)",Bold,16],
  Grid[{
   {"Total dimension",model["TotalDimension"]},
   {"External Ricci",RAYPretty[model["RicciExternal"]]},
   {"Internal Ricci",RAYPretty[model["RicciInternal"]]},
   {"Mixed Ricci",RAYPretty[model["RicciMixed"]]},
   {"Ricci scalar",RAYPretty[model["RicciScalar"]]},
   {"External Einstein",RAYPretty[model["EinsteinExternal"]]},
   {"Internal Einstein",RAYPretty[model["EinsteinInternal"]]},
   {"Mixed Einstein",RAYPretty[model["EinsteinMixed"]]}
  },Frame->All,Alignment->Left]
 }];

(* Coordinate specialization bridges formal and component descriptions.
   Reference metrics remain independent; both warp fields can depend on
   every coordinate. These are actual full-metric tensors, not an ansatz. *)
Options[RAYDoubleWarpedToComponents]=Join[
 Options[RAYDefineMetric],{"Verify"->True}];

rayDTReference[coord_List,g_List,ass_]:=Module[
 {k=Length[coord],gi,ga,rc},
 gi=FullSimplify[Inverse[g],ass];
 ga=Table[FullSimplify[
   Sum[gi[[i,l]](D[g[[l,j]],coord[[m]]]+
     D[g[[l,m]],coord[[j]]]-D[g[[j,m]],coord[[l]]])/2,{l,k}],ass],
   {i,k},{j,k},{m,k}];
 rc=Table[FullSimplify[Sum[
    D[ga[[l,i,j]],coord[[l]]]-
    D[ga[[l,i,l]],coord[[j]]]+
    Sum[ga[[l,l,m]] ga[[m,i,j]]-
      ga[[l,j,m]]ga[[m,i,l]],{m,k}],{l,k}],ass],{i,k},{j,k}];
 <|"Metric"->g,"Inverse"->gi,"Gamma"->ga,"Ricci"->rc,
   "Scalar"->FullSimplify[Tr[gi.rc],ass]|>
];
rayDTField[coord_List,ref_Association,f_,ass_]:=Module[
 {k=Length[coord],grad,hess},
 grad=D[f,#]&/@coord;
 hess=Table[FullSimplify[
   D[f,coord[[i]],coord[[j]]]-
    Sum[ref["Gamma"][[l,i,j]]grad[[l]],{l,k}],ass],
   {i,k},{j,k}];
 <|"Gradient"->grad,"Hessian"->hess,
 "Box"->FullSimplify[Tr[ref["Inverse"].hess],ass],
 "Norm"->FullSimplify[grad.ref["Inverse"].grad,ass]|>
];
rayDTScalarProduct[a_Association,b_Association,ref_Association,ass_]:=
 FullSimplify[a["Gradient"].ref["Inverse"].b["Gradient"],ass];
rayDTBlock[hatRef_,tildeRef_,ehA_,ehB_,tiA_,tiB_,A_,B_,d_,n_,ass_]:=Module[
 {gha=hatRef["Metric"],gti=tildeRef["Metric"],
 pa=ehA["Gradient"],pb=ehB["Gradient"],
 qa=tiA["Gradient"],qb=tiB["Gradient"],
 hab=rayDTScalarProduct[ehA,ehB,hatRef,ass],
 tab=rayDTScalarProduct[tiA,tiB,tildeRef,ass],
 coefH,coefT,RH,RT,RM,scalar,gfull},
 coefH=ehA["Box"]+(d-2)ehA["Norm"]+n hab+
   Exp[2A-2B](tiA["Box"]+d tiA["Norm"]+(n-2)tab);
 coefT=tiB["Box"]+(n-2)tiB["Norm"]+d tab+
   Exp[2B-2A](ehB["Box"]+n ehB["Norm"]+(d-2)hab);
 RH=hatRef["Ricci"]-(d-2)ehA["Hessian"]-n ehB["Hessian"]+
   (d-2)Outer[Times,pa,pa]-n Outer[Times,pb,pb]+
   n(Outer[Times,pa,pb]+Outer[Times,pb,pa])-gha coefH;
 RT=tildeRef["Ricci"]-(n-2)tiB["Hessian"]-d tiA["Hessian"]+
   (n-2)Outer[Times,qb,qb]-d Outer[Times,qa,qa]+
   d(Outer[Times,qb,qa]+Outer[Times,qa,qb])-gti coefT;
 RM=-(d-1)Table[D[A,hatRef["Coordinates"][[i]],
     tildeRef["Coordinates"][[j]]],{i,d},{j,n}]-
   (n-1)Table[D[B,hatRef["Coordinates"][[i]],
     tildeRef["Coordinates"][[j]]],{i,d},{j,n}]+
   (d+n-2)Outer[Times,pb,qa];
 scalar=Exp[-2A](hatRef["Scalar"]-
   2(d-1)ehA["Box"]-2n ehB["Box"]-
   (d-1)(d-2)ehA["Norm"]-n(n+1)ehB["Norm"]-
   2n(d-2)hab)+
   Exp[-2B](tildeRef["Scalar"]-
   2d tiA["Box"]-2(n-1)tiB["Box"]-
   d(d+1)tiA["Norm"]-(n-1)(n-2)tiB["Norm"]-
   2d(n-2)tab);
 <|"RicciExternal"->FullSimplify[RH,ass],
  "RicciInternal"->FullSimplify[RT,ass],
  "RicciMixed"->FullSimplify[RM,ass],
  "RicciScalar"->FullSimplify[scalar,ass]|>
];
RAYDoubleWarpedToComponents[model_Association,name_String,
  externalCoordinates_List,internalCoordinates_List,
  externalMetric_List,internalMetric_List,OptionsPattern[]]:=Module[
 {d=Length[externalCoordinates],n=Length[internalCoordinates],
  coords,ass=OptionValue[Assumptions],A,B,ha,hb,ta,tb,
  href,tref,full,ret,derived,actual,rs,ein,block,verify,checks},
 If[Lookup[model,"Type",None]=!="GeneralDoubleWarpedGeometry",
  Return[rayFail["RAYDoubleWarpedToComponents: supply a general double warped model."]]];
 If[!TrueQ[FullSimplify[model["ExternalDimension"]==d&&
      model["InternalDimension"]==n,ass]],
  Return[rayFail["RAYDoubleWarpedToComponents: reference coordinate sizes must match specified dimensions."]]];
 If[TrueQ[model["CoordinatesRegistered"]]&&
    (model["ExternalCoordinates"]=!=externalCoordinates||
     model["InternalCoordinates"]=!=internalCoordinates),
  Return[rayFail["RAYDoubleWarpedToComponents: supplied coordinate lists differ from those registered in the abstract model."]]];
 If[Dimensions[externalMetric]=!={d,d}||Dimensions[internalMetric]=!={n,n}||
    Length[DeleteDuplicates[Join[externalCoordinates,internalCoordinates]]]=!=d+n,
  Return[rayFail["RAYDoubleWarpedToComponents: inconsistent coordinate or matrix dimensions."]]];
 If[!And@@Flatten[
   Table[TrueQ[FullSimplify[D[externalMetric[[i,j]],y]==0,ass]],
    {i,d},{j,d},{y,internalCoordinates}]]||
    !And@@Flatten[
   Table[TrueQ[FullSimplify[D[internalMetric[[i,j]],x]==0,ass]],
    {i,n},{j,n},{x,externalCoordinates}]],
  Return[rayFail["RAYDoubleWarpedToComponents: reference external g must be independent of internal coordinates and vice versa. Both warp fields are unrestricted."]]];
 coords=Join[externalCoordinates,internalCoordinates];
 A=model["WarpA"];B=model["WarpB"];
 (* A bare symbolic parameter must never be mistaken for a constant warp:
    the abstract API accepts bare scalar names, the component API requires
    functions of coordinates or an explicit "ConstantA/B" assumption. *)
 If[(Head[A]===Symbol&&!TrueQ[model["ConstantA"]])||
    (Head[B]===Symbol&&!TrueQ[model["ConstantB"]]),
   Return[rayFail["RAYDoubleWarpedToComponents: bare symbolic warp names have unknown coordinate dependence. Use A[t,x,y,z] and B[t,x,y,z], or explicitly set ConstantA/ConstantB -> True in the abstract model."]]];
 href=Join[rayDTReference[externalCoordinates,externalMetric,ass],
  <|"Coordinates"->externalCoordinates|>];
 tref=Join[rayDTReference[internalCoordinates,internalMetric,ass],
  <|"Coordinates"->internalCoordinates|>];
 ha=rayDTField[externalCoordinates,href,A,ass];
 hb=rayDTField[externalCoordinates,href,B,ass];
 ta=rayDTField[internalCoordinates,tref,A,ass];
 tb=rayDTField[internalCoordinates,tref,B,ass];
 derived=rayDTBlock[href,tref,ha,hb,ta,tb,A,B,d,n,ass];
 full=ArrayFlatten[{
  {Exp[2A]externalMetric,ConstantArray[0,{d,n}]},
  {ConstantArray[0,{n,d}],Exp[2B]internalMetric}
 }];
 ret=RAYDefineMetric[name,coords,full,Assumptions->ass,
   "Simplification"->OptionValue["Simplification"]];
 If[ret===$Failed,Return[$Failed]];
 actual=RAYRaw["Ricci","dd"];rs=RAYRaw["RicciScalar"];
 ein=RAYRaw["Einstein","dd"];
 checks=<|
  "RicciExternal"->FullSimplify[
    actual[[1;;d,1;;d]]-derived["RicciExternal"],ass],
  "RicciInternal"->FullSimplify[
    actual[[d+1;;d+n,d+1;;d+n]]-derived["RicciInternal"],ass],
  "RicciMixed"->FullSimplify[
    actual[[1;;d,d+1;;d+n]]-derived["RicciMixed"],ass],
  "RicciScalar"->FullSimplify[rs-derived["RicciScalar"],ass],
  "EinsteinTrace"->FullSimplify[Tr[Inverse[full].ein]-
    (1-(d+n)/2)rs,ass]|>;
 verify=If[TrueQ[OptionValue["Verify"]],
   And@@(TrueQ[FullSimplify[#==0,ass]]||TrueQ[
     FullSimplify[#==ConstantArray[0,Dimensions[#]],ass]]&/@Values[checks]),
   Missing["NotRequested"]];
 <|"Type"->"DoubleWarpedComponentGeometry",
  "Name"->name,"Dimensions"->{d,n},
  "Coordinates"->coords,"Metric"->full,
  "RicciTensor"->actual,"RicciScalar"->rs,"EinsteinTensor"->ein,
  "RicciExternal"->actual[[1;;d,1;;d]],
  "RicciInternal"->actual[[d+1;;d+n,d+1;;d+n]],
  "RicciMixed"->actual[[1;;d,d+1;;d+n]],
  "DerivedFromGeneralFormula"->derived,
  "Residuals"->checks,"Verified"->verify,
  "AbstractModel"->model|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYDoubleWarpedGeometry[d,n,A,B]","General doubly twisted metric with unrestricted A(x,y),B(x,y), arbitrary symbolic dimensions and covariant/partial operators."},
 {"RAYDoubleWarpedReport[model]","Paper-style Ricci, scalar and Einstein tensors, including second mixed derivatives."},
 {"RAYDoubleWarpedToComponents[model,name,x,y,hatg,tildeg]","Instantiate arbitrary reference metrics, compute components and independently compare Ricci/scalar with symbolic identities."}
}];

(* --- Embedded Kernel/RAYGeneralBlocks.wl --- *)
(* ::Package:: *)
(* General orthogonal 2-block metric in arbitrary d+n dimensions:
   H_(mu nu)(x,y)=Exp[2A(x,y)] hatg_(mu nu)(x,y),
   Q_(mn)(x,y)=Exp[2B(x,y)] tildeg_(mn)(x,y).
   The reference metrics may each vary across BOTH coordinate sectors.
   Full metric is block diagonal, nondegenerate and torsion free.
   Abstract curvature identities are exact C/K decompositions.
   Riemann convention matches the component RAY engine. *)

Options[RAYGeneralBlockGeometry]={"DerivativeForm"->"Covariant"};
RAYGeneralBlockGeometry[d_,n_,A_,B_,OptionsPattern[]]:=Module[
 {mu="\[Mu]",nu="\[Nu]",m="m",nn="n",form=OptionValue["DerivativeForm"],
  H,Q,ricH,ricQ,ricM,scalar,einH,einQ},
 If[form=!="Covariant",
  Return[rayFail["RAYGeneralBlockGeometry: exact abstract C/K formulas currently use induced covariant derivatives; use \"DerivativeForm\"->\"Covariant\"."]]];
 If[(NumericQ[d]&&(!IntegerQ[d]||d<1))||
   (NumericQ[n]&&(!IntegerQ[n]||n<1)),
  Return[rayFail["RAYGeneralBlockGeometry: d and n must be positive dimensions."]]];
 H=RAYBlockTerm["HMetric",{mu,nu}];
 Q=RAYBlockTerm["QMetric",{m,nn}];
 (* H- and Q-covariant divergences include the appropriate connection
    on every relevant tensor slot. C and K are defined below. *)
 ricH=RAYBlockTerm["HRicci",{mu,nu}]-
  RAYBlockTerm["HCovDOfKTrace",{mu,nu}]-
  RAYBlockTerm["KSquare",{mu,nu}]-
  RAYBlockTerm["QDivC",{mu,nu}]-
  RAYBlockTerm["CTraceC",{mu,nu}]+
  2RAYBlockTerm["CSquare",{mu,nu}];
 ricQ=RAYBlockTerm["QRicci",{m,nn}]-
  RAYBlockTerm["QCovDOfCTrace",{m,nn}]-
  RAYBlockTerm["CSquareInternal",{m,nn}]-
  RAYBlockTerm["HDivK",{m,nn}]-
  RAYBlockTerm["KTraceK",{m,nn}]+
  2RAYBlockTerm["KSquareInternal",{m,nn}];
 ricM=RAYBlockTerm["HDivCUp",{mu,m}]-
  RAYBlockTerm["PartialCTrace",{mu,m}]+
  RAYBlockTerm["QDivKUp",{mu,m}]-
  RAYBlockTerm["PartialKTrace",{mu,m}]+
  RAYBlockTerm["KTraceC",{mu,m}]+
  RAYBlockTerm["CTraceK",{mu,m}]-
  2RAYBlockTerm["CKCross",{mu,m}];
 scalar=RAYBlockTrace["H",ricH]+RAYBlockTrace["Q",ricQ];
 einH=ricH-H scalar/2;
 einQ=ricQ-Q scalar/2;
 <|"Type"->"GeneralOrthogonalBlocks",
  "TotalDimension"->d+n,"ExternalDimension"->d,"InternalDimension"->n,
  "WarpA"->A,"WarpB"->B,"DerivativeForm"->form,
  "ExternalMetric"->H,"InternalMetric"->Q,
  "Metric"->"H=Exp[2A(x,y)] hat[g](x,y), Q=Exp[2B(x,y)] tilde[g](x,y)",
  "ReferenceMetricDependence"->"Both reference blocks may depend on all external and internal coordinates",
  "CDefinition"->RAYBlockTerm["CDefinition",{}],
  "KDefinition"->RAYBlockTerm["KDefinition",{}],
  "RicciExternal"->ricH,"RicciInternal"->ricQ,
  "RicciMixed"->ricM,"RicciScalar"->scalar,
  "EinsteinExternal"->einH,"EinsteinInternal"->einQ,
  "EinsteinMixed"->ricM|>
];

RAYBlockTerm /: MakeBoxes[RAYBlockTerm[type_String,indices_List],
 fmt:(StandardForm|TraditionalForm)]:=With[
 {b=SubscriptBox[StyleBox[Switch[type,
    "HMetric","H","QMetric","Q","HRicci","R[H]","QRicci","R[Q]",
    "HCovDOfKTrace","D[H] K","KSquare","Tr(K K)",
    "QDivC","Div[Q] C","CTraceC","Tr(C) C",
    "CSquare","C.C","QCovDOfCTrace","D[Q] C",
    "CSquareInternal","Tr(C C)","HDivK","Div[H] K",
    "KTraceK","Tr(K) K","KSquareInternal","K.K",
    "HDivCUp","Div[H] C","PartialCTrace","d Tr(C)",
    "QDivKUp","Div[Q] K","PartialKTrace","d Tr(K)",
    "KTraceC","Tr(K) C","CTraceK","Tr(C) K",
    "CKCross","C.K","CDefinition","C = (1/2) d_y H",
    "KDefinition","K = (1/2) d_x Q",_,type],FontSlant->"Italic"],
   RowBox[If[StringQ[#],# ,MakeBoxes[#,fmt]]&/@indices]]},
 InterpretationBox[b,RAYBlockTerm[type,indices],Editable->False]
];
RAYBlockTrace /: MakeBoxes[RAYBlockTrace[which_String,expr_],
 fmt:(StandardForm|TraditionalForm)]:=With[
 {b=RowBox[{"Tr[",which,"]","(",MakeBoxes[expr,fmt],")"}]},
 InterpretationBox[b,RAYBlockTrace[which,expr],Editable->False]
];

RAYGeneralBlockReport[g_Association]/;
 Lookup[g,"Type",None]==="GeneralOrthogonalBlocks":=
 Column[{Style["Arbitrary d+n orthogonal blocks, including time-dependent internal geometry",Bold,15],
 Grid[{{"Metric",g["Metric"]},
 {"C = (1/2) partial_m H",g["CDefinition"]},
 {"K = (1/2) partial_mu Q",g["KDefinition"]},
 {"External Ricci",RAYPretty[g["RicciExternal"]]},
 {"Internal Ricci",RAYPretty[g["RicciInternal"]]},
 {"Mixed Ricci",RAYPretty[g["RicciMixed"]]},
 {"Ricci scalar",RAYPretty[g["RicciScalar"]]},
 {"External Einstein",RAYPretty[g["EinsteinExternal"]]},
 {"Internal Einstein",RAYPretty[g["EinsteinInternal"]]},
 {"Mixed Einstein",RAYPretty[g["EinsteinMixed"]]}},
 Frame->All,Alignment->Left]}];

(* Explicit specialization and INDEPENDENT block curvature derivation:
   H and Q may each depend on ALL x and y.
   Each induced Levi-Civita connection differentiates its own block's
   coordinates only; cross-derivatives are K and C. *)
Options[RAYGeneralBlockToComponents]=Join[Options[RAYDefineMetric],
 {"Verify"->True}];

rayGBBlockCurvature[xs_List,ys_List,H_List,Q_List,ass_]:=Module[
 {d=Length[xs],n=Length[ys],h,q,hi,qi,ch,cq,C,K,Cu,Ku,
  Cr,Kr,Cup,Kup,re,ri,rm,scalar,einH,einQ,
  divC,divK,divCu,divKu,calc},
 h=Join[rayDTReference[xs,H,ass],<|"Coordinates"->xs|>];
 q=Join[rayDTReference[ys,Q,ass],<|"Coordinates"->ys|>];
 hi=h["Inverse"];qi=q["Inverse"];ch=h["Gamma"];cq=q["Gamma"];
 C=Table[D[H[[i,j]],ys[[m]]]/2,{m,n},{i,d},{j,d}];
 K=Table[D[Q[[p,r]],xs[[i]]]/2,{i,d},{p,n},{r,n}];
 Cu=Table[Sum[hi[[i,j]] C[[m,j,k]],{j,d}],
   {m,n},{i,d},{k,d}];
 Ku=Table[Sum[qi[[p,r]] K[[i,r,s]],{r,n}],
   {i,d},{p,n},{s,n}];
 Cr=Table[Sum[hi[[i,j]] C[[m,i,j]],{i,d},{j,d}],{m,n}];
 Kr=Table[Sum[qi[[p,r]] K[[i,p,r]],{p,n},{r,n}],{i,d}];
 Cup=Table[Sum[qi[[m,p]]C[[p,i,j]],{p,n}],
   {m,n},{i,d},{j,d}];
 Kup=Table[Sum[hi[[i,j]]K[[j,m,p]],{j,d}],
   {i,d},{m,n},{p,n}];
 divC=Table[Sum[
    D[Cup[[m,i,j]],ys[[m]]]+
    Sum[cq[[m,m,p]]Cup[[p,i,j]],{p,n}],{m,n}],
   {i,d},{j,d}];
 divK=Table[Sum[
    D[Kup[[i,m,p]],xs[[i]]]+
    Sum[ch[[i,i,j]]Kup[[j,m,p]],{j,d}],{i,d}],
   {m,n},{p,n}];
 divCu=Table[Sum[
    D[Cu[[m,i,j]],xs[[i]]]+
    Sum[ch[[i,i,k]]Cu[[m,k,j]]-
      ch[[k,i,j]]Cu[[m,i,k]],{k,d}],{i,d}],
   {m,n},{j,d}];
 divKu=Table[Sum[
    D[Ku[[i,p,m]],ys[[p]]]+
    Sum[cq[[p,p,q0]] Ku[[i,q0,m]]-
     cq[[q0,p,m]]Ku[[i,p,q0]],{q0,n}],{p,n}],
   {i,d},{m,n}];
 re=Table[
  h["Ricci"][[i,j]]-
    (D[Kr[[i]],xs[[j]]]-
     Sum[ch[[k,j,i]]Kr[[k]],{k,d}])-
    Sum[Ku[[i,p,q0]]Ku[[j,q0,p]],{p,n},{q0,n}]-
    divC[[i,j]]-
    Sum[Cr[[m]]Cup[[m,i,j]],{m,n}]+
    2Sum[qi[[m,p]]C[[m,i,r]]hi[[r,s]]C[[p,s,j]],
      {m,n},{p,n},{r,d},{s,d}],
   {i,d},{j,d}];
 ri=Table[
  q["Ricci"][[m,p]]-
    (D[Cr[[m]],ys[[p]]]-
     Sum[cq[[q0,p,m]]Cr[[q0]],{q0,n}])-
    Sum[Cu[[m,i,j]]Cu[[p,j,i]],{i,d},{j,d}]-
    divK[[m,p]]-
    Sum[Kr[[i]]Kup[[i,m,p]],{i,d}]+
    2Sum[hi[[i,j]]K[[i,m,q0]]qi[[q0,s]]K[[j,s,p]],
      {i,d},{j,d},{q0,n},{s,n}],
   {m,n},{p,n}];
 rm=Table[
    divCu[[m,i]]-D[Cr[[m]],xs[[i]]] +
    divKu[[i,m]]-D[Kr[[i]],ys[[m]]]+
    Sum[Kr[[j]]Cu[[m,j,i]],{j,d}]+
    Sum[Cr[[p]]Ku[[i,p,m]],{p,n}]-
    2Sum[Cu[[p,j,i]]Ku[[j,p,m]],{p,n},{j,d}],
   {i,d},{m,n}];
 re=FullSimplify[re,ass];ri=FullSimplify[ri,ass];
 rm=FullSimplify[rm,ass];
 scalar=FullSimplify[
   Sum[hi[[i,j]]re[[i,j]],{i,d},{j,d}]+
   Sum[qi[[m,p]]ri[[m,p]],{m,n},{p,n}],ass];
 <|"RicciExternal"->re,"RicciInternal"->ri,
  "RicciMixed"->rm,"RicciScalar"->scalar,
  "EinsteinExternal"->FullSimplify[re-H scalar/2,ass],
  "EinsteinInternal"->FullSimplify[ri-Q scalar/2,ass],
  "EinsteinMixed"->rm,
  "C"->C,"K"->K,"CTrace"->Cr,"KTrace"->Kr,
  "HInverse"->hi,"QInverse"->qi|>
];

RAYGeneralBlockToComponents[model_Association,name_String,
 xs_List,ys_List,hat_List,tilde_List,OptionsPattern[]]:=Module[
 {d=Length[xs],n=Length[ys],all=Join[xs,ys],
  a=model["WarpA"],b=model["WarpB"],ass=OptionValue[Assumptions],
  H,Q,full,ret,block,ric,rs,ein,resid,verified},
 If[Lookup[model,"Type",None]=!="GeneralOrthogonalBlocks",
  Return[rayFail["RAYGeneralBlockToComponents: invalid model."]]];
 If[model["ExternalDimension"]=!=d||model["InternalDimension"]=!=n||
    Dimensions[hat]=!={d,d}||Dimensions[tilde]=!={n,n}||
    Length[DeleteDuplicates[all]]=!=Length[all],
  Return[rayFail["RAYGeneralBlockToComponents: coordinate and matrix dimensions must match concrete d,n."]]];
 If[!TrueQ[FullSimplify[Transpose[hat]==hat,ass]]||
    !TrueQ[FullSimplify[Transpose[tilde]==tilde,ass]],
  Return[rayFail["RAYGeneralBlockToComponents: both reference metrics must be symmetric."]]];
 If[TrueQ[FullSimplify[Det[hat]==0||Det[tilde]==0,ass]],
  Return[rayFail["RAYGeneralBlockToComponents: reference metrics must be nondegenerate under supplied assumptions."]]];
 H=Exp[2a]hat;Q=Exp[2b]tilde;
 block=rayGBBlockCurvature[xs,ys,H,Q,ass];
 full=ArrayFlatten[{{H,ConstantArray[0,{d,n}]},
   {ConstantArray[0,{n,d}],Q}}];
 ret=RAYDefineMetric[name,all,full,Assumptions->ass,
   "Simplification"->OptionValue["Simplification"]];
 If[ret===$Failed,Return[$Failed]];
 ric=RAYRaw["Ricci","dd"];rs=RAYRaw["RicciScalar"];
 ein=RAYRaw["Einstein","dd"];
 resid=<|
   "RicciExternal"->FullSimplify[ric[[1;;d,1;;d]]-block["RicciExternal"],ass],
   "RicciInternal"->FullSimplify[ric[[d+1;;d+n,d+1;;d+n]]-block["RicciInternal"],ass],
   "RicciMixed"->FullSimplify[ric[[1;;d,d+1;;d+n]]-block["RicciMixed"],ass],
   "RicciScalar"->FullSimplify[rs-block["RicciScalar"],ass],
   "EinsteinExternal"->FullSimplify[ein[[1;;d,1;;d]]-block["EinsteinExternal"],ass],
   "EinsteinInternal"->FullSimplify[ein[[d+1;;d+n,d+1;;d+n]]-block["EinsteinInternal"],ass],
   "EinsteinMixed"->FullSimplify[ein[[1;;d,d+1;;d+n]]-block["EinsteinMixed"],ass]|>;
 verified=If[TrueQ[OptionValue["Verify"]],
   And@@(TrueQ[FullSimplify[#==0,ass]]||
    TrueQ[FullSimplify[#==ConstantArray[0,Dimensions[#]],ass]]& /@
    Values[resid]),Missing["NotRequested"]];
 <|"Type"->"GeneralOrthogonalBlockComponents",
  "Name"->name,"TotalDimension"->d+n,"Coordinates"->all,
  "Metric"->full,"RicciTensor"->ric,"RicciScalar"->rs,
  "EinsteinTensor"->ein,
  "RicciExternal"->ric[[1;;d,1;;d]],
  "RicciInternal"->ric[[d+1;;d+n,d+1;;d+n]],
  "RicciMixed"->ric[[1;;d,d+1;;d+n]],
  "InducedC"->block["C"],"InducedK"->block["K"],
  "Derived"->block,"Residuals"->resid,
  "Verified"->verified|>
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYGeneralBlockGeometry[d,n,A,B]","Exact d+n Ricci and Einstein tensor decompositions for H=exp(2A) hat[g](x,y), Q=exp(2B) tilde[g](x,y), with arbitrary reference metric variation."},
 {"RAYGeneralBlockToComponents[model,name,x,y,hatg,tildeg]","Evaluate H/Q internal and external derivatives, Ricci and Einstein blocks, independently verifying all tensor components."},
 {"RAYGeneralBlockReport[model]","Display exact abstract C/K-based general curvature formulas."}
}];

End[];

EndPackage[];
