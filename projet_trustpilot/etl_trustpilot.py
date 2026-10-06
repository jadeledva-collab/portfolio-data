import pandas as pd
import sqlite3
import os

def extraire_donnees(chemin_csv):
    """étape 1 et 2 : Extraction des données depuis le fichier CSV local"""
    if not os.path.exists(chemin_csv):
        print(f"Erreur : Le fichier {chemin_csv} est introuvable dans le dossier.")
        return pd.DataFrame()
    
    print(f"Extraction des données depuis le fichier : {chemin_csv}")
    df = pd.read_csv(chemin_csv)
    print(f"Nombre de lignes brutes extraites : {len(df)}")
    return df

def transformer_donnees(df):
    """Étape 3 : Nettoyage et transformation des données"""
    if df.empty:
        return df
    
    print("Début du nettoyage des données...")
    
    df = df.drop_duplicates()
    
    colonnes_possibles_texte = ['texte', 'review', 'Review Text', 'content']
    colonnes_possibles_note = ['note', 'rating', 'Rating', 'stars']
    colonnes_possibles_auteur = ['auteur', 'author', 'Consumer Name', 'name']
    
    for col in df.columns:
        col_lower = col.lower()
        if any(p in col_lower for p in ['text', 'review', 'content']) and 'texte' not in df.columns:
            df = df.rename(columns={col: 'texte'})
        elif any(p in col_lower for p in ['rate', 'star', 'note']) and 'note' not in df.columns:
            df = df.rename(columns={col: 'note'})
        elif any(p in col_lower for p in ['author', 'name', 'auteur']) and 'auteur' not in df.columns:
            df = df.rename(columns={col: 'auteur'})

    if 'texte' not in df.columns:
        df['texte'] = "Avis sans texte"
    if 'note' not in df.columns:
        df['note'] = 0
    if 'auteur' not in df.columns:
        df['auteur'] = "Anonyme"

    df['texte'] = df['texte'].astype(str).str.replace('\n', ' ', regex=True).str.strip()

    df = df.dropna(subset=['texte'])
    df = df[df['texte'] != ""]
    
    print(f"Données après nettoyage : {len(df)} avis valides prêts à être stockés.")
    return df

def charger_dans_sqlite(df, db_name="trustpilot.db"):
    """Étape 4 & 5 : Chargement (Load) dans la base de données SQLite"""
    if df.empty:
        print("Rien à insérer dans la base de données.")
        return

    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS reviews (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            auteur TEXT,
            note REAL,
            texte TEXT
        )
    ''')
    
    df[['auteur', 'note', 'texte']].to_sql('reviews', conn, if_exists='append', index=False)
    
    conn.commit()
    conn.close()
    print(f"Succès ! Les données ont été chargées dans la table 'reviews' de la base '{db_name}'.")

if __name__ == "__main__":
    fichier_csv = "trust_pilot_reviews_data_2022_06.csv"
    
    df_brut = extraire_donnees(fichier_csv)
    df_propre = transformer_donnees(df_brut)
    charger_dans_sqlite(df_propre)