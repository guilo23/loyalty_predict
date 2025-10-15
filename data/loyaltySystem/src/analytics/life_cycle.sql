--curiosa -> idade <  7
--fiel -> recencia < 7 e recencia < 15
--turista -> recencia < 15
--desencatado -> recencia < 28
-- zumbi -> recencia > 28 
-- reconquistado -> < 7 e 14 <= recencia anterior <= 28
-- reborn -> < 7 e 14 <= recencia anterior > 28

WITH tb_daily AS (

    SELECT 
        DISTINCT IdCliente,
        SUBSTR (DtCriacao,0,11) AS dtDia
    
    FROM transacoes

),
tb_idade AS (
    SELECT 
        IdCliente,
        --MIN(dtDia) AS dtPrimeiratransacao
        CAST(MAX(JULIANDAY('now') - JULIANDAY(dtDia)) AS INT) AS qtdeDiasPrimTransacao,

        --MAX(dtDia) AS dtUltimaTransacao
        CAST(MIN(JULIANDAY('now') - JULIANDAY(dtDia)) AS INT) AS qtdeDiasUltimaTrans

    FROM tb_daily
    GROUP BY IdCliente

),
tb_rn AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY dtDia DESC) AS RnDIA

    FROM tb_daily

),
tb_penultima_ativacao AS (
    SELECT *,
        CAST(JULIANDAY('now') - JULIANDAY(dtDia) AS INT ) AS qtdePenultima

    FROM tb_rn
    WHERE RnDIA = 2

),
tb_life_cycle AS (
    SELECT 
        t1.*,
        t2.qtdePenultima,
        CASE 
            WHEN t1.qtdeDiasPrimTransacao <= 16 THEN '01-Curioso'
            WHEN t1.qtdeDiasUltimaTrans <= 16 AND t2.qtdePenultima - t1.qtdeDiasUltimaTrans <= 28 THEN '02-Fiel'
            WHEN t1.qtdeDiasUltimaTrans BETWEEN 8 AND 14  THEN '03-Turistas'
            WHEN t1.qtdeDiasUltimaTrans BETWEEN 15 AND 28 THEN '04-DESENCANTADA'
            WHEN t1.qtdeDiasUltimaTrans > 28 THEN '05-Zumbi'
            WHEN t1.qtdeDiasUltimaTrans <= 16 AND t2.qtdePenultima - t1.qtdeDiasUltimaTrans BETWEEN 15 AND 35 THEN '02-RECONQUISTADO'
            WHEN t1.qtdeDiasUltimaTrans <= 16 AND t2.qtdePenultima - t1.qtdeDiasUltimaTrans > 14 THEN '02-REBORN'
        END AS DescLifeCycle

    FROM tb_idade AS t1

    LEFT JOIN tb_penultima_ativacao AS t2
    ON t1.IdCliente = t2.IdCliente
)
SELECT DescLifeCycle,
        COUNT(*)
FROM tb_life_cycle
GROUP BY DescLifeCycle 


