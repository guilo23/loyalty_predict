# %%

import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt

# import mlflow

# mlflow.set_tracking_uri("http://localhost:5000")
# mlflow.set_experiment(experiment_id=362674792473335685)

from sklearn import model_selection
from sklearn import pipeline
from sklearn import metrics
from sklearn import tree
from sklearn import ensemble

# from feature_engine import selection
# from feature_engine import imputation
# from feature_engine import encoding


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

con = sqlalchemy.create_engine("sqlite:///../../analytics/database.db")

# %%

## SAMPLE - IMPORT DOS DADOS

df = pd.read_sql("select * from abt_fiel", con)
df.head()

# %%

# SAMPLE - OOT

df_oot = df[df['dtRef']==df['dtRef'].max()].reset_index(drop=True)
df_oot

# %%

# SAMPLE - Teste e Treino

target = 'flFiel'
features = df.columns.tolist()[3:]

df_train_test = df[df['dtRef']<df['dtRef'].max()].reset_index(drop=True)

y = df_train_test[target]   # Isso é um pd.Series (vetor)
X = df_train_test[features] # Isso é um pd.DataFrame (matriz)

X_train, X_test, y_train, y_test = model_selection.train_test_split(
    X, y,
    test_size=0.2,
    random_state=42,
    stratify=y,
)

print(f"Base Treino: {y_train.shape[0]} Unid. | Tx. Target {100*y_train.mean():.2f}%")
print(f"Base Test: {y_test.shape[0]} Unid. | Tx. Target {100*y_test.mean():.2f}%")

# %%

# EXPLORE - MISSING

s_nas = X_train.isna().mean()
s_nas = s_nas[s_nas>0]

s_nas

# %%

## EXPLORE BIVARIADA


cat_features = ['descLifeCycleAtual', 'descLifeCycleD28','detRef','idTMWCliente']
num_features = list(set(features) - set(cat_features))

df_train = X_train.copy()
df_train[target] = y_train.copy()

df_train[num_features] = df_train[num_features].astype(float)

bivariada = df_train.groupby(target)[num_features].median().T
bivariada['ratio'] = (bivariada[1] + 0.001) / (bivariada[0]+0.001)
bivariada = bivariada.sort_values(by='ratio', ascending=False)
bivariada

# %%

# %%
df_train.groupby('descLifeCycleAtual')[target].mean()

# %%
df_train.groupby('descLifeCycleD28')[target].mean()

# %%