<<<<<<< HEAD
Delivery Analytics SQL Project 🚚📊

Projeto de análise de dados ponta a ponta utilizando PostgreSQL, simulando uma operação real de delivery inspirada em plataformas como Zé Delivery / marketplaces de entrega.

O projeto foi desenvolvido com foco em:

modelagem analítica;
SQL aplicado a negócio;
métricas operacionais;
qualidade de dados;
storytelling com dados;
construção de portfólio para vagas de Dados / Analytics / Ciência de Dados

📌 Objetivo do Projeto

Construir um pipeline analítico completo utilizando SQL, desde a ingestão dos dados até a geração de insights operacionais e executivos.

O projeto busca demonstrar capacidade de:

✅ Estruturar dados em ambiente analítico
✅ Trabalhar com modelagem dimensional (Data Warehouse)
✅ Criar métricas de negócio
✅ Realizar análises operacionais com SQL avançado
✅ Identificar problemas operacionais através de dados
✅ Traduzir dados em insights acionáveis


🧠 Contexto de Negócio

O dataset representa uma operação de delivery contendo:

- pedidos;
- pagamentos;
- entregas;
- hubs logísticos;
- canais de venda;
- drivers;
- métricas de SLA e tempo operacional.

A proposta foi analisar:

-performance operacional;
- receita;
- comportamento logístico;
- cancelamentos;
- impacto do tempo de entrega;
- eficiência por estado, canal e modal de entrega.


🛠️ Tecnologias Utilizadas

Banco de Dados
PostgreSQL
pgAdmin
Linguagem
SQL
Visualização
Power BI
Conceitos Aplicados
Data Warehouse
Star Schema
Data Quality
Window Functions
Percentile Functions
KPI Analytics
Storytelling with Data


🏗️ Estrutura do Projeto
projeto-delivery-sql/
│
├── data/
│   └── raw/
│       ├── orders.csv
│       ├── deliveries.csv
│       ├── payments.csv
│       ├── stores.csv
│       ├── hubs.csv
│       ├── channels.csv
│       └── drivers.csv
│
├── sql/
│   ├── 00_schemas.sql
│   ├── 01_raw_tables.sql
│   ├── 02_dimensions.sql
│   ├── 03_facts.sql
│   ├── 04_views.sql
│   ├── 05_quality_checks.sql
│   └── 06_portfolio_queries.sql
│
├── docs/
│   ├── dashboard_prints/
│   └── power_bi/
│
└── README.md


🗂️ Arquitetura Analítica

Camada RAW

Importação dos arquivos CSV originais sem transformação estrutural.

Tabelas RAW
raw.orders
raw.deliveries
raw.payments
raw.stores
raw.hubs
raw.channels
raw.drivers
Data Warehouse (DW)
Dimensões
dw.dim_store
dw.dim_hub
dw.dim_channel
dw.dim_driver

Fatos
dw.fact_orders
dw.fact_deliveries
dw.fact_payments

Camada Analytics

Principais Views
analytics.vw_order_360
analytics.vw_kpi_daily
analytics.vw_kpi_by_state
analytics.vw_kpi_by_channel
analytics.vw_cancel_vs_cycle


📊 Principais Análises Desenvolvidas

📈 KPIs Executivos
- GMV
- Volume de pedidos
- Ticket médio
- Taxa de cancelamento
- SLA operacional

🚚 Operação Logística
- Relação entre distância e tempo de entrega
- Performance por modal de entrega
- Tempo médio por estado
- P90 de cycle time
- Ranking de hubs críticos
❌ Cancelamentos

Análise da relação entre:

tempo de entrega;
SLA operacional;
distância;
cancelamentos.

Principal Insight

Aumento no cancelamento de pedidos até 120 minutos 


💳 Pagamentos

Volume por método de pagamento
Distribuição de status
Taxa de aprovação
Análise de chargeback


📱 Canais de Venda

Comparação entre:

marketplaces;
canais próprios;
ticket médio;
volume de receita.
Principal Insight

Marketplaces concentram volume, enquanto canais próprios apresentam maior ticket médio.

