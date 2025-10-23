# %%
import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt

# %%

engine = sqlalchemy.create_engine("sqlite:///../../database.db")
# %%

def import_query(path):
    with open(path) as open_file:
        return open_file.read()
query = import_query("frequencia_valor.sql")

# %%

df = pd.read_sql(query,engine)
df.head()
print(df.columns.tolist())

df = df[df['QtdePontosPOS'] < 4000]
# %%

plt.plot(df['qtdeFrequencia'],df['QtdePontosPOS'],'o')
plt.grid(True)
plt.xlabel("Frequencia")
plt.ylabel("valor")
plt.show()
# %%

from sklearn import cluster
from sklearn import preprocessing

minMax = preprocessing.MinMaxScaler()
x = minMax.fit_transform(df[['qtdeFrequencia','QtdePontosPOS']])

df_x = pd.DataFrame(x,columns=['normFreq','normValor'])
df_x
print(df_x.columns.tolist())



kmean = cluster .KMeans(n_clusters=7,
                        random_state=42,
                        max_iter=1000)

kmean.fit(x)

df['cluster_calc'] = kmean.labels_
df_x['cluster'] = kmean.labels_


df.groupby(by='cluster_calc')['idCliente'].count()
# %%

import seaborn as sns

sns.scatterplot(data=df,
                x="qtdeFrequencia",
                y="QtdePontosPOS",
                hue="cluster_calc",
                palette="deep")

plt.hlines(y=1500, xmin=0,xmax=25, colors='black')
plt.hlines(y=750, xmin=0,xmax=25, colors='black')
plt.vlines(x=4, ymin=0,ymax=750, colors='black')
plt.vlines(x=10, ymin=0,ymax=3000, colors='black')
plt.grid()

# %%

sns.scatterplot(data=df,
                x="qtdeFrequencia",
                y="QtdePontosPOS",
                hue="cluster",
                palette="deep")

plt.grid()

# %%
