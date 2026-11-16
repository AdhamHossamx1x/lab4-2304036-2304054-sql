# Lab 4 - Search Queries in SQL

Introduction to Database Systems - Alexandria National University, Faculty of Engineering - Fall 2026

## What is inside

| File | What it is |
|---|---|
| `problem1_DDL.sql` | creates the `company` database and its 5 tables |
| `problem1_DML.sql` | our rows for the 5 tables |
| `problem1_Queries.sql` | the SQL of Q1.1 - Q1.12 (used to build the answers file) |
| `problem1_Answers.txt` | the SQL we used for Q1.1 - Q1.12 and its output / error |
| `problem2_DDL.sql` | creates the `library` database and its 6 tables |
| `problem2_DML.sql` | seed data for the 6 tables |
| `problem2_Queries.sql` | the SQL of the pages F2.1 - F2.6 |
| `website/` | the Flask website with the new search pages |

## Requirements

- MySQL Server 8 and the MySQL client (`mysql`)
- Python 3.10+ (PyCharm)
- DBeaver (optional, to look at the data)

## Step 1 - Problem 1 (company)

Open **Command Prompt** (cmd) in this folder, then run (type your MySQL password when asked):

```
mysql -u root -p < problem1_DDL.sql
mysql -u root -p < problem1_DML.sql
mysql -u root -p --table -vvv --force --comments company < problem1_Queries.sql > problem1_Answers.txt 2>&1
```

The last command runs all the questions and writes the SQL + output (or error) in `problem1_Answers.txt`.

## Step 2 - Problem 2 (library)

```
mysql -u root -p < problem2_DDL.sql
mysql -u root -p < problem2_DML.sql
mysql -u root -p library < problem2_Queries.sql
```

## Step 3 - Run the website

1. Open `website/app.py` and write your MySQL password in `DB_CONFIG` (`"password": "..."`).
2. In a terminal:

```
cd website
pip install -r requirements.txt
python app.py
```

3. Open http://127.0.0.1:5000 in the browser.

Pages: F2.1 `/search`, F2.2 `/catalogue`, F2.3 `/reports`, F2.4 `/loans`, F2.5 `/most-borrowed`, F2.6 `/authors`.

## Bonus - prepared statements

The search form (F2.1) never builds the SQL text from what the user typed. The SQL uses placeholders (`%s`) and the
values are sent separately, so a user cannot inject SQL.
