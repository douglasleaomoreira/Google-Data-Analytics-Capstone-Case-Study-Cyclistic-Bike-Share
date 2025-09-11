# 5. Data Exploration.py

from google.colab import files
uploaded = files.upload()

import os
os.listdir()

!pip install pandas
import pandas as pd

df = pd.read_csv("all_trips_v3.csv")
df.head()
df.tail()
counts = df['year'].value_counts()
print(counts)
df.info()

df['started_at'] = pd.to_datetime(df['started_at'], format='mixed')

df['date'] = df['started_at'].dt.date
df['month'] = df['started_at'].dt.month
df['day'] = df['started_at'].dt.day
df['year'] = df['started_at'].dt.year
df.describe()

counts = df['year'].value_counts()
print(counts)
df.head()
df.tail()
df.info()

df = df.drop(columns=['Unnamed: 0'])
df = df.drop(columns=['ride_id'])
df = df.drop(columns=['started_at'])
df = df.drop(columns=['ended_at'])
df.head()
df.tail()

counts = df['year'].value_counts()
print(counts)

duplicate_rows = df[df.duplicated()]
print(duplicate_rows)

df[df.duplicated(keep=False)]

missing_values = df.isnull()
print(missing_values)

missing_count_per_column = df.isnull().sum()
print(missing_count_per_column)

df.isna().sum()
df.isna().sum().sum()

df_2019 = df[df['year'] == 2019]
df_2020 = df[df['year'] == 2020]

print("2019 rides:", len(df_2019))
print("2020 rides:", len(df_2020))

df_2019.head()
df_2020.head()

df_2019.to_csv("trips_2019_v3.csv", index=False)
df_2020.to_csv("trips_2020_v3.csv", index=False)

from google.colab import files
files.download("trips_2019_v3.csv")
files.download("trips_2020_v3.csv")

print("2019 rows:", len(df_2019))

print("2020 rows:", len(df_2020))
