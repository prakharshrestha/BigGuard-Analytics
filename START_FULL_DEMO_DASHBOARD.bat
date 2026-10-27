@echo off
title BigGuard-Analytics: Master Demonstration Launcher
color 0B

echo ==============================================================================
echo        BIGGUARD-ANALYTICS: DISTRIBUTED BDA MASTER DEMO LAUNCHER
echo              HDFS (Storage) + YARN (Compute) + HiveQL (Analytics)
echo ==============================================================================
echo.

set HADOOP_HOME=D:\BDA\hadoop
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-8.0.504.1-hotspot
set PATH=%HADOOP_HOME%\bin;%HADOOP_HOME%\sbin;%JAVA_HOME%\bin;%PATH%

echo [1/4] Checking & Starting Hadoop Cluster Daemons...
tasklist /FI "WINDOWTITLE eq NameNode" 2>NUL | find /I /N "cmd.exe">NUL
if "%ERRORLEVEL%"=="1" (
    echo   - Starting NameNode (Port 9870)...
    start "NameNode" "%HADOOP_HOME%\bin\hdfs.cmd" namenode
)

tasklist /FI "WINDOWTITLE eq DataNode" 2>NUL | find /I /N "cmd.exe">NUL
if "%ERRORLEVEL%"=="1" (
    echo   - Starting DataNode (Port 9866)...
    start "DataNode" "%HADOOP_HOME%\bin\hdfs.cmd" datanode
)

tasklist /FI "WINDOWTITLE eq ResourceManager" 2>NUL | find /I /N "cmd.exe">NUL
if "%ERRORLEVEL%"=="1" (
    echo   - Starting YARN ResourceManager (Port 8088)...
    start "ResourceManager" "%HADOOP_HOME%\bin\yarn.cmd" resourcemanager
)

echo.
echo [2/4] Waiting 6 seconds for Hadoop Daemons to initialize...
ping -n 7 127.0.0.1 >nul

echo.
echo [3/4] Opening Web Dashboards in your default browser:
echo   - [HDFS Browser] http://localhost:9870/explorer.html
echo   - [YARN UI]      http://localhost:8088/cluster/apps
echo   - [BDA Dashboard] http://localhost:8501
start "" "http://localhost:9870/explorer.html#/user/hive/warehouse/bigguard_db.db/network_flows_analysis"
start "" "http://localhost:8088/cluster/apps"

echo.
echo [4/4] Launching BigGuard Unified Analytics Dashboard on http://localhost:8501 ...
echo ==============================================================================
echo Keep this terminal open while presenting your project.
echo ==============================================================================
echo.

python -m streamlit run "D:\BDA\app.py" --server.port 8501 --server.headless false

pause
