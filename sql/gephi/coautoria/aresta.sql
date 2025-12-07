WITH ArtigosRede AS (
    SELECT DISTINCT
        ID_ADD_PRODUCAO_INTELECTUAL
    FROM TCC.dbo.STEM
    WHERE GENERO = 'FEMININO' -- GÊNERO
      AND TP_AUTOR = 'DOCENTE'
      AND NR_ORDEM = 1
      AND NM_GRANDE_AREA_CONHECIMENTO = 'ENGENHARIAS' -- ÁREA 
      AND NM_REGIAO = 'SUL' -- REGIÃO
),
Base AS (
    SELECT *
    FROM TCC.dbo.STEM
    WHERE ID_ADD_PRODUCAO_INTELECTUAL IN (
        SELECT ID_ADD_PRODUCAO_INTELECTUAL FROM ArtigosRede
    )
),
Arestas AS (
    SELECT
        fa.NM_CORRIGIDO AS Source,      -- docente, 1ª autor(a)
        co.NM_CORRIGIDO AS Target,      -- coautor
        COUNT(DISTINCT fa.ID_ADD_PRODUCAO_INTELECTUAL) AS Weight
    FROM Base fa
    JOIN Base co
          ON fa.ID_ADD_PRODUCAO_INTELECTUAL = co.ID_ADD_PRODUCAO_INTELECTUAL
         AND co.NR_ORDEM <> fa.NR_ORDEM
    WHERE fa.TP_AUTOR = 'DOCENTE'
      AND fa.NR_ORDEM = 1
      AND fa.GENERO = 'FEMININO' --GÊNERO
    GROUP BY
        fa.NM_CORRIGIDO,
        co.NM_CORRIGIDO
)

SELECT
    Source,
    Target,
    Weight,
    CAST(Weight AS VARCHAR(10)) AS Label 
FROM Arestas
ORDER BY
    Source,
    Target
