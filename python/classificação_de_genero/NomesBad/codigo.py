import pandas as pd
import urllib.parse
from sqlalchemy import create_engine

# Função: gerar nome no formato ABNT

def nome_abnt_iniciais_sobrenome(nome):
    if pd.isna(nome):
        return ''
    partes = str(nome).strip().split()
    if len(partes) == 0:
        return ''
    sobrenome = partes[-1].capitalize()
    iniciais = [p[0].upper() + '.' for p in partes[:-1] if p]
    return ''.join(iniciais) + ' ' + sobrenome

# ARQUIVOS (tem que esta na mesma pasta do .py)

arquivo_nomes_bad = "nomesBAD.csv"
arquivo_sucupira = "NomesIBGE.csv"

# 1) Carregar NOMES_BAD

df_nomes_bad = pd.read_csv(
    arquivo_nomes_bad,
    encoding="latin1",
    sep=";"
)

df_nomes_bad['nome_abnt'] = df_nomes_bad['NOMES'].apply(nome_abnt_iniciais_sobrenome)

# 2) Carregar base de gênero

df_sucupira = pd.read_csv(
    arquivo_sucupira,
    encoding="latin1",
    sep=";"
)

df_sucupira['NOME'] = df_sucupira['NOME'].astype(str).str.strip()
df_sucupira['nome_abnt'] = df_sucupira['NOME'].apply(nome_abnt_iniciais_sobrenome)

# detectar coluna de gênero
if "GENERO_FINAL" in df_sucupira.columns:
    col_genero = "GENERO_FINAL"
elif "GENERO" in df_sucupira.columns:
    col_genero = "GENERO"
else:
    raise ValueError("A base de gênero precisa ter a coluna GENERO ou GENERO_FINAL.")

# 3) Merge

df_resultado = df_nomes_bad.merge(
    df_sucupira[["nome_abnt", col_genero]],
    on="nome_abnt",
    how="left"
).rename(columns={col_genero: "genero_inferido"})

# 4) Conexão com SQL Server

host = r"localhost"
banco = "TCC"
driver = "ODBC Driver 17 for SQL Server"

params = urllib.parse.quote_plus(
    f"DRIVER={driver};"
    f"SERVER={host};"
    f"DATABASE={banco};"
    "Trusted_Connection=yes;"
)

engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# 5) Gravar o resultado

schema_nome = "dbo"
nome_tabela = "nomes_bad_com_genero"

df_resultado.to_sql(
    name=nome_tabela,
    con=engine,
    schema=schema_nome,   
    if_exists="replace",  
    index=False
)

# 6) Estatísticas

print(f"Total de nomes no arquivo nomesBAD: {len(df_nomes_bad)}")
print(f"Total com gênero inferido: {df_resultado['genero_inferido'].notna().sum()}")
print(f"Tabela criada: {banco}.{schema_nome}.{nome_tabela}")