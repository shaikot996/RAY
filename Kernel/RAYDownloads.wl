(* ::Package:: *)
(* Opt-in latest standalone downloader. It NEVER evaluates downloaded code.
   GitHub Actions publishes a permanent latest/download/RAYStandalone.wl URL. *)
Options[RAYUpdateStandalone]={"Destination"->Automatic,"VerifySHA256"->True};

RAYUpdateStandalone[OptionsPattern[]] := Module[
 {dest=OptionValue["Destination"],validate=OptionValue["VerifySHA256"],
  uri="https://github.com/shaikot996/RAY/releases/latest/download/",
  sourceTemp,shaTemp,dl,shaDl,checks,expected,actual,txt,result,back,ok=False},
 If[dest===Automatic,
   dest=FileNameJoin[{$HomeDirectory,"Downloads","RAYStandalone.wl"}]];
 If[!StringQ[dest]||StringLength[dest]===0,
  Return[rayFail["RAYUpdateStandalone: Destination must be a file path."]]];
 If[!DirectoryQ[DirectoryName[dest]],
  Return[rayFail["RAYUpdateStandalone: destination folder does not exist."]]];
 sourceTemp=CreateTemporary[];shaTemp=CreateTemporary[];
 result=Catch[
  dl=Quiet@Check[URLDownload[uri<>"RAYStandalone.wl",sourceTemp],$Failed];
  If[dl===$Failed||!FileExistsQ[sourceTemp]||FileByteCount[sourceTemp]<20000,
   Throw[rayFail["RAYUpdateStandalone: unable to download standalone WL file."]]];
  txt=Quiet@Check[Import[sourceTemp,"Text"],$Failed];
  If[txt===$Failed||!StringContainsQ[txt,"BeginPackage[\"RAY`\"]"]||
     !StringContainsQ[txt,"EndPackage[]"]||
     !StringContainsQ[txt,"$RAYVersion"],
   Throw[rayFail["RAYUpdateStandalone: invalid RAY distribution."]]];
  If[TrueQ[validate],
   shaDl=Quiet@Check[URLDownload[uri<>"SHA256SUMS.txt",shaTemp],$Failed];
   If[shaDl===$Failed||!FileExistsQ[shaTemp],
    Throw[rayFail["RAYUpdateStandalone: SHA256 checksum unavailable."]]];
   checks=Quiet@Check[Import[shaTemp,"Text"],$Failed];
   expected=If[StringQ[checks],
     StringCases[checks,RegularExpression[
      "(?m)^([0-9a-fA-F]{64})[ \\t]+RAYStandalone\\.wl[ \\t]*$"]->"$1"],{}];
   If[expected==={},
    Throw[rayFail["RAYUpdateStandalone: standalone checksum not found."]]];
   actual=ToLowerCase[Hash[BinaryReadList[sourceTemp,"Byte"],"SHA256","HexString"]];
   If[ToLowerCase[First[expected]]=!=actual,
    Throw[rayFail["RAYUpdateStandalone: SHA256 mismatch. Existing file preserved."]]]
  ];
  If[FileExistsQ[dest],
    back=dest<>".previous";
    If[FileExistsQ[back],DeleteFile[back]];
    CopyFile[dest,back]];
  CopyFile[sourceTemp,dest,OverwriteTarget->True];
  ok=True;dest
 ];
 If[FileExistsQ[sourceTemp],DeleteFile[sourceTemp]];
 If[FileExistsQ[shaTemp],DeleteFile[shaTemp]];
 If[ok,Print["RAY downloaded and verified: ",dest,
 ". Restart the Mathematica kernel and load this file to activate."]];
 result
];

$rayHelpRows=Join[$rayHelpRows,{
 {"RAYUpdateStandalone[]","Download and verify the latest RAYStandalone.wl release, keeping a .previous backup; never evaluates remote code."}
}];
