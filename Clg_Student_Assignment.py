import pandas as pd
df=pd.read_csv("final_college_student_placement_dataset.csv")

import pandas as pd
df=pd.read_csv("final_college_student_placement_dataset.csv")

df['Salary'] = pd.to_numeric(df['Salary'], errors='coerce')
def classify_salary(salary):
    if pd.isna(salary) or salary < 300000:
        return 'Low'
    elif 300000 <= salary <= 600000:
        return 'Medium'
    else:
        return 'High'
df['Salary_Band'] = df['Salary'].apply(classify_salary)

missing_rows_count = df.isnull().any(axis=1).sum()
print(missing_rows_count)

salary_missing_count = df[df['Salary'].isnull()]
print(salary_missing_count)

complete_records = df.dropna()

duplicate_rows = df[df.duplicated()]

df_no_duplicates = df.drop_duplicates()

duplicates_by_id = df[df.duplicated(subset='College_ID')]

unique_specializations = df['Specialization'].unique()

unique_mba_scores = df['MBA_Percentage'].nunique()

unique_combinations = df[['Gender', 'Specialization', 'placement_success']].drop_duplicates().shape[0]

avg_salary_of_placed = df[df['Placement'] == 'Yes']['Salary'].mean()
print(avg_salary_of_placed)

max_mba = df['MBA_Percentage'].max()
min_mba = df['MBA_Percentage'].min()
print(f"max:{max_mba},min:{min_mba}")

placement_count = df['Placement'].value_counts()
print(placement_count)

specialization_stats = df.groupby('Specialization').agg({
    'SSC_Percentage': 'mean',
    'MBA_Percentage': 'mean',
    'Placement': lambda x: (x == 'Yes').sum()
})
print(specialization_stats)

summary = pd.DataFrame({
    'Column': df.columns,
    'Null_Count': df.isnull().sum().values,
    'Unique_Values': df.nunique().values,
    'Duplicated_Values': [df[col].duplicated().sum() for col in df.columns]
})




