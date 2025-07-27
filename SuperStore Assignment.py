import pandas as pd
df=pd.read_csv("Superstore.csv")

print(df.head())
print(df.shape)
print(df.dtypes)

df.columns=df.columns.str.replace("/","_").str.replace(" ","_")
df['Order_Date']=pd.to_datetime(df['Order_Date'],errors='coerce')
df['Ship_Date']=pd.to_datetime(df['Ship_Date'],errors='coerce')

grouped = df.groupby(['Region', 'Category']).agg({
    'Sales': 'sum',
    'Profit': 'sum',
    'Discount': 'mean'}).reset_index()
print(grouped)

top_products = df.groupby('Product Name')['Profit'].sum().sort_values(ascending=False).head(5)
print(top_products)

loss_orders = df[df['Profit'] < 0]
loss_orders.to_csv("loss_orders.csv", index=False)

df['Order_Month'] = df['Order_Date'].dt.to_period('M')
monthly_sales = df.groupby('Order_Month')['Sales'].sum().reset_index()
print(monthly_sales)

avg_order_value = df.groupby('City')['Sales'].mean().sort_values(ascending=False).head(10)
print(avg_order_value)

print(df.isnull().sum())
df['Price'] = df['Sales'] / df['Quantity']
df['Price'] = df['Price'].fillna(1)
