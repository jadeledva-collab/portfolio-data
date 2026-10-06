import requests
from datetime import datetime 
import sqlite3

API_KEY = "a28dea779d4e7d045a3f74c735c8fe0f"

# Liste des destinations de l'entreprise de tourisme
destinations = ["Paris", "Tokyo", "New York", "Sydney", "Marrakech"]

def save_weather_for_all_cities():
    try:
        conn = sqlite3.connect("meteo.db")
        cursor = conn.cursor()

        for city in destinations:
            url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
            
            response = requests.get(url)
            if response.status_code != 200:
                print(f"Erreur API pour {city} : {response.status_code}")
                continue  # S'assure de passer à la ville suivante dans la boucle for

            raw_data = response.json()

            # Extraction et nettoyage
            city_name = raw_data.get("name")
            country = raw_data.get("sys", {}).get("country")
            temperature = round(raw_data.get("main", {}).get("temp"), 1)
            humidity = raw_data.get("main", {}).get("humidity")
            description = raw_data.get("weather", [{}])[0].get("description")
            recorded_at = datetime.fromtimestamp(raw_data.get("dt")).strftime('%Y-%m-%d %H:%M:%S')

            # Insertion de la destination
            cursor.execute("""
                INSERT OR IGNORE INTO destination (city_name, country)
                VALUES (?, ?)
            """, (city_name, country))
            
            # Récupération de l'ID de la destination
            cursor.execute("SELECT id FROM destination WHERE city_name = ?", (city_name,))
            destination_id = cursor.fetchone()[0]

            # Insertion du relevé météo
            cursor.execute("""
                INSERT INTO weather_log (destination_id, temperature, humidity, description, recorded_at)
                VALUES (?, ?, ?, ?, ?)
            """, (destination_id, temperature, humidity, description, recorded_at))

            print(f"-> Succès pour {city_name} ({country}) : {temperature}°C, {description}")

        conn.commit()
        print("\nToutes les données ont été enregistrées avec succès dans la base SQL !")

    except Exception as e:
        print(f"Une erreur est survenue : {e}")
        
    finally:
        if 'conn' in locals():
            conn.close()

# Lancer la fonction
save_weather_for_all_cities()