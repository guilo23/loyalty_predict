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
),
tb_agg_calc AS (
        SELECT
                *,
                COALESCE(1. * qtdeTransacaoVida / qtdeAtivacaoVida,0) AS qtdeTransacaoDiaVida,
                COALESCE(1. * qtdeTransacaoD7 / qtdeAtivacaoD7,0) AS qtdeTransacaoDiaVidaD7,
                COALESCE(1. * qtdeTransacaoD14 / qtdeAtivacaoD14,0) AS qtdeTransacaoDiaVidaD14,
                COALESCE(1. * qtdeTransacaoD28 / qtdeAtivacaoD28,0) AS qtdeTransacaoDiaVidaD28,
                COALESCE(1. * qtdeTransacaoD56 / qtdeAtivacaoD56,0) AS qtdeTransacaoDiaVidaD56,
                COALESCE(1. * qtdeAtivacaoD28 / 28,0) AS pctAtivacaoMAU

        FROM tb_agg_transacao
),
tb_horas_dias AS (
        SELECT idCliente,
                dtDia,
                24 * (MAX(JULIANDAY(dtCriacao)) - MIN(JULIANDAY(dtCriacao)))  AS duracao
        FROM tb_transacao
        GROUP BY idCliente,dtDia
),
tb_hora_cliente AS (
        SELECT idCliente,
                SUM(duracao) AS qtdeHorasV,
                SUM(CASE WHEN dtDia >= DATE('2025-10-01','-7 day') THEN duracao ELSE 0 END) AS qtdeHorasD7,
                SUM(CASE WHEN dtDia >= DATE('2025-10-01','-14 day') THEN duracao ELSE 0 END) AS qtdeHorasD14,
                SUM(CASE WHEN dtDia >= DATE('2025-10-01','-28 day') THEN duracao ELSE 0 END) AS qtdeHorasD28,
                SUM(CASE WHEN dtDia >= DATE('2025-10-01','-56 day') THEN duracao ELSE 0 END) AS qtdeHorasD56
        FROM tb_horas_dias
        GROUP BY idCliente
),
tb_lag_dia AS (
        SELECT idCliente,
                DtDia,
                LAG(dtDia) OVER (PARTITION BY idCLiente ORDER BY dtDia) AS lagDia
        FROM tb_horas_dias
),
tb_intervalo_dias AS (
        SELECT idCLiente,
                AVG(JULIANDAY(dtDia) - JULIANDAY(lagDia)) AS avgIntervalDiasVida,
                AVG(CASE WHEN dtDia >= DATE('2025-10-01','-28 day') THEN JULIANDAY(dtDia) - JULIANDAY(lagDia) END ) AS avgIntervalD28
        FROM tb_lag_dia
        GROUP BY idCLiente
)
 SELECT t1.*,
        t2.qtdeHorasV,
        t2.qtdeHorasD7,
        t2.qtdeHorasD14,
        t2.qtdeHorasD28,
        t2.qtdeHorasD56,
        t3.avgIntervalDiasVida,
        t3.avgIntervalD28

    FROM tb_agg_calc AS t1

    LEFT JOIN tb_hora_cliente AS t2
    ON t1.IdCliente = t2.IdCliente

    LEFT JOIN tb_intervalo_dias AS t3
    ON t1.IdCliente = t3.IdCliente

