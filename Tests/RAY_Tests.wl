(* RAY regression tests
   Run after installing/loading RAY:
       Get[".../Tests/RAY_Tests.wl"]
*)

Needs["RAY`"];

ClearAll[
  t, x, y, z, r, th, ph, M, b, b1, b2, b3,
  x1, x2, x3, x4, om
];

tests = {

  VerificationTest[
    Module[{ric, sig, vort, gi},
      RAYDefineMetric[
        "TestBianchiI",
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

      ric = RAYRaw["Ricci", "dd"];
      sig = RAYRaw["Shear", "dd"];
      vort = RAYRaw["Vorticity", "dd"];
      gi = Inverse[
        DiagonalMatrix[{
          -1,
          Exp[2 b1[t]],
          Exp[2 b2[t]],
          Exp[2 b3[t]]
        }]
      ];

      {
        FullSimplify[
          ric[[1, 1]]
          + b1'[t]^2 + b2'[t]^2 + b3'[t]^2
          + b1''[t] + b2''[t] + b3''[t]
        ],
        FullSimplify[
          Sum[gi[[mu, nu]] sig[[mu, nu]], {mu, 4}, {nu, 4}]
        ],
        FullSimplify[vort],
        RAYRaw["RaychaudhuriResidual"]
      }
    ],
    {
      0,
      0,
      ConstantArray[0, {4, 4}],
      0
    },
    TestID -> "Bianchi-I kinematics and Raychaudhuri"
  ],

  VerificationTest[
    Module[{ric, k},
      RAYDefineMetric[
        "TestSchwarzschild",
        {t, r, th, ph},
        DiagonalMatrix[{
          -(1 - 2 M/r),
          1/(1 - 2 M/r),
          r^2,
          r^2 Sin[th]^2
        }],
        Assumptions -> r > 2 M > 0 && 0 < th < Pi
      ];

      ric = FullSimplify[
        RAYRaw["Ricci", "dd"],
        Assumptions -> r > 2 M > 0 && 0 < th < Pi
      ];
      k = FullSimplify[
        RAYRaw["Kretschmann"],
        Assumptions -> r > 2 M > 0 && 0 < th < Pi
      ];

      {ric, k}
    ],
    {
      ConstantArray[0, {4, 4}],
      48 M^2/r^6
    },
    TestID -> "Schwarzschild Ricci-flatness and Kretschmann"
  ],

  VerificationTest[
    Module[{weyl},
      RAYDefineMetric[
        "TestFlatFLRW",
        {t, x, y, z},
        DiagonalMatrix[{
          -1,
          Exp[2 b[t]],
          Exp[2 b[t]],
          Exp[2 b[t]]
        }]
      ];

      weyl = FullSimplify[RAYRaw["Weyl", "dddd"]];
      weyl
    ],
    ConstantArray[0, {4, 4, 4, 4}],
    TestID -> "Flat FLRW Weyl tensor vanishes"
  ],

  VerificationTest[
    Module[{},
      RAYDefineMetric[
        "TestFlat5D",
        {t, x1, x2, x3, x4},
        DiagonalMatrix[{-1, 1, 1, 1, 1}]
      ];
      RAYDefineCongruence["Inertial5D", {1, 0, 0, 0, 0}];

      {
        RAYDimension[],
        RAYRaw["Riemann", "uddd"],
        RAYRaw["RaychaudhuriResidual"]
      }
    ],
    {
      5,
      ConstantArray[0, {5, 5, 5, 5}],
      0
    },
    TestID -> "Arbitrary-dimension 5D flat spacetime"
  ],

  VerificationTest[
    Module[{},
      RAYDefineMetric[
        "TestMostlyMinusFLRW",
        {t, x, y, z},
        DiagonalMatrix[{
          1,
          -Exp[2 b[t]],
          -Exp[2 b[t]],
          -Exp[2 b[t]]
        }]
      ];
      RAYDefineCongruence["ComovingMostlyMinus", {1, 0, 0, 0}];

      {
        RAYCongruenceNorm[],
        RAYRaw["RaychaudhuriResidual"]
      }
    ],
    {
      TraditionalForm[1],
      0
    },
    TestID -> "Mostly-minus signature"
  ],

  VerificationTest[
    Module[{vort2},
      RAYDefineMetric[
        "TestRotatingMinkowski",
        {t, r, ph, z},
        DiagonalMatrix[{-1, 1, r^2, 1}],
        Assumptions -> r > 0 && om^2 r^2 < 1 &&
          Element[{r, om}, Reals]
      ];

      RAYDefineCongruence[
        "RigidRotation",
        {
          1/Sqrt[1 - om^2 r^2],
          0,
          om/Sqrt[1 - om^2 r^2],
          0
        }
      ];

      vort2 = FullSimplify[
        2 RAYRaw["VorticityScalar"],
        Assumptions -> r > 0 && om^2 r^2 < 1
      ];

      {
        vort2,
        RAYRaw["RaychaudhuriResidual"]
      }
    ],
    {
      2 om^2/(1 - om^2 r^2)^2,
      0
    },
    TestID -> "Rotating congruence has nonzero vorticity"
  ],

  VerificationTest[
    Module[{rscalar, weyl},
      RAYDefineMetric[
        "TestSphere2D",
        {th, ph},
        DiagonalMatrix[{1, Sin[th]^2}],
        Assumptions -> 0 < th < Pi
      ];

      rscalar = FullSimplify[RAYRaw["RicciScalar"], Assumptions -> 0 < th < Pi];
      weyl = RAYRaw["Weyl", "dddd"];

      {rscalar, weyl}
    ],
    {
      2,
      ConstantArray[0, {2, 2, 2, 2}]
    },
    TestID -> "2D sphere and low-dimensional Weyl rule"
  ]

};

TestReport[tests]
