CREATE TABLE abt_fiel AS

WITH tb_join AS (
    SELECT t1.dtRef,
        t1.idCliente,
        t1.descLifeCycle,
        t2.descLifeCycle,
        CASE WHEN t2.descLifeCycle = '02-FIEL' THEN 1 ELSE 0 END AS flFiel,
        ROW_NUMBER() OVER (PARTITION BY t1.idCliente ORDER BY RANDOM()) AS colRandom
    
    FROM life_cycle AS t1

    LEFT JOIN life_cycle AS t2
    ON t1.idCliente = t2.idCliente
    AND DATE(t1.dtRef,'+28 day') = DATE(t2.dtRef)
    
    WHERE ((t1.dtRef >= '2024-03-01' AND t1.dtRef  <= '2025-08-01')
                OR t1.dtRef  <= '2025-09-01')
    AND t1.descLifeCycle <> '05-ZUMBI'
),
tb_cohort AS (
  SELECT t1.dtRef,
        t1.idCliente,
        t1.flFiel
    FROM tb_join AS t1

    WHERE colRandom <= 2
    
    ORDER BY idCliente,dtRef

)
SELECT t1.*,
        t2.qtdeHorasV,
        t2.qtdeHorasD7,
        t2.qtdeHorasD14,
        t2.qtdeHorasD28,
        t2.qtdeHorasD56,
        t2.avgIntervalDiasVida,
        t2.avgIntervalD28,
        t2.qteChatMessage,
        t2.qteAirflowLover,
        t2.qteRLover,
        t2.qteResgatarPonei,
        t2.qteListadepresenca,
        t2.qtePresencaStreak,
        t2.qteTrocaStreamElements,
        t2.qteReembolsoStreamElements,
        t2.qtdeRPG,
        t2.qtdeChurnModel,
        t4.detRef , 
        t4.idTMWCliente, 
        t4.ultimaInteracao, 
        t4.qtdeCursoCompletos, 
        t4.qtdeCursoImcompletos, 
        t4.estatistica2025, 
        t4.sql2020, 
        t4.mlflow2025, 
        t4.estatistica2024, 
        t4.github2024, 
        t4.pandas2024, 
        t4.github2025, 
        t4.python2025, 
        t4.sql2025, 
        t4.pandas2025 
        



FROM tb_cohort AS t1
LEFT JOIN fs_transacional AS t2
ON t1.idCLiente = t2.idCliente
AND t1.dtRef = t2.dtRef

-- LEFT JOIN fs_lifeCycle AS t3
-- ON t1.idCliente = t3.idCliente
-- AND t1.dtRef = t3.dtRef

    LEFT JOIN fs_education AS t4
    ON t1.idCliente = t4.idTMWCliente
    AND t1.dtRef = t4.detRef

