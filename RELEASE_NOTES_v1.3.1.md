# RAY 1.3.1 — Correct constant warp derivatives

This patch fixes a genuine symbolic correctness issue in the crossed doubly warped metric:
\[
ds^2=e^{2A(y)}\widehat g_{\mu\nu}(x)dx^\mu dx^\nu
+e^{2B(x)}\widetilde g_{mn}(y)dy^m dy^n.
\]

Previously, when the user supplied a constant warp such as A=1, the
inert typesetting operators could leave terms like tildeBox[1] or
partial_m[1] unevaluated in Ricci and Einstein expressions. These
terms are mathematically zero.

## What is fixed

- **Numeric constants:** derivative, covariant Hessian, second partial,
  connection correction, Laplace–Beltrami, and squared gradient of
  numeric constants now become exact zero. This works in both
  "Covariant" and "Partial" derivative modes.
- **Symbolic constants:** when c is explicitly known to be constant,
  set "ConstantInternalWarp"->True (for A=c) or
  "ConstantExternalWarp"->True (for B=c). These flags are mathematical
  assumptions; do not apply them to fields with nonzero coordinate
  derivatives.
- **Metric normalization:** A=1 is a constant overall rescaling
  e^(2 A)=e^2; A=0 is the choice making the factor unity.
- **Mixed curvature:** R_mu m and G_mu m vanish when either crossed
  warp is a constant.
- **Time dependence:** B[t] is an abstract scalar with a declared
  argument t, but reference covariant Hessians stay formal unless
  the external metric and coordinates are supplied. No Christoffel
  terms are silently dropped.

## Example

~~~mathematica
ClearAll[d,n,t,B,c];

g=RAYCrossWarpedGeometry[4,6,1,B[t]];
g["RicciExternal"] // RAYPretty
g["RicciInternal"] // RAYPretty
g["RicciMixed"] // RAYPretty
g["RicciScalar"] // RAYPretty

unit=RAYCrossWarpedGeometry[4,6,0,B[t]];

symbolic=RAYCrossWarpedGeometry[d,n,c,B[t],
 "ConstantInternalWarp"->True];
symbolic["RicciMixed"]  (* 0 *)
~~~

For component expansion of B(t), use a concrete reference metric
via RAYDefineMetric, RAYGeneralWarpedMetric (time-only case), or
RAYCovariantWarpedMetric (base-coordinate-dependent case).

## Testing

Adds independent 4D constant-warp tests and exact symbolic checks
for all constant differential operators, including partial/covariant
equivalence, scalar and full tensor identities. The v1.3.0 tests
remain in place.

## Download

The existing release workflow publishes the updated RAYStandalone.wl,
ZIP and SHA256SUMS.txt at:
https://github.com/shaikot996/RAY/releases/latest

To update, call RAYUpdateStandalone[] from an installed v1.3.0+
package, restart the kernel, and Get the new file.
