# MIT License - Copyright (c) 2026 InfraGuard AI Contributors
# InfraGuard AI - Power Outage Prediction Model
# ============================================================
# XGBoost time-series model for predicting power outages 24-72 hours
# in advance using weather, historical ECG data, and load patterns.

# %% [markdown]
# # Power Outage Prediction Model (Dumsor AI)
# ## InfraGuard AI - Predictive Intelligence
#
# Predicts outages 24-72 hours ahead using:
# - Historical outage data from ECG
# - Weather forecasts (rainfall, temperature, humidity)
# - Load patterns (daily/weekly/seasonal cycles)
# - Equipment age and maintenance history
# - Calendar events (market days, holidays)

# %% Imports
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report, roc_auc_score
from sklearn.preprocessing import LabelEncoder

# In production, use:
# import xgboost as xgb
# import torch  # for PyTorch degradation forecasting

print("Outage Prediction Model - InfraGuard AI")

# %% [markdown]
# ## 1. Synthetic Ghana ECG Data Generation

# %% Generate synthetic data
np.random.seed(42)
N = 5000  # 5000 historical data points

regions = ['Greater Accra', 'Ashanti', 'Northern', 'Central', 'Volta',
           'Western', 'Eastern', 'Bono', 'Upper East', 'Upper West']


def generate_training_data(n_samples):
    """Generate synthetic training data mimicking Ghana power grid patterns."""

    data = {
        'region': np.random.choice(regions, n_samples),
        'month': np.random.randint(1, 13, n_samples),
        'day_of_week': np.random.randint(0, 7, n_samples),
        'hour': np.random.randint(0, 24, n_samples),

        # Weather features
        'temperature_c': np.random.normal(30, 5, n_samples),
        'humidity_pct': np.random.normal(70, 15, n_samples),
        'rainfall_mm': np.abs(np.random.exponential(5, n_samples)),
        'wind_speed_kmh': np.abs(np.random.normal(10, 5, n_samples)),

        # Grid features
        'load_mw': np.random.normal(1500, 300, n_samples),
        'peak_load_ratio': np.random.uniform(0.5, 1.2, n_samples),
        'transformer_age_years': np.random.exponential(8, n_samples),
        'days_since_maintenance': np.random.exponential(60, n_samples),
        'previous_outages_30d': np.random.poisson(2, n_samples),

        # Calendar
        'is_market_day': np.random.binomial(1, 0.15, n_samples),
        'is_holiday': np.random.binomial(1, 0.05, n_samples),
        'is_rainy_season': np.zeros(n_samples),
    }

    # Rainy season: Apr-Jul and Sep-Nov for southern Ghana
    data['is_rainy_season'] = np.isin(
        data['month'], [4, 5, 6, 7, 9, 10, 11]).astype(int)

    # Harmattan: Dec-Feb
    data['is_harmattan'] = np.isin(data['month'], [12, 1, 2]).astype(int)

    df = pd.DataFrame(data)

    # Generate target: outage probability
    # Higher risk with: high temp, heavy rain, old equipment, high load
    outage_score = (
        0.15 * (df['temperature_c'] > 33).astype(float) +
        0.20 * (df['rainfall_mm'] > 10).astype(float) +
        0.15 * (df['transformer_age_years'] > 10).astype(float) +
        0.10 * (df['peak_load_ratio'] > 0.9).astype(float) +
        0.10 * (df['days_since_maintenance'] > 90).astype(float) +
        0.08 * (df['previous_outages_30d'] > 3).astype(float) +
        0.05 * df['is_market_day'] +
        0.05 * df['is_rainy_season'] +
        0.05 * df['is_harmattan'] +
        np.random.normal(0, 0.1, n_samples)
    )

    df['outage_occurred'] = (outage_score > 0.35).astype(int)

    return df


df = generate_training_data(N)
print(f"Dataset shape: {df.shape}")
print(f"Outage rate: {df['outage_occurred'].mean():.2%}")
print(f"\nFeature columns: {list(df.columns)}")

# %% [markdown]
# ## 2. Feature Engineering

# %% Feature engineering
le = LabelEncoder()
df['region_encoded'] = le.fit_transform(df['region'])

feature_cols = [
    'region_encoded', 'month', 'day_of_week', 'hour',
    'temperature_c', 'humidity_pct', 'rainfall_mm', 'wind_speed_kmh',
    'load_mw', 'peak_load_ratio', 'transformer_age_years',
    'days_since_maintenance', 'previous_outages_30d',
    'is_market_day', 'is_holiday', 'is_rainy_season', 'is_harmattan',
]

