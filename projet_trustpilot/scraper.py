import requests
from bs4 import BeautifulSoup
import pandas as pd

def scrape_trustpilot(url_entreprise):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept-Language": "fr-FR,fr;q=0.9"
    }

    print(f"Extraction des données depuis : {url_entreprise}")
    response = requests.get(url_entreprise, headers=headers)

    if response.status_code !=200:
        print(f"Erreur lors de l'accès à la page. Code HTTP : {response.statu_code}")
        return []

    soup = BeautifulSoup(response.text, 'html.parser')

    avis_list = []

    containers = soup.find_all('div', class_='styles_cardWrapper__LcCcv')

    for container in containers: 
        try: 
            auteur = container.find('span', class_='typographie_heading-xs__jke_e').text.strip()
            texte_element = container.find('p', class_='typography_body-l__KU9ZB')
            texte = texte_element.text.strip() if texte_element else "Pas de texte"

            note_img = container.find('div', class_='star-rating').find('img')
            note = note_img['alt'] if note_img else "Note non trouvée"

            avis_list.append({
                'auteur': auteur,
                'note': note,
                'texte': texte
            })
        except Exception as e:
            continue

        return avis_list

    if __name__== "__main__":
        url_test = "https://fr.trustpilot.com/review/www.amazon.fr"
        donnees = scrape_trustpilot(url_test)

        print(f"Nombre d'avis récupérés : {len(donnees)}")
        for avis in donnees[:3]:
            print(avis)

