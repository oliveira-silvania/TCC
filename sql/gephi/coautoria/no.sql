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

Edges AS (
    SELECT DISTINCT
        fa.NM_CORRIGIDO AS Source,
        co.NM_CORRIGIDO AS Target
    FROM Base fa
    JOIN Base co
          ON fa.ID_ADD_PRODUCAO_INTELECTUAL = co.ID_ADD_PRODUCAO_INTELECTUAL
         AND co.NR_ORDEM <> fa.NR_ORDEM
    WHERE fa.TP_AUTOR = 'DOCENTE'
      AND fa.NR_ORDEM = 1
      AND fa.GENERO = 'FEMININO' -- GÊNERO
),

-- todos os autores que têm pelo menos uma ligação (source OU target)
Ligados AS (
    SELECT Source AS NM_CORRIGIDO FROM Edges
    UNION
    SELECT Target FROM Edges
),

-- flags pra saber o papel de cada autor nesses artigos
Flags AS (
    SELECT
        b.NM_CORRIGIDO,
        MAX(b.TP_AUTOR) AS TipoOriginal,

        -- docente 1ª autor(a) (só essas viram "DOCENTE_PRIMEIRO_AUTOR")
        MAX(CASE 
                WHEN b.TP_AUTOR = 'DOCENTE'
                 AND b.NR_ORDEM = 1
                 AND b.GENERO = 'FEMININO' -- GÊNERO 
                THEN 1 ELSE 0
            END) AS Doc_Primeiro,

        -- qualquer docente que não caia no caso acima
        MAX(CASE 
                WHEN b.TP_AUTOR = 'DOCENTE'
                 AND NOT (b.NR_ORDEM = 1 AND b.GENERO = 'FEMININO') -- GÊNERO
                THEN 1 ELSE 0
            END) AS Doc_NaoPrimeiro
    FROM Base b
    GROUP BY
        b.NM_CORRIGIDO
)

SELECT
    l.NM_CORRIGIDO AS Id,
    l.NM_CORRIGIDO AS Label,
    f.TipoOriginal AS Tipo,

    CASE
        WHEN f.Doc_Primeiro = 1 THEN 'DOCENTE_PRIMEIRO_AUTOR'
        WHEN f.Doc_NaoPrimeiro = 1 THEN 'DOCENTE_NAO_PRIMEIRO'
        WHEN f.TipoOriginal = 'PARTICIPANTE EXTERNO' THEN 'PARTICIPANTE_EXTERNO'
        WHEN f.TipoOriginal = 'DISCENTE'              THEN 'DISCENTE'
        WHEN f.TipoOriginal = 'EGRESSO'               THEN 'EGRESSO'
        WHEN f.TipoOriginal IN ('NÃO INFORMADO','NAO INFORMADO') THEN 'NAO_INFORMADO'
        WHEN f.TipoOriginal IN ('PÓS-DOC','POS-DOC')  THEN 'POS_DOC'
        ELSE 'OUTRO'
    END AS CategoriaNo
FROM Ligados l
LEFT JOIN Flags f
       ON f.NM_CORRIGIDO = l.NM_CORRIGIDO
ORDER BY
    Id;
