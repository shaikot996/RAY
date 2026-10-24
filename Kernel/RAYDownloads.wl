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
