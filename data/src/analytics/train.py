# %%
import pandas as pd
import sqlalchemy 


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


conn = sqlalchemy.create_engine("sqlite:///../../analytics/database.db")

# %%

#SAMPLE - IMPORT DOS DADOS

df = pd.read_sql("abt_fiel",conn)
df.head()
# %%

# SAMPLE OOT

df_oot = df[df['dtRef']==df['dtRef'].max()].reset_index(drop=True)
df_oot
# %%

target = 'flFiel'

features = df.columns.tolist()[3:]

df_train_test = df[df['dtRef'] < df['dtRef'].max()].reset_index(drop=True)

df_train_test

x = df_train_test[features]
y = df_train_test[target]

from sklearn import model_selection

X_train, X_test, Y_train, Y_test = model_selection.train_test_split(
    x, y,
    test_size=0.2,
    random_state=42,
    stratify=y
)

print(f"Base Treino: {Y_train.shape[0]} unid. | Tx. Target {100*Y_train.mean():.2f}%")
print(f"Base Test: {Y_test.shape[0]} unid. | Tx. Target {100*Y_test.mean():.2f}%")
# %%


s_nas = X_train.isna().mean()
s_nas = s_nas[s_nas>0]
s_nas
# %%

cat_features = ['descLifeCycleAtual', 'descLifeCycleD28','detRef','idTMWCliente']

num_features = list(set(features) - set(cat_features))
num_features




df_train = X_train.copy()
df_train[target] = Y_train.copy()

df_train[num_features] = df_train[num_features].astype(float)

bivariada = df_train.groupby(target)[num_features].median().T

bivariada['ratio'] = (bivariada[1] + 0.001) / (bivariada[0]+0.001)
bivariada.sort_values(by='ratio',ascending=False)
# %%

df_train.groupby('descLifeCycleAtual')[target].mean()


df_train.groupby('descLifeCycleD28')[target].mean()

len(num_features)
# %%
