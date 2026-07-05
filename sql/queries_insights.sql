QUERY 1 — Taxa de churn por faixa de saldo
Objetivo: Identificar quais faixas de saldo
concentram maior risco de cancelamento

SELECT
    CASE
        WHEN saldo_medio < 1000 THEN 'Baixo (ate 1k)'
        WHEN saldo_medio < 3000 THEN 'Medio (1k-3k)'
        WHEN saldo_medio < 6000 THEN 'Alto (3k-6k)'
        ELSE 'Premium (6k+)'
    END AS faixa_saldo,
    COUNT(*) AS total_clientes,
    SUM(churn) AS total_churn,
    ROUND(AVG(churn) * 100, 1) AS taxa_churn_pct
FROM clientes
GROUP BY faixa_saldo
ORDER BY taxa_churn_pct DESC;


QUERY 2 — Perfil medio: ficou vs cancelou
Objetivo: Comparar caracteristicas dos grupos
para identificar padroes de comportamento

SELECT
    CASE WHEN churn = 1
         THEN 'Cancelou'
         ELSE 'Ficou'
    END AS perfil,
    COUNT(*) AS total_clientes,
    ROUND(AVG(idade), 1) AS idade_media,
    ROUND(AVG(saldo_medio), 2) AS saldo_medio,
    ROUND(AVG(score_credito), 1) AS score_medio,
    ROUND(AVG(num_transacoes), 1) AS transacoes_media,
    ROUND(AVG(produtos_contratados), 1) AS produtos_medio
FROM clientes
GROUP BY churn;


QUERY 3 — Top 10 clientes em alto risco
Objetivo: Identificar clientes prioritarios
para acao imediata de retencao

SELECT
    cliente_id,
    idade,
    ROUND(saldo_medio, 2) AS saldo,
    score_credito,
    num_transacoes,
    produtos_contratados,
    reclamacao_recente,
    canal_preferido
FROM clientes
WHERE saldo_medio < 1000
AND reclamacao_recente = 1
AND score_credito < 500
ORDER BY saldo_medio ASC
LIMIT 10;