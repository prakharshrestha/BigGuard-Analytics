-- ==============================================================================
-- BigGuard-Analytics: Apache Hive Table Definitions
-- Target Dataset: UNSW-NB15 Network Intrusion Detection Dataset
-- Table: network_flows_analysis
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS bigguard_db;
USE bigguard_db;

DROP TABLE IF EXISTS network_flows_analysis;

CREATE EXTERNAL TABLE IF NOT EXISTS network_flows_analysis (
    srcip           STRING          COMMENT 'Source IP address',
    sport           INT             COMMENT 'Source port number',
    dstip           STRING          COMMENT 'Destination IP address',
    dsport          INT             COMMENT 'Destination port number',
    proto           STRING          COMMENT 'Transaction protocol (e.g., tcp, udp)',
    state           STRING          COMMENT 'State and its dependent protocol',
    dur             DOUBLE          COMMENT 'Record total duration in seconds',
    sbytes          BIGINT          COMMENT 'Source to destination transaction bytes',
    dbytes          BIGINT          COMMENT 'Destination to source transaction bytes',
    sttl            INT             COMMENT 'Source to destination time to live value',
    dttl            INT             COMMENT 'Destination to source time to live value',
    sloss           BIGINT          COMMENT 'Source packets retransmitted or dropped',
    dloss           BIGINT          COMMENT 'Destination packets retransmitted or dropped',
    service         STRING          COMMENT 'Application service (e.g., http, dns, ftp)',
    sload           DOUBLE          COMMENT 'Source bits per second',
    dload           DOUBLE          COMMENT 'Destination bits per second',
    spkts           BIGINT          COMMENT 'Source to destination packet count',
    dpkts           BIGINT          COMMENT 'Destination to source packet count',
    swin            INT             COMMENT 'Source TCP window advertisement value',
    dwin            INT             COMMENT 'Destination TCP window advertisement value',
    stcpb           BIGINT          COMMENT 'Source TCP base sequence number',
    dtcpb           BIGINT          COMMENT 'Destination TCP base sequence number',
    smeansz         DOUBLE          COMMENT 'Mean of the packet size transmitted by src',
    dmeansz         DOUBLE          COMMENT 'Mean of the packet size transmitted by dst',
    trans_depth     INT             COMMENT 'Pipelined depth into the connection of http request/response',
    res_bdy_len     BIGINT          COMMENT 'Actual uncompressed content size of the data transferred from server',
    sjit            DOUBLE          COMMENT 'Source jitter (mSec)',
    djit            DOUBLE          COMMENT 'Destination jitter (mSec)',
    stime           BIGINT          COMMENT 'Record start time (Unix epoch seconds)',
    ltime           BIGINT          COMMENT 'Record last time (Unix epoch seconds)',
    sintpkt         DOUBLE          COMMENT 'Source inter-packet arrival time (mSec)',
    dintpkt         DOUBLE          COMMENT 'Destination inter-packet arrival time (mSec)',
    tcprtt          DOUBLE          COMMENT 'TCP connection setup round-trip time',
    synack          DOUBLE          COMMENT 'TCP connection setup time from SYN to SYN_ACK',
    ackdat          DOUBLE          COMMENT 'TCP connection setup time from SYN_ACK to ACK',
    is_sm_ips_ports INT             COMMENT 'Source and destination IP and ports equal: 1 if yes, 0 otherwise',
    ct_state_ttl    INT             COMMENT 'No. for each state according to a specific range of values for source/destination TTL',
    ct_flw_http_mthd INT            COMMENT 'No. of flows that has methods such as Get and Post in http',
    is_ftp_login    INT             COMMENT 'If the ftp session is accessed by user and password: 1 if yes, 0 otherwise',
    ct_ftp_cmd      INT             COMMENT 'No of flows that has a command in ftp session',
    ct_srv_src      INT             COMMENT 'No. of connections that contain the same service and source address',
    ct_srv_dst      INT             COMMENT 'No. of connections that contain the same service and destination address',
    ct_dst_ltm      INT             COMMENT 'No. of connections of the same destination address in 100 records',
    ct_src_ltm      INT             COMMENT 'No. of connections of the same source address in 100 records',
    ct_src_dport_ltm INT            COMMENT 'No. of connections of the same source address and the destination port in 100 records',
    ct_dst_sport_ltm INT            COMMENT 'No. of connections of the same destination address and the source port in 100 records',
    ct_dst_src_ltm  INT             COMMENT 'No. of connections of the same source and destination address in 100 records',
    attack_cat      STRING          COMMENT 'Name of each attack category',
    label           INT             COMMENT '0 for normal and 1 for attack records'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/bigguard_db.db/network_flows_analysis'
TBLPROPERTIES (
    "skip.header.line.count"="1",
    "serialization.null.format"=""
);
