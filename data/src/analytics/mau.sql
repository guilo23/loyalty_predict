WITH tb_daily AS (
    SELECT DISTINCT
        DATE(SUBSTR(DtCriacao,0,11)) AS DtDIA,
        IdCliente

    FROM transacoes
    order by DtDIA
    ),
tb_distinct_day AS (
    SELECT
        DISTINCT DtDIA AS DtRef
    FROM tb_daily
    )
SELECT
    t1.DtRef,
    COUNT(DISTINCT IdCliente) AS MAU,
    COUNT (DISTINCT t2.DtDIA) AS qtdeDias
FROM tb_distinct_day AS t1

LEFT JOIN tb_daily AS t2
ON t2.DtDIA <= t1.DtRef
AND JULIANDAY(t1.DtRef) - JULIANDAY(t2.DtDIA) < 28

GROUP BY t1.DtRef
ORDER BY t1.DtRef ASC

LIMIT 1000
