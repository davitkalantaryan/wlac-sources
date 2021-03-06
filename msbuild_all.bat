::
:: File:			msbuild_all.bat
:: Created on:		2020 Jul 24
:: Autor:			Davit Kalantaryan (davit.kalantaryan@desy.de)
::
:: Purpose:	
::
:: Argumets: 
::

@ECHO off
SETLOCAL EnableDelayedExpansion

:: here we define default platformtarget to build, platforms are following
:: other platforms should be provided as first argument
:: ARM, ARM64, x86, x64
set PlatformTarget=x64
set Configuration=Debug
set ActionConfirm=Build

set scriptName=%0
SET scriptDirectory=%~dp0
set currentDirectory=%cd%

:: handling arguments
::set argC=0
::for %%x in (%*) do Set /A argC+=1
set nextArg=%scriptName%
for %%x in (%*) do (
	if /i "%%x"=="help" (
		call :call_help
		exit /b 0
	)
	set nextArg=%%x
	call :parse_argument
	if not "!ERRORLEVEL!"=="0" (exit /b %ERRORLEVEL%)
)

echo action=%ActionConfirm%,platform=%PlatformTarget%,configuration=%Configuration%


rem msbuild %scriptDirectory%prj\rfc\remote_function_call_false_without_lib_vs\remote_function_call_false_without_lib.sln /t:!ActionConfirm! /p:Configuration=!Configuration! /p:Platform=!PlatformTarget!
rem msbuild %scriptDirectory%prj\rfc\rfc_vs\rfc.sln /t:!ActionConfirm! /p:Configuration=!Configuration! /p:Platform=!PlatformTarget!
rem msbuild %scriptDirectory%prj\wlac\wlac_vs\wlac.sln /t:!ActionConfirm! /p:Configuration=!Configuration! /p:Platform=!PlatformTarget!
rem msbuild %scriptDirectory%prj\usergroupid\usergroupid_vs\usergroupid.sln /t:!ActionConfirm! /p:Configuration=!Configuration! /p:Platform=!PlatformTarget!
msbuild %scriptDirectory%\workspaces\wlac2-all_vs\wlac2-all.sln /t:!ActionConfirm! /p:Configuration=!Configuration! /p:Platform=!PlatformTarget!

exit /b !ERRORLEVEL!

:parse_argument
	set isNextArgPlatform=true
	if /i not "!nextArg!"=="ARM" if /i not "!nextArg!"=="ARM64" if /i not "!nextArg!"=="x86" if /i not "!nextArg!"=="x64" (set isNextArgPlatform=false)
	if "!isNextArgPlatform!"=="true" (set PlatformTarget=!nextArg!) else (
		set isNextArgAction=true
		if /i not "!nextArg!"=="Build" if /i not "!nextArg!"=="Rebuild" if /i not "!nextArg!"=="Clean" (set isNextArgAction=false)
		if "!isNextArgAction!"=="true" (set ActionConfirm=!nextArg!) else (
			set isNextArgConfiguration=true
			if /i not "!nextArg!"=="Debug" if /i not "!nextArg!"=="Release" (set isNextArgConfiguration=false)
			if "!isNextArgConfiguration!"=="true" (set Configuration=!nextArg!) else (
				echo Unknown argument !nextArg!.
				call :call_help
				exit /b 1
			)
		)		
	)

	exit /b 0

:call_help
	echo Valid platforms are ARM, ARM64, x86 and x64. Using defalt x64.
	echo Valid configurations are Debug and Release. Using default Debug.
	echo Valid actions are Build, Rebuild and Clen. Using default Build.
	echo Call !scriptName! help to displaye help message
	exit /b 0

ENDLOCAL
