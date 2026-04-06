-- ARESTAS: ligação autora–veículo
-- Weight = nº de artigos daquela autora naquele veículo

WITH Arestas AS (
    SELECT
        'A_' + LTRIM(RTRIM(S.NM_CORRIGIDO))                 AS Source,   -- origem (autora)
        'V_' + CAST(S.CD_IDENTIFICADOR_VEICULO AS VARCHAR(50)) AS Target,   -- destino (veículo)
        COUNT(*)                                            AS Weight,   -- nº de artigos
        'Undirected'                                        AS Type      -- rede não-direcionada
    FROM TCC.dbo.STEM S
    WHERE S.NM_REGIAO = 'NORDESTE' -- XXXXXXXXXX
      AND S.GENERO = 'FEMININO' -- XXXXXXXXXX
      AND S.NR_ORDEM = 1
      AND S.NM_GRANDE_AREA_CONHECIMENTO = 'CIÊNCIAS EXATAS E DA TERRA' -- XXXXXXXXXX
      AND S.TP_AUTOR = 'DOCENTE'
    GROUP BY
        'A_' + LTRIM(RTRIM(S.NM_CORRIGIDO)),
        'V_' + CAST(S.CD_IDENTIFICADOR_VEICULO AS VARCHAR(50))
)

SELECT
    Source,
    Target,
    Weight,
    CAST(Weight AS VARCHAR(10)) AS Label,   -- rótulo da aresta = peso
    Type
FROM Arestas
ORDER BY
    Weight DESC;
