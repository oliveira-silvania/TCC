# ANÁLISE DE REDES COMPLEXAS DAS PUBLICAÇÕES CIENTÍFICAS DE MULHERES EM PROGRAMAS DE PÓS-GRADUAÇÃO STRICTO SENSU NAS ÁREAS STEM (2021–2023), COM BASE NA PLATAFORMA SUCUPIRA

Repositório oficial do **Trabalho de Conclusão de Curso** apresentado ao curso de **Ciência da Computação da Pontifícia Universidade Católica de Goiás**, sob orientação da **Profa. Maria José Pereira Dantas**, no ano de **2025**.

---

## 👤 Autoria  
- **Discente:** Silvania Alves Oliveira  
- **Orientadora:** Profa. Dra. Maria José Pereira Dantas  
- **Instituição:** PUC Goiás  
- **Curso:** Ciência da Computação  
- **Ano:** 2025  

---

## 🎯 Objetivos do TCC

### Objetivo geral
Analisar a participação de mulheres em programas de mestrado e doutorado nas áreas de STEM no Brasil, nos anos de 2021, 2022 e 2023, por meio de redes complexas aplicadas aos dados da Plataforma Sucupira.

### Objetivos específicos
- Extrair e organizar os dados da Plataforma Sucupira, com foco nas áreas de Engenharias e CET.  
- Construir redes complexas de coautoria, vínculos institucionais e destinos de publicação, utilizando métricas como grau, centralidade, densidade e modularidade.  
- Analisar desigualdades de participação feminina e padrões estruturais da colaboração.  
- Desenvolver um painel de BI interativo para exploração estatística dos dados.  

---

## 📂 Estrutura do Repositório

### **`data/`** — Bases de dados  
- **`raw/`** → dados brutos extraídos da Plataforma Sucupira (2021–2023).  
- **`processed/`** → dados tratados e prontos para análises e geração das redes.  

### **`gephi/`** — Redes complexas  

- **`circulação_institucional/`**  
- **`coautoria/`**  
- **`destinos_de_publicação/`**  

Cada pasta inclui arquivos **CSV de nós, arestas** e projetos **.gephi**.

### **`python/`** — Códigos em python 
Inclui:  
- **`classificação_de_genero/`** → scripts dedicados à inferência de gênero.  
- **`converter_csv_para_banco.py`** → código para importar arquivos CSV diretamente no SQL Server.

### **`sql/`** — Scripts SQL  
- **`gephi/`** → consultas para geração de nós e arestas das redes.  
- **`integracao_dos_dados.sql`** → integração das bases 2021–2023 e filtragem dos dados necessários.  

---

## ⚙️ Tecnologias utilizadas no TCC

- **Python** → integração de dados e rotinas de classificação de gênero.  
- **SQL Server** → armazenamento, limpeza e processamento dos dados.  
- **Gephi** → modelagem, métricas e visualização das redes.  
- **Power BI** → painel analítico interativo.  
- **GitHub** → versionamento e reprodutibilidade da pesquisa.  

---

## 📊 Redes analisadas no TCC

O estudo modela três tipos de redes:

### 1. **Rede de coautoria**
- **Nós**: autores  
- **Arestas**: relações de coautoria  
- Foco na **primeira autoria por gênero** em CET e Engenharias.  

### 2. **Rede de destinos de publicação**
- **Nós**: autoras e veículos (periódicos)  
- **Arestas**: artigos publicados  
- Análise incorporando **estrato Qualis**.

### 3. **Rede de circulação institucional**
- **Nós**: instituições brasileiras de ensino e pesquisa  
- **Arestas**: vínculos de publicação ao longo dos três anos  

Cada rede possui métricas como:
- grau médio e ponderado  
- densidade  
- modularidade  
- clustering  
- componentes  
- diâmetro  

Essas métricas permitem identificar **padrões de colaboração, posições estruturais e desigualdades de participação de gênero**.

---

## 📈 Painel de Business Intelligence (BI)

O **painel de BI interativo** permite a exploração visual e estatística da produção científica.

### **Funções principais:**
- Filtragem por **ano**, **área**, **região**, **instituição**, **gênero**, **estrato Qualis** e **tipo de vínculo**.  
- Visualização da distribuição da produção acadêmica no Brasil.  
- Identificação de padrões regionais e temáticos.  
- Complementação das análises estruturais feitas no Gephi.

🔗 **Link do painel de BI:**  
**[Acessar painel BI (Power BI)](https://app.powerbi.com/groups/me/reports/2a735f23-e1e6-448a-89e0-29e9aca95e97/89ec0c53004d157a0256?experience=power-bi)**

---

## 📝 Documento final

O TCC completo está disponível em:

🔗 **[Acessar TCC Final (PDF)](COLOQUE_AQUI_O_LINK_QUANDO_PUBLICAR)**

---
