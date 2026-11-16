"""
Library website - Lab 4 (Flask + MySQL).
Run:  python app.py      then open  http://127.0.0.1:5000
"""
import pymysql
from flask import Flask, render_template, request

# ---- CHANGE THIS to your MySQL password ----
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "library",
    "charset": "utf8mb4",
}

app = Flask(__name__)


def run_query(sql, params=()):
    """Run one SELECT and return (column_names, rows). Values go through placeholders (%s)."""
    conn = pymysql.connect(**DB_CONFIG)
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
            columns = [d[0] for d in cur.description]
        return columns, rows
    finally:
        conn.close()


def section(title, sql, params=()):
    """One block (title + table) for a page. A SQL error is shown on the page, not a crash."""
    try:
        columns, rows = run_query(sql, params)
        return {"title": title, "columns": columns, "rows": rows, "error": None}
    except Exception as e:  # noqa
        return {"title": title, "columns": [], "rows": [], "error": str(e)}


def to_number(text, default):
    try:
        return float(text)
    except (TypeError, ValueError):
        return default


@app.route("/")
def index():
    return render_template("index.html")


# ---------------- F2.1 Search books ----------------
@app.route("/search")
def search():
    title = request.args.get("title", "").strip()
    min_price = to_number(request.args.get("min_price"), 0)
    max_price = to_number(request.args.get("max_price"), 1000000)
    category_id = request.args.get("category_id", "")

    sql = (
        "SELECT b.book_id, b.title, b.price, c.name AS category "
        "FROM book b JOIN category c ON b.category_id = c.category_id "
        "WHERE b.title LIKE %s AND b.price BETWEEN %s AND %s"
    )
    params = ["%" + title + "%", min_price, max_price]
    if category_id:
        sql += " AND b.category_id = %s"
        params.append(category_id)
    sql += " ORDER BY b.price ASC"

    result = section("Matching books (cheapest first)", sql, params)
    categories = section("categories", "SELECT category_id, name FROM category ORDER BY name")
    return render_template(
        "search.html",
        result=result,
        categories=categories["rows"],
        form={"title": title, "min_price": request.args.get("min_price", ""),
              "max_price": request.args.get("max_price", ""), "category_id": category_id},
    )


# ---------------- F2.2 Catalogue ----------------
@app.route("/catalogue")
def catalogue():
    sql = (
        "SELECT b.book_id, b.title, a.name AS author, p.name AS publisher, c.name AS category, "
        "b.price, b.publish_year "
        "FROM book b "
        "JOIN author a ON b.author_id = a.author_id "
        "JOIN publisher p ON b.publisher_id = p.publisher_id "
        "JOIN category c ON b.category_id = c.category_id "
        "ORDER BY b.book_id"
    )
    return render_template("report.html", page_title="F2.2 Catalogue",
                           sections=[section("All books", sql)])


# ---------------- F2.3 Reports ----------------
@app.route("/reports")
def reports():
    sections = [
        section("(a) Books and average price of each category",
                "SELECT c.name AS category, COUNT(*) AS books, ROUND(AVG(b.price), 2) AS average_price "
                "FROM book b JOIN category c ON b.category_id = c.category_id "
                "GROUP BY c.category_id, c.name"),
        section("(b) Authors who wrote at least 2 books",
                "SELECT a.name AS author, COUNT(*) AS books "
                "FROM author a JOIN book b ON b.author_id = a.author_id "
                "GROUP BY a.author_id, a.name HAVING COUNT(*) >= 2"),
        section("(c) Total, smallest and largest price of the library",
                "SELECT SUM(price) AS total_price, MIN(price) AS smallest_price, MAX(price) AS largest_price "
                "FROM book"),
    ]
    return render_template("report.html", page_title="F2.3 Reports", sections=sections)


# ---------------- F2.4 Loans ----------------
@app.route("/loans")
def loans():
    sections = [
        section("(a) Loans not returned yet",
                "SELECT l.loan_id, b.title AS book, m.name AS member, l.loan_date "
                "FROM loan l JOIN book b ON l.book_id = b.book_id "
                "JOIN member m ON l.member_id = m.member_id "
                "WHERE l.return_date IS NULL"),
        section("(b) Members who never borrowed a book",
                "SELECT m.member_id, m.name FROM member m "
                "LEFT JOIN loan l ON l.member_id = m.member_id WHERE l.loan_id IS NULL"),
        section("(c) Books that were never borrowed",
                "SELECT b.book_id, b.title FROM book b "
                "LEFT JOIN loan l ON l.book_id = b.book_id WHERE l.loan_id IS NULL"),
    ]
    return render_template("report.html", page_title="F2.4 Loans", sections=sections)


# ---------------- F2.5 Most borrowed ----------------
@app.route("/most-borrowed")
def most_borrowed():
    sections = [
        section("The 3 books with the most loans",
                "SELECT b.title, COUNT(*) AS loans FROM loan l JOIN book b ON l.book_id = b.book_id "
                "GROUP BY b.book_id, b.title ORDER BY loans DESC, b.title LIMIT 3"),
        section("The member with the most loans",
                "SELECT m.name, COUNT(*) AS loans FROM loan l JOIN member m ON l.member_id = m.member_id "
                "GROUP BY m.member_id, m.name ORDER BY loans DESC, m.name LIMIT 1"),
    ]
    return render_template("report.html", page_title="F2.5 Most borrowed", sections=sections)


# ---------------- F2.6 Authors and books ----------------
@app.route("/authors")
def authors():
    sections = [
        section("(a) Every author with the number of books (also 0)",
                "SELECT a.name AS author, COUNT(b.book_id) AS books "
                "FROM author a LEFT JOIN book b ON b.author_id = a.author_id "
                "GROUP BY a.author_id, a.name"),
        section("(b) Books whose author and publisher come from the same country",
                "SELECT b.title, a.name AS author, p.name AS publisher, a.country "
                "FROM book b JOIN author a ON b.author_id = a.author_id "
                "JOIN publisher p ON b.publisher_id = p.publisher_id "
                "WHERE a.country = p.country"),
    ]
    return render_template("report.html", page_title="F2.6 Authors and books", sections=sections)


if __name__ == "__main__":
    app.run(debug=True)
