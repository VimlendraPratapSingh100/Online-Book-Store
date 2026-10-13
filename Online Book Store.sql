-- Create Database
CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Q1. Retrive all books in the "Fiction" genre:

SELECT * FROM Books
WHERE Genre = 'Fiction';

-- Q2. Find books published after the year 1950:

SELECT * FROM Books
WHERE Published_Year>1950 ;

-- Q3. List all customer from the canada:

SELECT * FROM Customers
WHERE Country = "Canada";

-- Q4. Show orders placed in November 2023:

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-01-01' AND '2023-01-30';

-- Q5.Retrive the total stocks of books available:

SELECT SUM(Stock) AS Total_stock
FROM Books;

-- Q6. Find the details of most expensive book

SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

-- Q7. Show all customer who orderded more than 1 quantity of book:

SELECT * FROM Orders
WHERE Quantity >1;

-- Q8.Retrive all orders where the total amount exceeds $20;

SELECT * FROM Orders
WHERE Total_Amount>20;

-- Q9. List all genres available in the books table;

SELECT  DISTINCT genre
FROM Books;


-- Q10. Find the book with the lowest stock.

SELECT *FROM Books
ORDER by Stock 
LIMIT 1;

-- Q11.calculate the total revenue generated from all orders.

SELECT SUM(Total_amount) AS  Revenue
FROM Orders;


-- Advance Query...

-- Q1). Retrive total number of books sold for each genre

SELECT * FROM Orders;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_Sold
FROM Books b
JOIN Orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Genre;

-- Q2). Find the average price of the books in the "fantasy" genre;

SELECT * FROM Books;

SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- Q3). List customers who have  placed at least 2 orders;

SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT  c.name,o.Customer_id, COUNT(o.order_id) AS Order_count
FROM Customers c
JOIN Orders o
ON c.Customer_ID= O.customer_id
GROUP BY o.customer_id , c.name
HAVING COUNT(order_id) >=2;

-- Q4). Find most frequently order book;

SELECT b.title, o.Book_id,COUNT(o.Order_id) AS Order_count
FROM Orders o
JOIN Books b
ON O.Book_id = b.Book_id
GROUP BY  o.Book_ID,b.title
ORDER BY Order_count DESC
LIMIT 1;

-- Q5). Show the top 3 most expensive books of 'Fantasy' Genre;

SELECT * FROM Books;


SELECT * FROM Books
WHERE  Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;

-- Q6). Retrive the total quantity of the books sold by each author;

SELECT * FROM Books;
SELECT * FROM Orders;


SELECT b.Author, SUM(o.Quantity) AS Total_book_sold
FROM Books b 
JOIN Orders o
ON b.Book_id = o.Book_id
GROUP BY b.Author;

-- Q7). List the cities where customer who spent over $30 are located;

SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT DISTINCT c.City,c.name ,o.Total_amount
FROM Customers c
JOIN Orders o
ON o.Customer_id=c.Customer_id
WHERE o.Total_amount>30;

-- Q8). Find the customer who spent the most on the order.

SELECT c.name ,c.Customer_id,SUM(o.Total_amount) AS Total_spent
FROM Orders o
JOIN Customers c
ON c.Customer_id = o. Customer_id
GROUP BY c.name,c.Customer_id
ORDER BY Total_spent DESC
LIMIT 1;


-- Q9). calculate the stock remaining after fulfilling all orders;

SELECT * FROM Books;
SELECT * FROM Orders;

SELECT b.Book_id,b.title,b.Stock, COALESCE(SUM(Quantity),0) AS Order_Quantity,
b.Stock - COALESCE(SUM(Quantity),0) AS Remaining_Quantity
FROM Books b LEFT JOIN Orders o
ON b.Book_id = o.Book_id
GROUP BY b.Book_id 
ORDER BY b.Book_id;
























