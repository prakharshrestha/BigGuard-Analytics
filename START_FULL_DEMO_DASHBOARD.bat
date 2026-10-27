@echo off
title BigGuard-Analytics: Master Demonstration Launcher
color 0B

echo ==============================================================================
echo        BIGGUARD-ANALYTICS: DISTRIBUTED BDA MASTER DEMO LAUNCHER
echo              HDFS [Storage] + YARN [Compute] + HiveQL [Analytics]
echo ==============================================================================
echo.

set HADOOP_HOME=D:\BDA\hadoop
set JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-8.0.504.1-hotspot
set PYTHON_DIR=C:\Users\ASUS\AppData\Local\Programs\Python\Python312
set PATH=%HADOOP_HOME%\bin;%HADOOP_HOME%\sbin;%JAVA_HOME%\bin;%PYTHON_DIR%;%PYTHON_DIR%\Scripts;%PATH%

echo [1/4] Checking and starting Hadoop Cluster Daemons...

"%JAVA_HOME%\bin\jps.exe" | findstr /i "NameNode" >nul
if errorlevel 1 (
    echo   - Starting NameNode on port 9870...
    start "NameNode" "%HADOOP_HOME%\bin\hdfs.cmd" namenode
) else (
    echo   - NameNode is already running.
)

"%JAVA_HOME%\bin\jps.exe" | findstr /i "DataNode" >nul
if errorlevel 1 (
    echo   - Starting DataNode on port 9866...
    start "DataNode" "%HADOOP_HOME%\bin\hdfs.cmd" datanode
) else (
    echo   - DataNode is already running.
)

"%JAVA_HOME%\bin\jps.exe" | findstr /i "ResourceManager" >nul
if errorlevel 1 (
    echo   - Starting YARN ResourceManager on port 8088...
    start "ResourceManager" "%HADOOP_HOME%\bin\yarn.cmd" resourcemanager
) else (
    echo   - YARN ResourceManager is already running.
)

echo.
echo [2/4] Waiting for services to initialize...
ping -n 4 127.0.0.1 >nul

echo.
echo [3/4] Opening Web Dashboards in your default browser:
echo   - HDFS Web Console:   http://localhost:9870/explorer.html
echo   - YARN Web Console:   http://localhost:8088/cluster/apps
echo   - BigGuard Dashboard: http://localhost:8501
start "" "http://localhost:9870/explorer.html#/user/hive/warehouse/bigguard_db.db/network_flows_analysis"
start "" "http://localhost:8088/cluster/apps"

echo.
echo [4/4] Launching BigGuard Unified Analytics Dashboard on http://localhost:8501 ...
echo ==============================================================================
echo Keep this terminal open while presenting your project.
echo ==============================================================================
echo.

if exist "%PYTHON_DIR%\python.exe" (
    "%PYTHON_DIR%\python.exe" -m streamlit run "D:\BDA\app.py" --server.port 8501 --server.headless false
) else (
    python -m streamlit run "D:\BDA\app.py" --server.port 8501 --server.headless false
)

pause
