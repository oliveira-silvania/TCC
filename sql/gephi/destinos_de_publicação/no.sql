-- NÓS: autoras docentes (1ª autora, feminino, Área do conhecimento, Região)
-- + veículos A1/A2

SELECT DISTINCT
    'A_' + LTRIM(RTRIM(S.NM_CORRIGIDO))  AS Id,        -- ID do nó (autora)
    LTRIM(RTRIM(S.NM_CORRIGIDO))         AS Label,     -- Nome da autora
    'AUTOR_DOCENTE'                      AS Tipo,      -- Tipo de nó
    'AUTOR'                              AS Categoria  -- Categoria de cor (1 cor para todos autores)
FROM TCC.dbo.STEM S
WHERE S.NM_REGIAO = 'SUDESTE' -- XXXXXXXXXXX
  AND S.GENERO = 'FEMININO'
  AND S.NR_ORDEM = 1
  AND S.NM_GRANDE_AREA_CONHECIMENTO = 'ENGENHARIAS' -- XXXXXXXXXXX
  AND S.TP_AUTOR = 'DOCENTE'
  AND S.ESTRATO IN ('A1', 'A2') -- só veículos A1 e A2

UNION

SELECT DISTINCT
    'V_' + CAST(S.CD_IDENTIFICADOR_VEICULO AS VARCHAR(50)) AS Id,        -- ID do nó (veículo)
    CAST(S.CD_IDENTIFICADOR_VEICULO AS VARCHAR(50))        AS Label,     -- Código do veículo
    'VEICULO'                                              AS Tipo,      -- Tipo de nó
    CAST(S.ESTRATO AS VARCHAR(20))                         AS Categoria  -- A1 ou A2
FROM TCC.dbo.STEM S
WHERE S.NM_REGIAO = 'SUDESTE'   -- XXXXXXXXXXX
  AND S.GENERO = 'MASCULINO'    -- XXXXXXXXXXX
  AND S.NR_ORDEM = 1
  AND S.NM_GRANDE_AREA_CONHECIMENTO = 'ENGENHARIAS'   -- XXXXXXXXXXX
  AND S.TP_AUTOR = 'DOCENTE'
  AND S.ESTRATO IN ('A1', 'A2') -- só veículos A1 e A2
ORDER BY Tipo, Label;
