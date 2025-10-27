WITH tb_freq_valor AS (
    SELECT 
        idCliente,
        COUNT (DISTINCT substr(DtCriacao,0,11)) AS qtdeFrequencia,
        SUM(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPOS
    FROM transacoes

    WHERE DtCriacao < '2025-09-01'
    AND DtCriacao >= DATE('2025-09-01','-28 day')

    GROUP BY 1

    ORDER BY DtCriacao DESC
),
tb_cluster AS (
    SELECT *,
        CASE
            WHEN qtdeFrequencia <= 10 AND QtdePontosPos > 1500 THEN '02-HYPERS'
            WHEN qtdeFrequencia > 10 AND QtdePontosPOS > 1500 THEN '22-EFICIENTES'
            WHEN qtdeFrequencia < 10 AND QtdePontosPOS >= 750 THEN '10-INDECISO'
            WHEN qtdeFrequencia > 10 AND QtdePontosPOS >= 750 THEN '11-ESFORÇADO'
            WHEN qtdeFrequencia < 5 THEN '00-LURKER'
            WHEN qtdeFrequencia <= 10 THEN '01-PREGUIÇOSO'
            WHEN qtdeFrequencia > 10 THEN '02-POTENCIAL'

        END AS cluster
    FROM tb_freq_valor
)
SELECT  *
FROM tb_cluster