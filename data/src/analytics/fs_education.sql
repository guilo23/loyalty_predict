WITH tb_usuario_cursos AS (
    SELECT idUsuario,
            DescSlugCurso,
        COUNT(descSlugCursoEpisodio) AS qtdeEps

    FROM cursos_episodios_completos
    WHERE dtCriacao < '2025-09-01'
    GROUP BY idUsuario,descSlugCurso
),
tb_curso_total_eps AS (
    SELECT descSlugCurso,
    COUNT(descEpisodio) AS qtdeTotalEpisodios

    FROM cursos_episodios

    GROUP BY descSlugCurso

),
tb_pct_cursos AS (
SELECT t1.idUsuario,
       t1.DescSlugCurso,
       1. * t1.qtdeEps / t2.qtdeTotalEpisodios AS pctCursoCompleto

FROM tb_usuario_cursos AS t1

LEFT JOIN tb_curso_total_eps AS t2
ON t1.descSlugCurso = t2.descSlugCurso
),
tb_pct_cursos_pivot AS (
    SELECT idUsuario,
                                 SUM(CASE WHEN pctCursoCompleto = 1 THEN 1 ELSE 0 END) AS qtdeCursoCompletos,
        SUM(CASE WHEN pctCursoCompleto > 0 AND pctCursoCompleto < 1 THEN 1 ELSE 0 END) AS qtdeCursoImcompletos,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'estatistica-2025' THEN pctCursoCompleto ELSE 0 END ) AS estatistica2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS  github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2025' THEN pctCursoCompleto ELSE 0 END ) AS sql2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN pctCursoCompleto ELSE 0 END ) AS pandas2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2020' THEN pctCursoCompleto ELSE 0 END ) AS sql2020,
        SUM(CASE WHEN descSlugCurso = 'sql-2020' THEN pctCursoCompleto ELSE 0 END ) AS sql2020,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2020' THEN pctCursoCompleto ELSE 0 END ) AS sql2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'pandas-2024' THEN pctCursoCompleto ELSE 0 END ) AS pandas2024,
        SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN pctCursoCompleto ELSE 0 END ) AS pandas2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2020' THEN pctCursoCompleto ELSE 0 END ) AS sql2020,
        SUM(CASE WHEN descSlugCurso = 'estatistica-2024' THEN pctCursoCompleto ELSE 0 END ) AS estatistica2024,
        SUM(CASE WHEN descSlugCurso = 'mlflow-2025' THEN pctCursoCompleto ELSE 0 END ) AS  mlflow2025,
        SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN pctCursoCompleto ELSE 0 END ) AS pandas2025,
        SUM(CASE WHEN descSlugCurso = 'estatistica-2025' THEN pctCursoCompleto ELSE 0 END ) AS estatistica2024,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'github-2024' THEN pctCursoCompleto ELSE 0 END ) AS github2024,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'pandas-2024' THEN pctCursoCompleto ELSE 0 END ) AS pandas2024,
        SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN pctCursoCompleto ELSE 0 END ) AS pandas2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'github-2025' THEN pctCursoCompleto ELSE 0 END ) AS github2025,
        SUM(CASE WHEN descSlugCurso = 'python-2025' THEN pctCursoCompleto ELSE 0 END ) AS python2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2025' THEN pctCursoCompleto ELSE 0 END ) AS sql2025,
        SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN pctCursoCompleto ELSE 0 END ) AS pandas2025,
        SUM(CASE WHEN descSlugCurso = 'sql-2025' THEN pctCursoCompleto ELSE 0 END ) AS sql2025

    FROM tb_pct_cursos

    GROUP BY idUsuario
),
tb_atividade AS (

    SELECT
            idUsuario,
            MAX(dtRecompensa) AS dtCriacao
    FROM recompensas_usuarios
    GROUP BY idUsuario

UNION ALL

    SELECT 
            idUsuario,
            MAX(dtCriacao) AS dtCriacao
    FROM habilidades_usuarios
    GROUP BY idUsuario

UNION ALL

    SELECT
            idUsuario,
            MAX(dtCriacao) AS dtCriacao

    FROM cursos_episodios_completos
    GROUP BY idUsuario
),
tb_ultima_atividade AS (
SELECT idUsuario,
        ROUND(MIN(JULIANDAY('2025-10-01') - JULIANDAY(dtCriacao))) AS ultimaInteracao
FROM tb_atividade

GROUP BY idUsuario
),
tb_join AS (
    SELECT  t3.idTMWCliente,
            t2.ultimaInteracao,
            t1.qtdeCursoCompletos,
            t1.qtdeCursoImcompletos,
            t1.python2025,
            t1.github2025,
            t1.estatistica2025,
            t1.github2025,
            t1.python2025,
            t1.sql2025,
            t1.github2025,
            t1.github2025,
            t1.github2025,
            t1.python2025,
            t1.github2025,
            t1.python2025,
            t1.python2025,
            t1.github2025,
            t1.python2025,
            t1.github2025,
            t1.pandas2025,
            t1.python2025,
            t1.sql2020,
            t1.sql2020,
            t1.github2025,
            t1.python2025,
            t1.python2025,
            t1.sql2025,
            t1.github2025,
            t1.python2025,
            t1.python2025,
            t1.python2025,
            t1.python2025,
            t1.github2025,
            t1.pandas2024,
            t1.pandas2025,
            t1.python2025,
            t1.python2025,
            t1.sql2020,
            t1.estatistica2024,
            t1.mlflow2025,
            t1.pandas2025,
            t1.estatistica2024,
            t1.github2025,
            t1.github2024,
            t1.github2025,
            t1.pandas2024,
            t1.pandas2025,
            t1.python2025,
            t1.github2025,
            t1.python2025,
            t1.sql2025,
            t1.pandas2025

    FROM tb_pct_cursos_pivot AS t1
    LEFT JOIN tb_ultima_atividade AS t2
    ON t1.idUsuario = t2.idUsuario
    INNER JOIN usuarios_tmw AS t3
    ON t1.idUsuario = t3.idUsuario
)
SELECT DATE('2025-10-01','-1 day') AS detRef,
        *
FROM tb_join