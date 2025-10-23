WITH tb_transacao AS (
    SELECT  *,
            SUBSTR(DtCriacao,0,11) AS dtDia
    FROM transacoes
    WHERE dtCriacao < '2025-10-01'
),

tb_agg_transacao AS (
    SELECT  idCliente,
            COUNT( DISTINCT dtDia) AS qtdeAtivacaoVida,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-7 day')  THEN dtDia END) AS qtdeAtivacaoD7,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-14 day') THEN dtDia END) AS qtdeAtivacaoD14,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-28 day') THEN dtDia END) AS qtdeAtivacaoD28,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-56 day') THEN dtDia END) AS qtdeAtivacaoD56,

            COUNT( DISTINCT dtDia) AS qtdeTransacaoVida,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-7 day')  THEN idCliente END) AS qtdeTransacaoD7,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-14 day') THEN idCliente END) AS qtdeTransacaoD14,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-28 day') THEN idCliente END) AS qtdeTransacaoD28,
            COUNT(DISTINCT CASE WHEN dtDia >= date('2025-10-01','-56 day') THEN idCliente END) AS qtdeTransacaoD56,

            SUM(qtdePontos) AS saldoVida,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-7 day')  THEN qtdePontos ELSE 0 END) AS saldoD7,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-14 day') THEN qtdePontos ELSE 0 END) AS saldoD14,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-28 day') THEN qtdePontos ELSE 0 END) AS saldoD28,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-56 day') THEN qtdePontos ELSE 0 END) AS saldoD56,

            SUM(CASE WHEN qtdePontos > 0 THEN qtdePontos ELSE 0 END) AS saldoPosVida,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-7 day')  AND QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS saldoP_D7,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-14 day') AND QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS saldoP_D14,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-28 day') AND QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS saldoP_D28,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-56 day') AND QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS saldoP_D56,

            SUM(CASE WHEN qtdePontos < 0 THEN qtdePontos ELSE 0 END) AS saldoNegVida,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-7 day')  AND QtdePontos < 0 THEN qtdePontos ELSE 0 END) AS saldoN_D7,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-14 day') AND QtdePontos < 0 THEN qtdePontos ELSE 0 END) AS saldoN_D14,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-28 day') AND QtdePontos < 0 THEN qtdePontos ELSE 0 END) AS saldoN_D28,
            SUM(CASE WHEN dtDia >= date('2025-10-01','-56 day') AND QtdePontos < 0 THEN qtdePontos ELSE 0 END) AS saldoN_D56

    FROM tb_transacao
    GROUP BY idCliente 
)

SELECT
        *,
        COALESCE(1. * qtdeTransacaoVida / qtdeAtivacaoVida,0) AS qtdeTransacaoDiaVida,
        COALESCE(1. * qtdeTransacaoD7 / qtdeAtivacaoD7,0) AS qtdeTransacaoDiaVidaD7,
        COALESCE(1. * qtdeTransacaoD14 / qtdeAtivacaoD14,0) AS qtdeTransacaoDiaVidaD14,
        COALESCE(1. * qtdeTransacaoD28 / qtdeAtivacaoD28,0) AS qtdeTransacaoDiaVidaD28,
        COALESCE(1. * qtdeTransacaoD56 / qtdeAtivacaoD56,0) AS qtdeTransacaoDiaVidaD56
FROM tb_agg_transacao
