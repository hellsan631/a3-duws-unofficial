@echo off
setlocal

for %%i in ("%~dp0..") do set "folder=%%~fi"
for %%a in ("%folder%") do set ParentDir=%%~nxa

set fileName=DUWSU

echo ....................
echo Starting Copying
echo ....................
echo ....................
echo Number of Files Copied
echo Map Name (File Name)
echo ....................
echo ....................
echo .

IF NOT "%ParentDir%"=="%fileName%.Altis" call:copyMapFile "Altis","Altis"
IF "%ParentDir%"=="%fileName%.Altis" echo Skipped Altis Copy
IF "%ParentDir%"=="%fileName%.Altis" echo ....................

call:copyMapFile "Woodland_ACR","Bystrica"
call:copyMapFile "Chernarus","Chernarus"
call:copyMapFile "Chernarus_Summer","Chernarus Summer"
call:copyMapFile "Desert_E","Desert"
call:copyMapFile "Panthera3","Panthera"
call:copyMapFile "Porto","Porto"
call:copyMapFile "ProvingGrounds_PMC","Proving Grounds"
call:copyMapFile "Intro","Rahmadi"
call:copyMapFile "Sara","Sahrani"
call:copyMapFile "Shapur_BAF","Shapur"
call:copyMapFile "SaraLite","Southren Sahrani"
call:copyMapFile "Stratis","Stratis"
call:copyMapFile "Takistan","Takistan"
call:copyMapFile "Mountains_ACR","Takistan Mountains"
call:copyMapFile "Sara_dbe1","United Sahrani"
call:copyMapFile "utes","Utes"
call:copyMapFile "VR","Virtual Reality"
call:copyMapFile "Vostok_w","Vostok Winter"
call:copyMapFile "xcam_prototype","XCAM PROTOTYPE"
call:copyMapFile "Zargabad","Zargabad"

echo .
echo ....................
echo ....................
echo Finished Copying
echo ....................
echo ....................
pause

:copyMapFile
XCOPY ..\..\"%ParentDir%" ..\..\"%fileName%"."%~1" /E /I /D /Y /V /Q /EXCLUDE:exclude.txt
echo %~2 (%~1) Copied
echo ....................

GOTO:EOF