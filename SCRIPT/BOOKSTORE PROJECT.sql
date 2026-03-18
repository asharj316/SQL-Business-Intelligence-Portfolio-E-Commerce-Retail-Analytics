-- ================================================================
-- BOOKSTORE MANAGEMENT SYSTEM
-- ================================================================


-- ----------------------------------------------------------------
-- CREATE TABLES
-- FIX: DROP order changed — Orders must be dropped first because it
--      has foreign keys referencing Books and Customers.
--      Dropping Books or Customers first causes a dependency error.
-- ----------------------------------------------------------------

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Books (
    Book_ID        SERIAL PRIMARY KEY,
    Title          VARCHAR(100),
    Author         VARCHAR(100),
    Genre          VARCHAR(50),
    Published_Year INT,
    Price          NUMERIC(10, 2),
    Stock          INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name        VARCHAR(100),
    Email       VARCHAR(100),
    Phone       VARCHAR(15),
    City        VARCHAR(50),
    Country     VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID     SERIAL PRIMARY KEY,
    Customer_ID  INT REFERENCES Customers(Customer_ID),
    Book_ID      INT REFERENCES Books(Book_ID),
    Order_Date   DATE,
    Quantity     INT,
    Total_Amount NUMERIC(10, 2)
);


-- ----------------------------------------------------------------
-- VERIFY TABLES
-- ----------------------------------------------------------------

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- ----------------------------------------------------------------
-- IMPORT DATA
-- Note: Update paths below to match your local file location
-- ----------------------------------------------------------------

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\Work\SQL\30 Day - SQL Practice Files\DATASET\Books.csv'
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\Work\SQL\30 Day - SQL Practice Files\DATASET\Customers.csv'
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\Work\SQL\30 Day - SQL Practice Files\DATASET\Orders.csv'
CSV HEADER;


-- ================================================================
-- BASIC QUESTIONS
-- ================================================================

-- 1) Retrieve all books in the "Fiction" genre:
-- FIX: Trailing comma after Genre removed  →  SELECT Title, Genre,  was invalid syntax
SELECT Title, Genre
FROM Books
WHERE Genre = 'Fiction';


-- 2) Find books published after the year 1950:
-- FIX: Missing semicolon added
SELECT Title, Published_Year
FROM Books
WHERE Published_Year > 1950;


-- 3) List all customers from Canada:
-- FIX: Missing semicolon added
SELECT Name, Country
FROM Customers
WHERE Country = 'Canada';


-- 4) Show orders placed in November 2023:
-- FIX: Year was 2024 in both dates — corrected to 2023
SELECT *
FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';


-- 5) Retrieve the total stock of books available:
-- FIX: Two SELECT statements were written without a semicolon between them.
--      First SELECT * had no purpose — removed. Kept the meaningful SUM query.
SELECT SUM(Stock) AS Total_Stock
FROM Books;


-- 6) Find the details of the most expensive book:
-- FIX: Two SELECT statements written without a semicolon between them.
--      MAX(Price) only returns the price number, not the book details.
--      Replaced with ORDER BY Price DESC LIMIT 1 to get full book row.
SELECT *
FROM Books
ORDER BY Price DESC
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT Order_ID, Book_ID, Customer_ID, Quantity
FROM Orders
WHERE Quantity > 1;


-- 8) Retrieve all orders where the total amount exceeds $20:
-- FIX: Was querying FROM Books WHERE price > 20 — wrong table.
--      Orders table has Total_Amount, which is what the question asks for.
SELECT *
FROM Orders
WHERE Total_Amount > 20;


-- 9) List all genres available in the Books table:
-- FIX: Two SELECT statements written without a semicolon between them.
--      Kept both — first gives total count, second gives breakdown per genre.
SELECT COUNT(DISTINCT Genre) AS Total_Genres
FROM Books;

SELECT Genre, COUNT(*) AS Books_In_Genre
FROM Books
GROUP BY Genre
ORDER BY Books_In_Genre DESC;


