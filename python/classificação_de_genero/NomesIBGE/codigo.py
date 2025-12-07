import pandas as pd
import sqlalchemy as sa
from sqlalchemy.engine import URL
import unicodedata

# CONFIGURAÇÕES GERAIS

# Caminhos dos arquivos (tem que está na mesma pasta do .py)
path_ibge    = "baseIBGE.csv"
path_autores = "nomesGOOD.CSV"

# --- Configuração do Banco de Dados ---
NOME_DO_SERVIDOR = r"localhost"  
NOME_DO_BANCO    = "TCC"
DRIVER           = "{ODBC Driver 17 for SQL Server}"

TABLE_NAME    = "NomesIBGE"   # nome da tabela final (NOME, GENERO)
LIMIAR_GENERO = 0.8           # 0.8 = 80% de confiança

# FUNÇÃO DE CONEXÃO

def criar_engine_sql_server():
    conn_str = (
        f"DRIVER={DRIVER};"
        f"SERVER={NOME_DO_SERVIDOR};"
        f"DATABASE={NOME_DO_BANCO};"
        "Trusted_Connection=yes;"
    )

    connection_url = URL.create(
        "mssql+pyodbc",
        query={"odbc_connect": conn_str}
    )
    engine = sa.create_engine(connection_url, fast_executemany=True)
    return engine

# FUNÇÃO PARA REMOVER ACENTOS

def remover_acentos(texto):
    """Remove acentos de uma string usando unicodedata."""
    if pd.isna(texto):
        return texto
    texto = str(texto)
    return ''.join(
        c for c in unicodedata.normalize('NFD', texto)
        if unicodedata.category(c) != 'Mn'
    )

# FUNÇÃO PARA CLASSIFICAR GÊNERO

def classificar_genero(row, limiar=LIMIAR_GENERO):
    pf = row.get("prob_f")
    pm = row.get("prob_m")

    if pd.isna(pf) or pd.isna(pm):
        return None   # vai virar NULL no SQL

    if pf >= limiar and pf > pm:
        return "FEMININO"
    elif pm >= limiar and pm > pf:
        return "MASCULINO"
    else:
        return None   # abaixo do limiar -> NULL

# SCRIPT PRINCIPAL

if __name__ == "__main__":

    # 1) Conecta no SQL Server
    print("Conectando ao SQL Server...")
    engine = criar_engine_sql_server()
    with engine.connect() as conn:
        conn.execute(sa.text("SELECT 1"))
    print("Conexão OK!\n")

    # 2) Carrega base IBGE
    print("Carregando base IBGE...")
    ibge = pd.read_csv(path_ibge)

    ibge["first_name"] = (
        ibge["first_name"]
        .astype(str)
        .str.lower()
        .str.strip()
        .apply(remover_acentos)   
    )

    ibge = ibge.dropna(subset=["first_name"])

    ibge["prob_f"] = ibge["frequency_female"] / ibge["frequency_total"]
    ibge["prob_m"] = ibge["frequency_male"] / ibge["frequency_total"]

    print(f"Base IBGE carregada: {len(ibge):,} linhas")

    # 3) Carrega nomes (nomesGOOD.CSV)
    print("\nCarregando nomes (nomesGOOD.CSV)...")
    
    df = pd.read_csv(path_autores, encoding="latin1", sep=";")
    print(f"Base de nomes carregada: {len(df):,} linhas")
    print("Colunas encontradas em nomesGOOD:", list(df.columns))

    # 4) Descobre a coluna de nome
    col_nome = None
    for c in df.columns:
        if str(c).lower().strip() in [
            "nome", "primeiro_nome", "first_name",
            "autor", "autores", "nome_completo"
        ]:
            col_nome = c
            break

    if col_nome is None and len(df.columns) == 1:
        col_nome = df.columns[0]

    if col_nome is None:
        raise ValueError(
            f"Não achei coluna de nome em nomesGOOD.CSV. "
            f"Colunas disponíveis: {list(df.columns)}"
        )

    # 5) Extrai primeiro nome e remove acentos
    df["first_name"] = (
        df[col_nome]
        .astype(str)
        .str.strip()
        .str.split()
        .str[0]
        .str.lower()
        .apply(remover_acentos)  
    )

    # 6) Join com IBGE
    print("\nFazendo o join com o IBGE...")
    resultado = df.merge(
        ibge[["first_name", "prob_f", "prob_m"]],
        on="first_name",
        how="left"
    )

    # 7) Classifica gênero com limiar
    resultado["GENERO"] = resultado.apply(classificar_genero, axis=1)

    # 8) Monta tabela final só com NOME e GENERO
    tabela_final = resultado[[col_nome, "GENERO"]].copy()
    tabela_final.rename(columns={col_nome: "NOME"}, inplace=True)

    print("\nExemplo de linhas:")
    print(tabela_final.head())

    # 9) Grava no SQL Server
    print(f"\nGravando tabela [{TABLE_NAME}] no banco [{NOME_DO_BANCO}]...")
    with engine.begin() as conn:
        tabela_final.to_sql(
            TABLE_NAME,
            con=conn,
            if_exists="replace",
            index=False
        )

    print("Concluído! ✅")