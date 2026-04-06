-- 1. Prepara os dados mapeando as siglas para os IDs Inteiros que 
-- Existem na tabela TCC.dbo.ID_UNIVERSIDADE_C ou TCC.dbo.ID_UNIVERSIDADE_E

WITH Dados_Limpos AS (
    SELECT DISTINCT
        T.NM_CORRIGIDO,          -- O nome da Autora
        U.ID_UNIVERSIDADE        -- O ID Inteiro (1, 2, 3...) da tabela nova
    FROM TCC.dbo.STEM T
    INNER JOIN TCC.dbo.ID_UNIVERSIDADE_C U -- XXXXXXXXXXXX
        ON LTRIM(RTRIM(T.SG_ENTIDADE_ENSINO)) = LTRIM(RTRIM(U.SG_ENTIDADE_ENSINO))
    WHERE T.GENERO = 'FEMININO' -- XXXXXXXXXXXX
    AND NM_GRANDE_AREA_CONHECIMENTO = 'CIÊNCIAS EXATAS E DA TERRA' -- XXXXXXXXXXXX
),

-- 2. Faz o cruzamento (Self-Join) pelo NOME DA AUTORA
Conexoes_Univ AS (
    SELECT 
        A.ID_Universidade AS Source,
        B.ID_Universidade AS Target,
        -- Conta quantas MULHERES diferentes publicaram em ambas as universidades
        COUNT(DISTINCT A.NM_CORRIGIDO) AS Weight 
    FROM Dados_Limpos A
    INNER JOIN Dados_Limpos B 
        ON A.NM_CORRIGIDO = B.NM_CORRIGIDO -- Mesma Autora...
        AND A.ID_Universidade < B.ID_Universidade -- ...em Universidades Diferentes
    GROUP BY A.ID_Universidade, B.ID_Universidade
)

-- 3. Resultado Final para o Gephi
SELECT 
    ROW_NUMBER() OVER(ORDER BY Weight DESC) AS ID,
    Source,
    Target,
    Weight, -- Número de pesquisadoras compartilhadas
    'Undirected' AS Type,
    CASE 
        WHEN Weight >= 2 THEN CAST(Weight AS VARCHAR) -- Mostra o número se for >= 2
        ELSE ' ' 
    END AS Label
FROM Conexoes_Univ
ORDER BY Weight DESC;