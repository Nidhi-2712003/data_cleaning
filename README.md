# Data Cleaning Project – Club Member Dataset (PostgreSQL)
(Note - This project uses a publicly available dataset originally published by [iweld](https://github.com/iweld/data_cleaning). All SQL cleaning logic and documentation were developed independently.)


## Objective
Design and implement a structured SQL-based data cleaning pipeline using PostgreSQL to transform raw club member data into a validated, analysis-ready format.

## 🛠️ Tools & Technologies
- PostgreSQL (pgAdmin 4)
- SQL string, regex, and conditional functions
- Optional: Excel (for raw vs cleaned data comparison)

## Problem Statement
Raw member data often contains inconsistencies such as extra spaces, invalid characters, null values, and formatting issues. These errors can distort analysis and reporting. This project focuses on cleaning and standardizing such data using SQL transformations.

## Cleaning Logic
- ✅ Dropped existing tables if present to avoid duplication
- ✅ Created structured tables with defined columns and primary keys
- ✅ Trimmed whitespace and converted text to lowercase
- ✅ Removed special characters using regex
- ✅ Handled null and blank values with conditional logic
- ✅ Normalized categorical fields like marital status
- ✅ Standardized formats for age, email, and phone numbers
- ✅ Split address fields and corrected date anomalies

## Outcome
- Produced a clean, validated dataset ready for downstream processing
- Ensured high data quality for reliable reporting and visualization
- Demonstrated proficiency in SQL-based ETL and transformation logic

## Repository Highlights
- `data_cleaning.sql`: SQL script containing all transformation steps
- `README.md`: Project documentation and summary

## Skills Demonstrated
- SQL data profiling and transformation
- Regex and conditional logic in PostgreSQL
- ETL pipeline design for relational databases


## 📊 SQL Data Cleaning Queries

### Complete Data Cleaning Query

```sql
SELECT
    regexp_replace(lower(trim(full_name)), '[^a-z0-9 ]', '', 'g') AS cleaned_name,
    
    CASE
        WHEN length(age::text) = 0 THEN NULL
        WHEN length(age::text) = 3 THEN substr(age::text, 1, 2)::numeric
        ELSE age
    END AS cleaned_age,
    
    CASE
        WHEN trim(martial_status) = '' THEN NULL
        ELSE trim(martial_status)
    END AS cleaned_marital_status,
    
    regexp_replace(trim(lower(email)), '[^a-z0-9@._]', '', 'g') AS cleaned_email,
    
    CASE
        WHEN trim(phone) = '' THEN NULL
        WHEN length(trim(phone)) < 12 THEN NULL
        ELSE trim(phone)
    END AS cleaned_phone,
    
    regexp_replace(split_part(full_address, ',', 1), '[^a-zA-Z0-9 ]', '', 'g') AS street_address,
    regexp_replace(split_part(full_address, ',', 2), '[^a-zA-Z0-9 ]', '', 'g') AS city,
    regexp_replace(split_part(full_address, ',', 3), '[^a-zA-Z0-9 ]', '', 'g') AS state,
    
    regexp_replace(trim(lower(job_title)), '[^a-z0-9 ]', '', 'g') AS cleaned_job_title,
    
    CASE
        WHEN EXTRACT(YEAR FROM TO_DATE(membership_date, 'MM/DD/YYYY')) < 2000
        THEN TO_DATE(
            REPLACE(EXTRACT(YEAR FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, '19', '20')
            || '-' || LPAD(EXTRACT(MONTH FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, 2, '0')
            || '-' || LPAD(EXTRACT(DAY FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, 2, '0'),
            'YYYY-MM-DD')
        ELSE TO_DATE(membership_date, 'MM/DD/YYYY')
    END AS cleaned_membership_date
    
FROM club_member_info;
```

## 📋 Sample Output Data

### Cleaned Data Sample

Below is a sample of the cleaned output data showing the transformation results:

| Cleaned Name | Age | Marital Status | Email | Phone | City | State | Job Title | Cleaned Date |
|--------------|-----|----------------|-------|-------|------|-------|-----------|-------------|
| arda allam | 36 | Married | aallam64nps.gov | 415-797-9281 | San Rafael | California | human resources assistant i | 2012-01-10 |
| aeriell angelini | 32 | Married | aangeliniluwhitehouse.gov | 806-508-7374 | Amarillo | Texas | database administrator i | 2013-07-10 |
| aurore averill | 28 | Married | aaverill5itheglobeandmail.com | 713-330-3502 | Houston | Texas | account coordinator | 2019-05-11 |
| annemarie balsom | 52 | Divorced | abalsomnywired.com | 718-247-6744 | Jamaica | New York | design engineer | 2014-03-06 |
| alicea bamell | 52 | Married | abamellpcsquidoo.com | 850-167-7028 | Tallahassee | Florida | help desk technician | 2021-09-14 |

### Key Transformations Applied:

1. **Name Cleaning**: Converted to lowercase, removed special characters
2. **Age Validation**: Fixed 3-digit ages, set invalid values to NULL
3. **Email Standardization**: Cleaned and normalized email format
4. **Phone Validation**: Removed invalid phone numbers (< 12 characters)
5. **Address Parsing**: Split full address into street, city, and state
6. **Date Correction**: Fixed membership dates with years before 2000
7. **Marital Status**: Standardized values and handled blanks

---

## 💾 Repository Structure

```
PostgreSQL_Data_Cleaning_Project/
│
├── README.md                    # Project documentation
├── data_cleaning.sql             # SQL cleaning script
└── Club_member_info_Project.xlsx # Sample dataset (raw + cleaned)
```
