# Olist 电商经营分析

基于 Olist 巴西电商 9 表数据集（约 10 万订单），用 MySQL 完成业务指标计算，Python 做 Cohort 留存分析，Tableau 制作交互式仪表板。

## 业务问题

1. 销售大盘与增长趋势如何？
2. 用户价值如何分层？复购情况怎样？
3. 哪些品类贡献最大？结构如何？
4. 物流体验是否是短板？延迟交付与差评的关系？

## 数据与工具

- 数据：Kaggle Olist Brazilian E-Commerce（9 张表）
- 工具：MySQL（建库建表、复杂 SQL）、Python（pandas/cohort）、Tableau（仪表板）

## 核心发现

- 有效订单 98,199 单，总 GMV 约 1,573 万，平均客单价 160.24
- 复购率仅 3.04%，96.96% 客户为一次性购买，核心复购用户仅约 1%
- 品类呈三层结构：health_beauty（量价平衡）、watches_gifts（高单价）、bed_bath_table（引流）
- 延迟率 8.11%，延迟订单差评率 54.03%（准时仅 9.23%），物流是体验最大短板

## Tableau 仪表板

- 可交互源文件：`tableau/Olist_Analysis.twbx`
- 打开方式：下载后用 Tableau Reader（免费）或 Tableau Desktop 打开，可查看两个仪表板并交互筛选
- 仪表板内容：
  - 经营概览：月度 GMV 趋势（2017-11 黑五峰值 117 万）+ 品类 Top 15 销售额与均价
  - 用户价值与物流体验：RFM 七分层客户数与金额对比 + 延迟/准时交付的评分与差评率对比


## 项目结构

```

├── sql\\

│   ├── schema.sql

│   ├── 01\_sales\_overview.sql

│   ├── 02\_rfm.sql

│   ├── 03\_category.sql

│   └── 04\_logistics.sql

├── python\\

│   ├── cohort\_retention.ipynb

│   ├── cohort\_retention.png        

│   └── export\_tableau\_data.ipynb

├── tableau\\

│   └── Olist\_Analysis.twbx

├── notes.md

├── README.md

└── .gitignore

```



## 技术栈

MySQL、Python（Pandas / Matplotlib / Seaborn）、Tableau

