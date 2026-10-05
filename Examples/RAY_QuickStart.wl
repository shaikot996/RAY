(* RAY — Quick Start *)

Needs["RAY`"];

RAYHelp[];

(* ============================================================ *)
(* Example 1: Bianchi-I + Raychaudhuri                          *)
(* ============================================================ *)

RAYDefineMetric[
  "BianchiI",
  {t, x, y, z},
  DiagonalMatrix[{
    -1,
    Exp[2 b1[t]],
    Exp[2 b2[t]],
    Exp[2 b3[t]]
  }],
  Assumptions -> Element[{t, x, y, z}, Reals]
];

RAYDefineCongruence["Comoving", {1, 0, 0, 0}];

RAYExpansion[]
RAYShear["dd"]
RAYVorticity["dd"]
RAYRaychaudhuriTerms[]
RAYKinematicChecks[]

(* ============================================================ *)
(* Example 2: Schwarzschild                                     *)
(* ============================================================ *)

RAYDefineMetric[
  "Schwarzschild",
  {t, r, \[Theta], \[Phi]},
  DiagonalMatrix[{
    -(1 - 2 M/r),
    1/(1 - 2 M/r),
    r^2,
    r^2 Sin[\[Theta]]^2
  }],
  Assumptions -> r > 2 M > 0 && 0 < \[Theta] < Pi
];

RAYNonzeroRiemann["uddd"]
RAYRicci["dd"]
RAYRicciScalar[]
RAYKretschmann[]

(* ============================================================ *)
(* Example 3: 5D Minkowski                                      *)
(* ============================================================ *)

RAYDefineMetric[
  "Minkowski5D",
  {t, x1, x2, x3, x4},
  DiagonalMatrix[{-1, 1, 1, 1, 1}]
];

RAYDimension[]
RAYRiemann["uddd"]

(* ============================================================ *)
(* Raw expressions for further algebra                          *)
(* ============================================================ *)

rawRicci = RAYRaw["Ricci", "dd"];
rawKretschmann = RAYRaw["Kretschmann"];
