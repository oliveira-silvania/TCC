Esta pasta contém os **dados processados (processed)** utilizados no projeto de TCC:  
> **ANÁLISE DE REDES COMPLEXAS DAS PUBLICAÇÕES CIENTÍFICAS DE MULHERES EM PROGRAMAS DE PÓS-GRADUAÇÃO STRICTO SENSU NAS ÁREAS STEM (2021–2023), COM BASE NA PLATAFORMA SUCUPIRA**

O arquivo principal é um backup do **SQL Server**.

## 📁 Localização do Arquivo
O arquivo de backup está hospedado no Google Drive:
* **Arquivo:** `TCC.bak`
* **Link de Acesso:** [Acessar a pasta no Google Drive](https://drive.google.com/drive/folders/1nfp5xIsmqzHY51RnK1_eZ6omOWGTtwj7?usp=drive_link)

## 📊 Estrutura do Banco de Dados
A base de dados é composta por tabelas que fundamentam a análise de redes complexas e a presença de mulheres em STEM. Abaixo estão as tabelas identificadas:

### Tabelas de Produção e Classificação
* `dbo.artigos_periodicos`: Dados sobre os artigos.
* `dbo.qualis_novo`: Classificação Qualis dos periódicos.
* `dbo.STEM`: Tabela final de dados consolidados.
* `dbo.CIENCIAS_EXATAS_TERRA` / `dbo.ENGENHARIAS`: Especificações por área de conhecimento.

### Tabelas de Autoria e Instituições
* `dbo.autor_artigos_periodicos`: Tabela com informações dos autores vinculados aos artigos.
* `dbo.ID_AUTORES` / `dbo.ID_AUTORES_C` / `dbo.ID_AUTORES_E`: Identificadores únicos de autores.
* `dbo.ID_UNIVERSIDADE` / `dbo.ID_UNIVERSIDADE_C` / `dbo.ID_UNIVERSIDADE_E`: Identificadores das instituições.

### Tabelas de Referência de Gênero
* `dbo.nomesIBGE80`: Base de nomes identificados usando **Método Probabilístico**, com probabilidade de o gênero estar correto acima de 80%.
* `dbo.nomesIBGE90`: Base de nomes identificados usando **Método Probabilístico**, com probabilidade de o gênero estar correto acima de 90%.
* `dbo.nomes_bad_com_genero`: Lista de nomes identificados usando **Recuperação Heurística por Padronização**.

### Outras Tabelas
* `dbo.financiadores`: Base contendo todos os dados sobre os órgãos financiadores de projetos de pesquisa.
* `dbo.prog_pos`: Informações sobre os programas de pós-graduação.

## 🛠️ Como Restaurar o Banco
Para utilizar os dados contidos no arquivo `.bak`, siga estes passos no **SQL Server Management Studio (SSMS)**:

1. Faça o download do arquivo `TCC.bak` para sua máquina.
2. No SSMS, clique com o botão direito em **Databases** e selecione **Restore Database...**.
3. Em "Source", selecione **Device** e clique no ícone de reticências (...) para localizar o arquivo `.bak`.
4. Clique em **OK** para concluir a restauração.