📌 Insights Obtidos

Operação
São Paulo concentra maior GMV e volume operacional, porém apresenta maior tempo médio de entrega.
Estados com menor densidade operacional apresentaram melhor SLA médio.

Logística
Motoboys concentram a maior parte das entregas.
Bikers atuam majoritariamente em entregas de curta distância.
Receita

Marketplaces geram maior volume.
Canais próprios apresentam maior monetização por pedido.

Cancelamentos
O aumento do cycle time impacta diretamente a taxa de cancelamento.


🧪 Qualidade de Dados

Foram realizadas validações como:

registros órfãos;
deliveries sem pedidos;
payments sem correspondência;
stores sem hubs;
análise de nulos;
tratamento de outliers operacionais.


📊 Dashboard (Power BI)

O projeto inclui dashboard executivo desenvolvido em Power BI com foco em:

storytelling;
KPIs operacionais;
análise executiva;
visualização analítica.
Estrutura do Dashboard
Executive Overview
Operations & SLA
Revenue & Channels


🚀 Como Executar o Projeto

1. Criar banco PostgreSQL

Exemplo:

CREATE DATABASE delivery_dw;
2. Executar scripts SQL na ordem
00_schemas.sql
01_raw_tables.sql
3. Importar arquivos CSV

Importar os arquivos da pasta:

data/raw/

Utilizando:

pgAdmin → Import/Export Data
4. Executar restante dos scripts
02_dimensions.sql
03_facts.sql
04_views.sql
05_quality_checks.sql
06_portfolio_queries.sql


📚 Aprendizados Técnicos

Durante o desenvolvimento deste projeto foram aplicados conceitos como:

modelagem dimensional;
SQL analítico;
CTEs;
Window Functions;
Percentile Functions;
agregações;
data quality;
construção de KPIs;
visualização analítica;
storytelling com dados.


🎯 Próximos Passos

Evoluir para análises preditivas;
Criar modelos de previsão de SLA;
Desenvolver modelos de previsão de cancelamento;
Implementar pipeline automatizado;
Adicionar camada de machine learning.


👨‍💻 Sobre Mim

Profissional em transição para a área de Dados, com experiência corporativa e foco em:

análise de dados;
analytics;
SQL;
inteligência de negócio;
ciência de dados.

Este projeto faz parte da construção do meu portfólio prático voltado para oportunidades em:

Data Analytics;
Business Intelligence;
Ciência de Dados.


🔗 Contato

LinkedIn
linkedin.com/in/ivan-rufino-data

=======
# Delivery Analytics Project

## 📌 Overview

SQL and Power BI project focused on delivery operations analytics, inspired by marketplace and logistics business models such as Zé Delivery and Ambev operations.

The project includes:
- dimensional modeling
- ETL process in PostgreSQL
- analytical SQL queries
- operational KPIs
- Power BI dashboard
- business insights focused on logistics and cancellations

---

## 🛠️ Tech Stack

- PostgreSQL
- SQL
- Power BI
- Git & GitHub

---

## 📊 Dashboard Preview

### Executive Overview

![Executive Overview](dashboard/executive_overview.png)

---

## 📂 Project Structure

```text
delivery-analytics-project/
│
├── data/
├── sql/
├── dashboard/
├── README.md
└── .gitignore
```

---

## 📈 Key Business Insights

- SP concentrates the highest GMV but also presents the longest delivery cycle times.
- Marketplace channels drive revenue volume.
- Proprietary channels present higher average ticket values.
- Cancellation rates increase significantly as delivery cycle time grows.

---

## 🚚 Operational Analysis

The project investigates the relationship between:
- delivery time
- cancellation rates
- logistics performance
- state operational efficiency
- channel monetization

---

## 📦 Dataset

Public delivery dataset available on Kaggle.

Used for educational and portfolio purposes only.

---

## 🚀 Future Improvements

- Machine Learning models for cancellation prediction
- Delivery SLA forecasting
- Customer segmentation
- Operational anomaly detection
>>>>>>> 2288bba (Update project structure, README and dashboard)
