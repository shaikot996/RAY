(* RAY v1.4.0 updater SHA256 regression tests. *)
Needs["RAY`"];
hashFile=CreateTemporary[];
BinaryWrite[hashFile,ToCharacterCode["abc","UTF-8"],"Byte"];
Close[hashFile];
updateTests={
 VerificationTest[RAYVersion,"1.4.0",TestID->"01-version"],
 VerificationTest[Head[RAYUpdate],Symbol,TestID->"02-update-command"],
 VerificationTest[Head[RAYUpdateStandalone],Symbol,TestID->"03-legacy-command"],
 VerificationTest[Options[RAYUpdate],
  {"Destination"->Automatic,"VerifySHA256"->True},
  TestID->"04-options"],
 VerificationTest[Options[RAYUpdateStandalone]===Options[RAYUpdate],
  True,TestID->"05-compatibility-options"],
 VerificationTest[FileHash[hashFile,"SHA256","HexString"],
  "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
  TestID->"06-raw-sha256-known-vector"],
 VerificationTest[Hash[BinaryReadList[hashFile,"Byte"],"SHA256","HexString"]===
  FileHash[hashFile,"SHA256","HexString"],False,
  TestID->"07-old-algorithm-not-file-hash"],
 VerificationTest[StringMatchQ[FileHash[hashFile,"SHA256","HexString"],
   RegularExpression["[A-Fa-f0-9]{64}"]],True,
  TestID->"08-hex-format"],
 VerificationTest[Length[Select[StringSplit[StringTrim[#]]& /@
   StringSplit["aaa  RAYStandalone.wl\nbbb  RAY.wl\n","\n"],
   Length[#]>=2&&Last[#]==="RAY.wl"&]],1,
  TestID->"09-primary-filename-only"],
 VerificationTest[Length[Select[StringSplit[StringTrim[#]]& /@
   StringSplit["abc  RAYStandalone.wl\n","\n"],
   Length[#]>=2&&Last[#]==="RAY.wl"&]],0,
  TestID->"10-legacy-manifest-excluded"]
};
DeleteFile[hashFile];
updateReport=TestReport[updateTests];
updateSummary=<|
 "Total"->Length[updateTests],
 "Passed"->Length[updateReport[[1]]["TestsSucceededKeys"]],
 "Failed"->Length[updateReport[[1]]["TestsFailedWrongResultsKeys"]]+
 Length[updateReport[[1]]["TestsFailedWithMessagesKeys"]]|>;
updateSummary
