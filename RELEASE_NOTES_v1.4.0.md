# RAY v1.4.0: completely general d+n doubly twisted products

## New features

* New RAYDoubleWarpedGeometry[d,n,A,B], supporting fully independent smooth A(x,y) and B(x,y). Reference metrics remain arbitrary metrics on their two respective factors.
* All symbolic d+n Ricci tensor external/internal/mixed blocks, Ricci scalar, and Einstein tensor blocks; no assumed coordinate independence or discarded mixed second derivatives.
* Hat/tilde Hessians, Laplacians, partial-plus-connection expansions, gradient inner products, and readable mathematical formatting.
* Optional complete external/internal coordinate lists for mathematically justified elimination of zero derivatives.
* RAYDoubleWarpedToComponents constructs the exact full metric, evaluates independent full Levi-Civita curvature and tests all Ricci blocks, scalar and Einstein trace against the abstract expressions.
* RAYCrossWarpedGeometry supports "WarpDependence"->"General" while retaining the old separated behavior by default.
* Component evaluation rejects ambiguous bare scalar names; there is no silent interpretation of symbolic warp fields as constants.

## Validation and installation

45 new tests passed in a Wolfram kernel, including curved reference geometries with both warps depending on all coordinates. Existing test suites retained and updated for version 1.4.0.

See GENERAL_DOUBLE_WARP.md for equations, reproducible examples, API limitations, and Mathematica workflows.

The single-file release artifact continues to be RAY.wl and RAYUpdate[] continues to verify raw-byte SHA256.