X = df[feature_cols]
y = df['outage_occurred']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y)

print(f"Train: {X_train.shape}, Test: {X_test.shape}")
print(f"Train outage rate: {y_train.mean():.2%}")

# %% [markdown]
# ## 3. Model Training (XGBoost)
#
# XGBoost chosen for:
# - Handles tabular data excellently
# - Fast training and inference
# - Feature importance for explainability
# - Can run as Supabase Edge Function

# %% Train model (using sklearn RandomForest as XGBoost stand-in for demo)

# In production use: xgb.XGBClassifier(...)
model = GradientBoostingClassifier(
    n_estimators=200,
    max_depth=6,
    learning_rate=0.1,
    min_samples_split=10,
    random_state=42,
)

model.fit(X_train, y_train)

y_pred = model.predict(X_test)
y_prob = model.predict_proba(X_test)[:, 1]

print("\n=== Model Performance ===")
print(f"Accuracy: {accuracy_score(y_test, y_pred):.3f}")
print(f"AUC-ROC: {roc_auc_score(y_test, y_prob):.3f}")
print(f"\n{classification_report(y_test, y_pred)}")

# %% Feature importance
importances = pd.DataFrame({
    'feature': feature_cols,
    'importance': model.feature_importances_,
}).sort_values('importance', ascending=False)

print("\n=== Feature Importance ===")
for _, row in importances.head(10).iterrows():
    bar = '█' * int(row['importance'] * 50)
    print(f"{row['feature']:<25} {row['importance']:.3f} {bar}")

# %% [markdown]
# ## 4. Prediction Function

# %% Predict


def predict_outage(region, weather, grid_state):
    """Predict outage probability for a region in next 24-72 hours."""
    features = pd.DataFrame([{
        'region_encoded': le.transform([region])[0],
        'month': weather.get('month', 3),
        'day_of_week': weather.get('day_of_week', 2),
        'hour': weather.get('hour', 14),
        'temperature_c': weather.get('temperature', 32),
        'humidity_pct': weather.get('humidity', 75),
        'rainfall_mm': weather.get('rainfall', 0),
        'wind_speed_kmh': weather.get('wind_speed', 10),
        'load_mw': grid_state.get('current_load', 1500),
        'peak_load_ratio': grid_state.get('peak_ratio', 0.85),
        'transformer_age_years': grid_state.get('transformer_age', 8),
        'days_since_maintenance': grid_state.get('days_since_maintenance', 60),
        'previous_outages_30d': grid_state.get('previous_outages', 2),
        'is_market_day': int(weather.get('is_market_day', False)),
        'is_holiday': int(weather.get('is_holiday', False)),
        'is_rainy_season': int(weather.get('month', 3) in [4, 5, 6, 7, 9, 10, 11]),
        'is_harmattan': int(weather.get('month', 3) in [12, 1, 2]),
    }])

    prob = model.predict_proba(features)[0][1]
    risk = 'LOW' if prob < 0.3 else 'MEDIUM' if prob < 0.6 else 'HIGH' if prob < 0.8 else 'CRITICAL'

    return {
        'region': region,
        'probability': round(float(prob), 3),
        'risk_level': risk,
        'top_factors': importances.head(5)['feature'].tolist(),
        'recommendation': _get_recommendation(risk),
    }


def _get_recommendation(risk):
    recs = {
        'LOW': 'No action needed. Continue normal monitoring.',
        'MEDIUM': 'Increase monitoring frequency. Pre-position repair crews.',
        'HIGH': 'Alert ECG operations. Prepare backup generators for critical facilities.',
        'CRITICAL': 'IMMEDIATE: Deploy all available crews. Notify hospitals and water treatment plants.',
    }
    return recs[risk]


# Test prediction
result = predict_outage(
    region='Greater Accra',
    weather={'temperature': 35, 'humidity': 85, 'rainfall': 15, 'month': 6},
    grid_state={'transformer_age': 12,
                'days_since_maintenance': 95, 'previous_outages': 4},
)

print(f"\n=== Prediction Result ===")
for k, v in result.items():
    print(f"  {k}: {v}")

# %% [markdown]
# ## Next Steps
#
# 1. **Real ECG data integration** via Supabase Edge Function
# 2. **Weather API** connection (OpenWeatherMap)
# 3. **PyTorch LSTM** for time-series degradation forecasting
# 4. **A/B testing** framework for model versions
# 5. **Explainability** dashboard for ECG engineers
