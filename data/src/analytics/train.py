# %%
import pandas as pd
import sqlalchemy 


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


conn = sqlalchemy.create_engine("sqlite:///../../analytics/database.db")

# %%

#SAMPLE - IMPORT DOS DADOS

df = pd.read_sql("select * from abt_fiel",conn)
df.head()
# %%
for i in df.columns:
        print(i,type(i))
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

# MODIFY

X_train[num_features] = X_train[num_features].astype(float)

from feature_engine import selection

to_remove = bivariada[bivariada['ratio']==1].index.tolist()

drop_features = selection.DropFeatures(to_remove)

x_train_transform = drop_features.fit_transform(X_train,Y_train)

# %%
from feature_engine import imputation
from feature_engine import encoding

cat_features = ['descLifeCycleAtual','descLifeCycleD28']

onehot = encoding.OneHotEncoder(variables=cat_features)

fill_0 = ['github2025','python2025']
imput_0 = imputation.ArbitraryNumberImputer(arbitrary_number=0,variables=fill_0)

input_new = imputation.CategoricalImputer(fill_value='Não Usuario',
                                          variables=['descLifeCycleAtual','descLifeCycleD28'])

input_1000 = imputation.ArbitraryNumberImputer(arbitrary_number=1000,
                                          variables=['avgIntervalDiasVida',
                                                     'avgIntervalD28',
                                                     'ultimaInteracao'])
x_train_transform = drop_features.fit_transform(X_train)
x_train_transform = imput_0.fit_transform(x_train_transform)
x_train_transform = input_new.fit_transform(x_train_transform)
x_train_transform = input_1000.fit_transform(x_train_transform)
x_train_transform = onehot.fit_transform(x_train_transform)


x_train_transform -= x_train_transform['detRef']

x_train_transform.head()

from sklearn import tree

model = tree.DecisionTreeClassifier(random_state=42)
model.fit(x_train_transform,Y_train)

# %%

# assess

from sklearn import metrics



y_pred_train = model.predict(x_train_transform)
y_proba_train = model.predict_proba(x_train_transform)

acc_train = metrics.accuracy_score(Y_train,y_pred_train)
auc_train = metrics.roc_auc_score(Y_train,y_proba_train[:,1])
print(f"Acuracia Treino: {(acc_train*100):.2f}%")
print(f"AUC Treino: {(auc_train*100):.2f}%")


x_test_transform = drop_features.transform(X_test)
x_test_transform = imput_0.transform(x_test_transform)
x_test_transform = input_new.transform(x_test_transform)
x_test_transform = input_1000.transform(x_test_transform)
x_test_transform = onehot.transform(x_test_transform)

x_test_transform -= x_test_transform['detRef']

y_pred_test = model.predict(x_test_transform)
y_proba_test = model.predict_proba(x_test_transform)


acc_test = metrics.accuracy_score(Y_test,y_pred_test)
auc_test = metrics.roc_auc_score(Y_test,y_proba_test[:,1])
print(f"Acuracia Teste: {(acc_test*100):.2f}%")
print(f"AUC Teste: {(auc_test*100):.2f}%")
# %%
