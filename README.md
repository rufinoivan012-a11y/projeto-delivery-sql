# Projeto Delivery SQL Analytics (PostgreSQL) — Portfólio

Projeto de ponta a ponta em **PostgreSQL** simulando um cenário real de delivery (estilo Zé Delivery):
**ingestão de CSV → camada RAW → Data Warehouse → camada Analytics → queries de portfólio**.

> Objetivo: demonstrar domínio de **SQL**, modelagem dimensional, análise exploratória e validação de dados
com foco em uma vaga de **Cientista de Dados / Analytics**.

---

## 👨‍💻 Sobre mim (objetivo)
Sou estudante de **Ciência de Dados** e estou construindo meu portfólio para minha **primeira oportunidade** na área.
Este projeto foi desenhado para evidenciar capacidade de:
- Estruturar dados (ETL/ELT)
- Modelagem dimensional (DW)
- SQL analítico (window functions, percentis, CTEs)
- Qualidade e consistência (data checks)
- Geração de insights de negócio (KPIs e operação)

---

## 🧰 Tecnologias
- PostgreSQL
- pgAdmin
- SQL (CTEs, Window Functions, Percentiles, Aggregations)

---

## 📦 Dataset (camadas e tabelas)
### Arquivos CSV (camada RAW)
- `orders.csv` (~436k registros importados)
- `deliveries.csv`
- `payments.csv`
- `stores.csv`
- `hubs.csv`
- `channels.csv`
- `drivers.csv`

### Modelagem (DW)
**Dimensões**
- `dw.dim_date`
- `dw.dim_store`
- `dw.dim_hub`
- `dw.dim_channel`
- `dw.dim_driver`

**Fatos**
- `dw.fact_orders`
- `dw.fact_deliveries`
- `dw.fact_payments`

### Camada Analytics
- `analytics.vw_order_360` (visão consolidada)
- views de KPI e queries finais no arquivo `06_portfolio_queries.sql`

---

## 🗺️ Arquitetura do projeto (pipeline)
1. **RAW**: tabelas espelho dos CSVs
2. **DW**: modelo dimensional (star schema)
3. **Analytics**: view 360 + KPIs + queries de portfólio
4. **Quality checks**: integridade e registros órfãos

---

## ✅ Como executar o projeto (passo a passo)
### 1) Criar banco
Crie um banco no PostgreSQL (ex.: `delivery_dw`) e abra o Query Tool no pgAdmin.

### 2) Rodar scripts SQL (na ordem)
Execute os arquivos da pasta `sql/` nesta ordem:

1. `00_schemas.sql`
2. `01_raw_tables.sql`
3. **Importar os CSVs** (pgAdmin: Import/Export Data → Import)
4. `02_dimensions.sql`
5. `03_facts.sql`
6. `04_views.sql`
7. `05_quality_checks.sql`
8. `06_portfolio_queries.sql`

### 3) Import dos CSVs (pgAdmin)
- Format: `csv`
- Header: ON
- Delimiter: `,`
- Quote/Escape: `"`

**Obs (real case):**
Em `stores.csv` pode haver problema de encoding. Se ocorrer erro de UTF-8,
importe selecionando `LATIN1` ou `WIN1252` no campo *Encoding* do pgAdmin.

---

## 📊 Principais análises (portfólio)
As queries finais estão em: `sql/06_portfolio_queries.sql`.

Destaques:
- Painel executivo (GMV, ticket médio, cancelamentos)
- Série diária com variação (LAG / DoD)
- Pareto / Top lojas por GMV + share
- Segmentos e estados com SLA (P90 cycle time)
- Ranking de hubs (pior P90)
- Pagamentos por método e status (`PAID`, `AWAITING`, `ACHARGEBACK`)
- Distância vs tempo por faixas (bins)
- Performance por tipo/modal de driver
- Margem de delivery (fee vs cost)

---

## 🧪 Qualidade de dados (Data Quality)
O script `05_quality_checks.sql` inclui verificações como:
- stores sem hub
- deliveries sem pedidos
- payments sem pedidos
- validação de chaves e integridade referencial

---

## 🧠 Insights e limitações do dataset
- `payment_status` possui os valores: `PAID`, `AWAITING`, `ACHARGEBACK`.
- Alguns arquivos podem apresentar encoding diferente de UTF-8 (tratado no processo de import).
- Algumas dimensões podem conter valores nulos (ex.: driver ausente), e foram tratados nas análises.

---
## 📌 Key Business Insights

Based on the exploratory analysis:

## 📍 Geographic performance

São Paulo concentrates the highest order volume and GMV, however it also presents the longest average delivery cycle time (~165 minutes).

Southern states (RS and PR) show significantly better SLA performance, with lower average cycle times, suggesting operational efficiency in lower-density markets.

## 📱 Channel strategy

- Marketplace channels (especially FOOD PLACE) drive most of the volume and revenue.

- Own channels (e.g., CHOCO PLACE, OTHER PLACE, LISBON PLACE) present substantially higher average ticket values, indicating stronger monetization despite lower volume.

This suggests a typical growth pattern:

- Marketplaces act as acquisition channels.

- Proprietary channels maximize revenue per order.

## 🚚 Logistics

- Motoboys handle the majority of deliveries with average distances around 3–4 km.

- Bikers are primarily used for short-distance deliveries (~1 km), confirming modal specialization.

- Records with missing driver information and extreme distances were excluded from operational performance metrics.

## 💳 Payments

- Payment approval was derived from payment_status = 'PAID'.

- No effective chargeback events were observed in completed orders.

- Payment methods show strong concentration in online and voucher-based transactions.

## ⚠️ Dataset limitations

- No customer-level information was available (no cohort or retention analysis).

- Chargeback status exists but is not associated with completed orders.

- Some deliveries contain missing driver attributes and outlier distances.

These limitations were handled via filtering and documented in the analysis.

## 🚀 Next steps

- Build a Power BI dashboard for KPIs and SLA monitoring.

- Feature engineering by hub, store and channel for ML models.

- Predict delivery cycle time and cancellation probability.

---
## 📦 Dataset

Dataset publicly available on Kaggle.

Source: Kaggle Delivery Dataset  
Used for educational and portfolio purposes only.

All credits to the original author.

---

## 📬 Contato
Se quiser falar comigo:
- LinkedIn: https://www.linkedin.com/in/ivan-rufino-6b90173ab/

  
