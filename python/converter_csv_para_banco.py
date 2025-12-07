import pandas as pd
from sqlalchemy import create_engine
import urllib

# Caminho do arquivo CSV
arquivo_csv = "XXX.csv"  # nome do arquivo CSV. Obs: tem que estar na mesma pasta do .py

# Nome da instância do SQL Server
host = "localhost\\SQLEXPRESS"
banco = "TCC"
driver = "ODBC Driver 17 for SQL Server"

# String de conexão usando autenticação do Windows
params = urllib.parse.quote_plus(
    f"DRIVER={driver};SERVER={host};DATABASE={banco};Trusted_Connection=yes;"
)

# Criar a engine
engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

# Ler o arquivo CSV
df = pd.read_csv(arquivo_csv, sep=";", encoding="utf-8")

# Enviar os dados para a tabela
df.to_sql("XXX", engine, index=False, if_exists="replace")

print("Dados inseridos com sucesso.")
