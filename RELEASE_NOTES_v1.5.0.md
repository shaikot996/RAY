# RAY v1.5.0 — unrestricted block reference geometries

- Exact abstract d+n Ricci/Einstein tensor decomposition for arbitrary H(x,y)=exp(2A) hatg(x,y) and Q(x,y)=exp(2B) tildeg(x,y). In particular, tildeg(t,y) is allowed.
- New RAYGeneralBlockGeometry, RAYGeneralBlockReport, and RAYGeneralBlockToComponents; full Levi-Civita comparison for all Ricci and Einstein tensor blocks.
- All partial_t tildeg and partial_y hatg terms retained through induced C and K tensors; no assumptions of Einstein, Kähler, diagonal, or static reference metrics.
- Backward compatible with v1.4.0 doubly twisted/separated warps.
- Canonical RAY.wl now checks latest GitHub release automatically during *fresh* Needs loading; byte-level SHA256 verification, atomic update, backup, immediate active-kernel reload, and fail-open offline behavior. Disable using Global`$RAYAutoUpdateOnLoad=False before Needs. Versions <=1.4.0 require one initial manual update.
- Full guide: GENERAL_BLOCK_METRIC.md.
- Verification: independent Wolfram 1+1, 2+1 and 2+2 full component comparisons, old special-case agreement, mock upgrade and invalid checksum tests. SHA256 consistency against release assets validated at publish time.
