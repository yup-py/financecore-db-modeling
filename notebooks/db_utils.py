import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Load variables once at the top
load_dotenv()

def get_engine(db_name=None):
    """Helper to create engine. If db_name is None, connects to 'postgres'."""
    user = os.getenv("DB_USER")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST")
    port = os.getenv("DB_PORT")
    target_db = db_name if db_name else "postgres"
    
    url = f"postgresql://{user}:{password}@{host}:{port}/{target_db}"
    # Use AUTOCOMMIT for database creation tasks
    return create_engine(url, isolation_level="AUTOCOMMIT")

def create_new_database():
    """Step 1: Create the physical database container."""
    new_db = os.getenv("DB_NAME")
    engine = get_engine() # Connects to default 'postgres'
    
    try:
        with engine.connect() as conn:
            conn.execute(text(f"CREATE DATABASE {new_db}"))
            print(f"✅ Database '{new_db}' created successfully!")
    except Exception as e:
        if "already exists" in str(e):
            print(f"ℹ️ Database '{new_db}' already exists. Skipping...")
        else:
            print(f"❌ Error creating database: {e}")

def create_tables():
    """Step 2: Build the tables inside the new database."""
    db_name = os.getenv("DB_NAME")
    engine = get_engine(db_name) # Connects to your project DB
    sql_path = "sql/create_tables.sql" 

    try:
        with open(sql_path, "r", encoding="utf-8") as file:
            query = text(file.read())
            
        with engine.connect() as conn:
            conn.execute(query)
            print(f"✅ Tables created successfully in '{db_name}'!")
    except Exception as e:
        print(f"❌ Table creation failed: {e}")

def load_data_to_db():
    """Step 3: Upload CSV data into the tables."""
    db_name = os.getenv("DB_NAME")
    engine = get_engine(db_name)
    
    try:
        # Load CSV (Ensure the path is correct for your folders)
        df = pd.read_csv('data/financecore_clean.csv', encoding='latin1')

        # Load Dimensions
        for col, table in [('agence', 'agencies'), ('produit', 'products'), ('categorie', 'categories')]:
            dim_df = df[[col]].drop_duplicates().reset_index(drop=True)
            dim_df.to_sql(table, engine, if_exists='append', index=False)
            print(f"✅ Data inserted into '{table}'")

        # Load Clients
        clients_df = df[['client_id', 'score_credit_client', 'categorie_risque', 'segment_client']].drop_duplicates(subset=['client_id'])
        clients_df.to_sql('clients', engine, if_exists='append', index=False)
        print(f"✅ Data inserted into 'clients'")
        
    except Exception as e:
        print(f"⚠️ Data loading skipped or failed: {e}")

# --- THE SINGLE ENTRY POINT ---
# This is the ONLY 'if __name__' block you need.
if __name__ == "__main__":
    print("--- Starting Pipeline ---")
    create_new_database()
    create_tables()
    load_data_to_db()
    print("--- Pipeline Complete ---")