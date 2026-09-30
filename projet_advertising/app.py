from fastapi import FastAPI
import joblib
import pandas as pd

app = FastAPI(
    title="API de prédiction des ventes publicitaires",
    description="prédit les ventes en fonction des budgets tv, radio, newspapper via le modèle XGBoost", 
    version="1.0"
)

model = joblib.load('xgboost_advertising_model.pkl')
@app.get("/")
def home():
    return {"message": "Bienvenue, l'API est en ligne. RDV sur /docs pour tester"}
@app.post("/predict")
def predict_sales(tv: float, radio:float, newspaper: float):
    input_data = pd.DataFrame([[tv, radio, newspaper]],
                              columns=['TV Ad Budget ($)', 'Radio Ad Budget ($)', 'Newspaper Ad Budget ($)'])

    prediction = model.predict(input_data)

    return {
        "budgets": {
            "tv": tv,
            "radio": radio,
            "newspaper": newspaper
        },
        "predicted_sales": round(float(prediction[0]), 2)
    }