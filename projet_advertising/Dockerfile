from python:3.10-slim
workdir /app
copy requirements.txt .
run pip install --no-cache-dir -r requirements.txt
copy app.py .
copy xgboost_advertising_model.pkl .
expose 8000
cmd ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]