@echo off
title BigGuard-Analytics: Large-Scale BDA Demonstration
color 0B

echo ==============================================================================
echo        BIGGUARD-ANALYTICS: DISTRIBUTED NETWORK INTRUSION ANALYSIS
echo                        BIG DATA ANALYTICS (BDA)
echo ==============================================================================
echo.
echo Select Dataset Scale to Execute:
echo   [1] Fast Demo Chunk    -- 25,000 Records     (~6 MB,   Takes ~2 seconds)
echo   [2] Medium Stress Test -- 200,000 Records    (~45 MB,  Takes ~5 seconds)
echo   [3] Large-Scale Slice  -- 1,754,103 Records  (~400 MB, Takes ~13 seconds)
echo   [4] 5GB Big Data Scale -- 22,803,315 Records (~5.0 GB, Takes ~45-60 seconds)
echo.
set /p choice="Enter choice [1, 2, 3, or 4] (Default is 4): "

if "%choice%"=="" set choice=4
if "%choice%"=="1" goto run
if "%choice%"=="2" goto run
if "%choice%"=="3" goto run
if "%choice%"=="4" goto run

echo Invalid choice, defaulting to 5GB Big Data Dataset [4]...
set choice=4

:run
echo.
echo ==============================================================================
echo Launching Analytics on Option [%choice%]...
echo ==============================================================================
echo.

python "D:\BDA\run_demo_queries.py" %choice%

echo.
echo ==============================================================================
echo   Demonstration Completed Successfully!
echo ==============================================================================
pause
