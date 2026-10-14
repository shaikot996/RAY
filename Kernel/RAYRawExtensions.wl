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