-- 10) Find the book with the lowest stock:
-- FIX: Was querying MIN(quantity) FROM Orders — wrong table and wrong column.
--      Stock lives in the Books table, not Orders.
SELECT *
FROM Books
ORDER BY Stock ASC
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT CAST(SUM(Total_Amount) AS NUMERIC(12, 2)) AS Total_Revenue
FROM Orders;


-- ================================================================
-- ADVANCED QUESTIONS
-- ================================================================

-- 1) Retrieve the total number of books sold for each genre:
-- FIX: Changed FULL JOIN to LEFT JOIN.
--      FULL JOIN returns genres with no orders AND orders with no matching book,
--      producing NULL rows that pollute the result. LEFT JOIN keeps all genres
--      and correctly shows 0 sales for genres with no orders.
SELECT Books.Genre, COALESCE(SUM(Orders.Quantity), 0) AS Total_Quantity_Sold
FROM Books
LEFT JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Genre
ORDER BY Total_Quantity_Sold DESC;


-- 2) Find the average price of books in the "Fantasy" genre:
-- FIX: Missing semicolon added.
--      Also added WHERE Genre = 'Fantasy' so it only returns Fantasy,
--      not every genre (which is what GROUP BY Genre alone would give).
SELECT Genre, CAST(AVG(Price) AS NUMERIC(10, 2)) AS Avg_Price
FROM Books
WHERE Genre = 'Fantasy'
GROUP BY Genre;


-- 3) List customers who have placed at least 2 orders:
-- FIX: Was using WHERE quantity > 1 which checks a single order's quantity,
--      not how many orders a customer placed.
--      Also FULL JOIN changed to INNER JOIN — we only want customers who
--      actually have orders. Used HAVING COUNT >= 2 for correct logic.
SELECT Customers.Name, Customers.Customer_ID, COUNT(Orders.Order_ID) AS Total_Orders
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY Customers.Customer_ID, Customers.Name
HAVING COUNT(Orders.Order_ID) >= 2
ORDER BY Total_Orders DESC;


-- 4) Find the 3 most frequently ordered books:
-- FIX: Changed FULL JOIN to LEFT JOIN — FULL JOIN produces NULL rows for
--      orders with no matching book, which distorts the COUNT result.
SELECT Books.Title, COUNT(Orders.Order_ID) AS Times_Ordered
FROM Books
LEFT JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Book_ID, Books.Title
ORDER BY Times_Ordered DESC
LIMIT 3;


-- 5) Show the top 3 most expensive books of 'Fantasy' genre:
-- FIX: Was using MAX(price) GROUP BY Genre — this returns only ONE row per
--      genre (the max price), not the top 3 individual Fantasy books.
--      Replaced with WHERE Genre = 'Fantasy' ORDER BY Price DESC LIMIT 3.
SELECT Title, Author, Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:
SELECT Books.Author, SUM(Orders.Quantity) AS Total_Units_Sold
FROM Books
JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Author
ORDER BY Total_Units_Sold DESC;


-- 7) List the cities where customers who spent over $30 are located:
SELECT DISTINCT Customers.City
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
WHERE Orders.Total_Amount > 30
ORDER BY Customers.City;


-- 8) Find the customer who spent the most on orders:
SELECT Customers.Customer_ID, Customers.Name,
       CAST(SUM(Orders.Total_Amount) AS NUMERIC(10, 2)) AS Total_Spent
FROM Customers
JOIN Orders ON Customers.Customer_ID = Orders.Customer_ID
GROUP BY Customers.Customer_ID, Customers.Name
ORDER BY Total_Spent DESC
LIMIT 1;


-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT Books.Title,
       Books.Stock                                     AS Initial_Stock,
       COALESCE(SUM(Orders.Quantity), 0)               AS Units_Sold,
       Books.Stock - COALESCE(SUM(Orders.Quantity), 0) AS Remaining_Stock
FROM Books
LEFT JOIN Orders ON Books.Book_ID = Orders.Book_ID
GROUP BY Books.Book_ID, Books.Title, Books.Stock
ORDER BY Remaining_Stock ASC;