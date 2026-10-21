# Sentinela
### Sistema Inteligente de Prevenção de Churn Bancário – Aura Bank

Projeto desenvolvido no Hackathon de Dados do programa **ELASTECH+** (trilha de
dados, com seleção de participantes), em equipe de cinco pessoas.

**Minha atuação:** modelagem preditiva, análise de dados, arquitetura da solução
e construção dos painéis em Power BI.

![Painel da Diretoria](power%20bi/painel_diretoria.png)

## O problema
O Aura Bank (banco fictício) perde 1 em cada 4 clientes por cancelamento:
249 de 1.000 clientes, ou seja, 24,9%. Com receita média de R$ 150 por cliente
por mês, isso representa **R$ 448.200 de receita anual em risco**
(249 × R$ 150 × 12).

O objetivo é identificar esses clientes **antes** que o cancelamento aconteça,
para o time de retenção agir a tempo.

## Sobre os dados
Não havia dados reais disponíveis, então a base foi **simulada** no próprio
notebook (`np.random.seed(42)`, 1.000 clientes). O churn foi gerado a partir de
regras de negócio: saldo abaixo de R$ 1.000, menos de 5 transações, reclamação
recente, apenas 1 produto contratado e score abaixo de 500 aumentam a
probabilidade de cancelamento.

Por isso, o modelo funciona como **prova de conceito**: ele mostra o fluxo
completo (dados → análise → modelo → painel) e recupera os padrões que foram
embutidos na simulação. Com dados reais, as métricas seriam outras.

## Principais achados
| Faixa de saldo | Clientes | Cancelaram | Taxa de churn |
|---|---:|---:|---:|
| Baixo (até R$ 1 mil) | 299 | 131 | **43,8%** |
| Médio (R$ 1 mil a 3 mil) | 333 | 53 | 15,9% |
| Alto (R$ 3 mil a 6 mil) | 225 | 41 | 18,2% |
| Premium (acima de R$ 6 mil) | 143 | 24 | 16,8% |

Quem cancela tem, em média, saldo menor (R$ 2.197 contra R$ 3.254), menos
transações (21,5 contra 24,9) e menos produtos contratados (2,8 contra 3,1).

## Modelo
Três versões foram comparadas no mesmo conjunto de teste (200 clientes, 50 que
cancelaram). A métrica principal é o **recall da classe "Cancelou"**: deixar
de detectar um cliente que vai sair custa mais caro do que acionar a retenção
para um cliente que ficaria.

| Versão | Modelo | Acurácia | Recall (Cancelou) | Precisão (Cancelou) | Cancelamentos não detectados | Status |
|---|---|---:|---:|---:|---:|---|
| V1 | Regressão logística | 77% | 36% | 56% | 32 | Descartada |
| **V2** | **Regressão logística balanceada** | **71%** | **66%** | **45%** | **17** | **Escolhida** |
| V3 | Random Forest balanceado | 76% | 22% | 52% | 39 | Descartada |

A V2 perde um pouco de acurácia, mas detecta quase o dobro de cancelamentos em
relação à V1.

**Próximos passos:** validação cruzada, curva ROC/AUC, ajuste do limiar de
decisão de acordo com o custo da ação de retenção e teste com dados reais.

![Painel do Analista](power%20bi/painel_analista.png)

## Tecnologias
Python (pandas, scikit-learn, matplotlib, seaborn) | SQL (SQLite) | Power BI

## Estrutura
- `notebooks/sentinela_eda_ml.ipynb` → geração dos dados, análise exploratória, queries SQL e os três modelos
- `sql/queries_insights.sql` → as três queries de insight, prontas para rodar
- `data/clientes_banco.csv` → base simulada com 1.000 clientes
- `docs/` → documento de arquitetura da solução
- `power bi/sentinela_paineis.pbix` → painéis da Diretoria e do Analista (versão final)
- `Sentinela_Apresentacao.pptx` → apresentação do hackathon

## Como executar
```bash
pip install -r requirements.txt
jupyter notebook notebooks/sentinela_eda_ml.ipynb
```
O notebook foi criado no Google Colab, mas roda em qualquer ambiente Jupyter.
