# BigGuard-Analytics: Large-Scale Network Intrusion & Flow Analytics

BigGuard-Analytics is a distributed Big Data analytics framework designed to ingest, process, and perform deep behavioral profiling on massive network flow traces using **Apache Hadoop (HDFS & YARN)** and **Apache Hive**.

The framework leverages the **UNSW-NB15 dataset** (2.54M+ records, 49 attributes) to extract threat intelligence, identify malicious traffic hotspots, compute connection duration/volume quantiles, evaluate temporal patterns, and isolate protocol vulnerabilities.

---

## 📌 Architecture & Analytics Overview

```text
+-----------------------------------------------------------------+
|                   Data Source: UNSW-NB15 Traces                 |
|              (2.54M+ Network Flows, 49 Features, 9 Attacks)     |
+-----------------------------------------------------------------+
                                │
                                ▼
+-----------------------------------------------------------------+
|               Storage Layer: Hadoop HDFS (HDFS 3.2.0)           |
|            - Distributed block storage                          |
|            - High fault tolerance & multi-node replication      |
+-----------------------------------------------------------------+
                                │
                                ▼
+-----------------------------------------------------------------+
|              Resource Management & Execution: YARN              |
|            - MapReduce distributed job execution                |
|            - Dynamic container & resource orchestration         |
+-----------------------------------------------------------------+
                                │
                                ▼
+-----------------------------------------------------------------+
|               Query Engine: Apache Hive (HiveQL 3.1.3)          |
|    - Schema-on-Read: external table mapping                     |
|    - Window Aggregations, CTEs, & Quantile Approximations       |
+-----------------------------------------------------------------+
                                │
        ┌───────────────────────┼───────────────────────┐
        ▼                       ▼                       ▼
+----------------+      +----------------+      +----------------+
|  Destination   |      |      Flow      |      |     Hourly     |
| Host Profiling |      | Characteristics|      | Activity Trends|
+----------------+      +----------------+      +----------------+
                                │
                                ▼
                        +----------------+
                        |   Protocol &   |
                        | Service Vectors|
                        +----------------+
```

---

## 📁 Repository Structure

```text
BigGuard-Analytics/
├── README.md                                          # Project documentation & runbook
├── .gitignore                                         # Dataset & environment exclusion rules
├── apache_hive_approach/                              # HiveQL distributed analytical queries
│   ├── hive_table_definitions.sql                     # External schema DDL for network_flows_analysis
│   ├── destination_address_analysis.sql               # Top 15 targeted hosts & dominant attack types
│   ├── flow_characteristics.sql                       # Duration & byte transfer quantiles (P50, P95)
│   ├── hourly_activity_query.sql                      # Temporal attack distribution (UTC hourly buckets)
│   └── protocol_and_service_query.sql                 # High-frequency proto/service vulnerability ranking
└── Explanations/                                      # Project documentation & reference reports
    ├── project_analysis.pdf                           # Complete architectural report (PDF)
    └── project_analysis.html                          # Interactive report with visual flowcharts
```

---

## 🔬 Analytical Modules

### 1. Destination Address Profiling (`destination_address_analysis.sql`)
- Pinpoints the **top 15 destination IPs** sustaining the highest attack intensity.
- Uses **Common Table Expressions (CTEs)** and `ROW_NUMBER() OVER (PARTITION BY dstip ORDER BY count DESC)` to classify the dominant attack category per host and quantify attack proportions.

### 2. Flow Characteristics & Quantile Analysis (`flow_characteristics.sql`)
- Profiles connection duration (`dur`) and bidirectional volume (`sbytes + dbytes`) across normal and attack categories.
- Leverages Hive's `PERCENTILE_APPROX(col, ARRAY(0.5, 0.95), 10000)` to accurately capture median (P50) and 95th percentile (P95) behavior without complete data sorting.
- Detects instantaneous / probe connections (`zero_duration_records`).

### 3. Temporal Activity Tracking (`hourly_activity_query.sql`)
- Evaluates temporal threat frequency across capture dates and hourly windows.
- Converts epoch timestamps (`stime`) to UTC calendar date and hour via `FROM_UNIXTIME()`.
- Calculates each hour's contribution to total daily attacks using partition window functions.

### 4. Protocol & Service Vulnerability Mapping (`protocol_and_service_query.sql`)
- Maps attack concentrations across transport protocols (TCP, UDP, etc.) and application services (HTTP, DNS, FTP, etc.).
- Applies statistical significance thresholding (`total_records >= 100`) and computes global attack percentage shares using unbounded window functions `SUM(attack_records) OVER ()`.

---

## ⚙️ Environment & Technical Specifications

| Component | Specification |
| :--- | :--- |
| **Distributed Storage** | Apache Hadoop HDFS 3.2.0 |
| **Cluster Orchestration** | YARN (Yet Another Resource Negotiator) |
| **SQL Engine** | Apache Hive 3.1.3 (HiveQL) |
| **Runtime Engine** | MapReduce on YARN |
| **Runtime Environment** | OpenJDK 1.8.0 / Scala 2.12.18 |
| **Dataset Benchmark** | UNSW-NB15 (~2.54M flow records, 49 features) |

---

## 🚀 Step-by-Step Execution Guide

### 1. Start Hadoop Daemons
Ensure HDFS and YARN daemons are running on the cluster:
```bash
start-dfs.sh
start-yarn.sh

# Verify active services (NameNode, DataNode, ResourceManager, NodeManager)
jps
```

### 2. Provision HDFS Directory & Stage Data
```bash
# Create Hive database directory in HDFS
hdfs dfs -mkdir -p /user/hive/warehouse/bigguard_db.db/network_flows_analysis

# Transfer dataset into HDFS
hdfs dfs -put UNSW-NB15_prepared.csv /user/hive/warehouse/bigguard_db.db/network_flows_analysis/
```

### 3. Create External Hive Table
```bash
hive -f apache_hive_approach/hive_table_definitions.sql
```

### 4. Run Analytical Modules
Execute each HiveQL module against the database:
```bash
# 1. Destination Address Profiling
hive --database bigguard_db -f apache_hive_approach/destination_address_analysis.sql

# 2. Flow Characteristics & Quantiles
hive --database bigguard_db -f apache_hive_approach/flow_characteristics.sql

# 3. Temporal Hourly Distribution
hive --database bigguard_db -f apache_hive_approach/hourly_activity_query.sql

# 4. Protocol & Service Vulnerabilities
hive --database bigguard_db -f apache_hive_approach/protocol_and_service_query.sql
```

---

## 🔮 Roadmap
- **Apache Spark In-Memory Analytics**: Implementation of Spark SQL / DataFrame transformations for ultra-fast iterative computing.
- **Machine Learning**: Integration of Spark MLlib / PySpark for automated intrusion classification.
