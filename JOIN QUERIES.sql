-- Create the DEPT table first, as PERSON depends on it
CREATE TABLE DEPT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentCode VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

-- Create the PERSON table with a Foreign Key
CREATE TABLE PERSON (
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATE NOT NULL,
    City VARCHAR(100) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES DEPT(DepartmentID)
);

-- Insert data into the DEPT table
INSERT INTO DEPT (DepartmentID, DepartmentName, DepartmentCode, Location)
VALUES
(1, 'Admin', 'Adm', 'A-Block'),
(2, 'Computer', 'CE', 'C-Block'),
(3, 'Civil', 'CI', 'G-Block'),
(4, 'Electrical', 'EE', 'E-Block'),
(5, 'Mechanical', 'ME', 'B-Block'),
(6, 'Marketing', 'Mkt', 'F-Block'),
(7, 'Accounts', 'Acc', 'A-Block');

-- Insert data into the PERSON table
INSERT INTO PERSON (PersonID, PersonName, DepartmentID, Salary, JoiningDate, City)
VALUES
(101, 'Rahul Tripathi', 2, 56000.00, '2000-01-01', 'Rajkot'),
(102, 'Hardik Pandya', 3, 18000.00, '2001-09-25', 'Ahmedabad'),
(103, 'Bhavin Kanani', 4, 25000.00, '2000-05-14', 'Baroda'),
(104, 'Bhoomi Vaishnav', 1, 39000.00, '2005-02-08', 'Rajkot'),
(105, 'Rohit Topiya', 2, 17000.00, '2001-07-23', 'Jamnagar'),
(106, 'Priya Menpara', NULL, 9000.00, '2000-10-18', 'Ahmedabad'),
(107, 'Neha Sharma', 2, 34000.00, '2002-12-25', 'Rajkot'),
(108, 'Nayan Goswami', 3, 25000.00, '2001-07-01', 'Rajkot'),
(109, 'Mehul Bhundiya', 4, 13500.00, '2005-01-09', 'Baroda'),
(110, 'Mohit Maru', 5, 14000.00, '2000-05-25', 'Jamnagar'),
(111, 'Alok Nath', 2, 36000.00, '2003-03-15', 'Ahmedabad'),
(112, 'Seema Jain', 3, 28000.00, '2002-06-18', 'Baroda'),
(113, 'Karan Singh', 1, 41000.00, '2004-11-30', 'Rajkot'),
(114, 'Riya Gupta', 5, 16000.00, '2001-02-12', 'Ahmedabad'),
(115, 'Suresh Patel', 7, 32000.00, '2003-08-20', 'Jamnagar'),
(116, 'Meena Kumari', 7, 30000.00, '2004-01-01', 'Rajkot'),
(117, 'Vikram Batra', NULL, 11000.00, '2005-04-05', 'Baroda');

---------------------------------------------------------
-- PART A : PERSON + DEPT QUERIES
---------------------------------------------------------

-- 1. Cross Join (Cartesian Product)
SELECT PersonName, DepartmentName
FROM PERSON
CROSS JOIN DEPT;

-- 2. Persons with their Department Name
SELECT P.PersonName, D.DepartmentName
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID;

-- 3. Persons with Department Name & Code
SELECT P.PersonName, D.DepartmentName, D.DepartmentCode
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID;

-- 4. Person with Department Code & Location
SELECT P.PersonName, D.DepartmentCode, D.Location
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID;

-- 5. Persons in Mechanical Department
SELECT *
FROM PERSON
WHERE DepartmentID = (SELECT DepartmentID FROM DEPT WHERE DepartmentName = 'Mechanical');

-- 6. Ahmedabad persons with DeptCode & Salary
SELECT P.PersonName, D.DepartmentCode, P.Salary
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
WHERE P.City = 'Ahmedabad';

-- 7. Persons whose department is in C–Block
SELECT P.PersonName
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
WHERE D.Location = 'C-Block';

-- 8. PersonName, Salary, Department for Jamnagar
SELECT P.PersonName, P.Salary, D.DepartmentName
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
WHERE P.City = 'Jamnagar';

-- 9. Civil persons joined after 1-Aug-2001
SELECT P.*
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Civil'
  AND P.JoiningDate > '2001-08-01';

-- 10. Joining date difference > 365 days
SELECT P.PersonName, D.DepartmentName
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
WHERE DATEDIFF(DAY, P.JoiningDate, GETDATE()) > 365;

-- 11. Department-wise person count
SELECT D.DepartmentName, COUNT(P.PersonID) AS PersonCount
FROM DEPT D
LEFT JOIN PERSON P ON P.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(P.PersonID) > 0;

-- 12. Department-wise Max & Min salary
SELECT D.DepartmentName,
       MAX(P.Salary) AS MaxSalary,
       MIN(P.Salary) AS MinSalary
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName;

-- 13. City-wise salary total, avg, max, min
SELECT City,
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AvgSalary,
       MAX(Salary) AS MaxSalary,
       MIN(Salary) AS MinSalary
FROM PERSON
GROUP BY City;

-- 14. Avg salary of Ahmedabad
SELECT AVG(Salary) AS AvgSalary_Ahmedabad
FROM PERSON
WHERE City = 'Ahmedabad';

-- 15. Sentence output
SELECT 
    CONCAT(PersonName, ' lives in ', City, ' and works in ', D.DepartmentName, ' Department.') AS PersonDetails
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID;


---------------------------------------------------------
-- PART B : PERSON + DEPT ADVANCED
---------------------------------------------------------

-- 1. Salary Sentence
SELECT 
    CONCAT(P.PersonName, ' earns ', P.Salary, ' from ', D.DepartmentName, ' department monthly.') AS SalaryDetails
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID;

-- 2. City & Department Wise Salary Stats
SELECT P.City, D.DepartmentName,
       SUM(P.Salary) AS TotalSalary,
       AVG(P.Salary) AS AvgSalary,
       MAX(P.Salary) AS MaxSalary
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
GROUP BY P.City, D.DepartmentName;

-- 3. Persons with no department
SELECT *
FROM PERSON
WHERE DepartmentID IS NULL;

-- 4. Departments where total salary > 100000
SELECT D.DepartmentName, SUM(P.Salary) AS TotalSalary
FROM PERSON P
JOIN DEPT D ON P.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING SUM(P.Salary) > 100000;


---------------------------------------------------------
-- PART C : ADDITIONAL PERSON-DEPT
---------------------------------------------------------

-- 1. Departments with no employees
SELECT D.DepartmentName
FROM DEPT D
LEFT JOIN PERSON P ON P.DepartmentID = D.DepartmentID
WHERE P.DepartmentID IS NULL;

-- 2. Departments where more than 2 persons work
SELECT D.DepartmentName, COUNT(P.PersonID) AS PersonCount
FROM DEPT D
JOIN PERSON P ON P.DepartmentID = D.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(P.PersonID) > 2;

-- 3. 10% increment for Computer department
UPDATE PERSON
SET Salary = Salary * 1.10
WHERE DepartmentID = (SELECT DepartmentID FROM DEPT WHERE DepartmentName = 'Computer');

-- Create Author table
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NULL
);

-- Create Publisher table
CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL
);

-- Create Book table with Foreign Keys
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    PublisherID INT NOT NULL,
    Price DECIMAL(8, 2) NOT NULL,
    PublicationYear INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);

-- Insert into Author
INSERT INTO Author (AuthorID, AuthorName, Country)
VALUES
(1, 'Chetan Bhagat', 'India'),
(2, 'Arundhati Roy', 'India'),
(3, 'Amish Tripathi', 'India'),
(4, 'Ruskin Bond', 'India'),
(5, 'Jhumpa Lahiri', 'India'),
(6, 'Paulo Coelho', 'Brazil'),
(7, 'Sudha Murty', 'India'),
(8, 'Vikram Seth', 'India'),
(9, 'Kiran Desai', 'India'); -- Author with no books

-- Insert into Publisher
INSERT INTO Publisher (PublisherID, PublisherName, City)
VALUES
(1, 'Rupa Publications', 'New Delhi'),
(2, 'Penguin India', 'Gurugram'),
(3, 'HarperCollins India', 'Noida'),
(4, 'Aleph Book Company', 'New Delhi'),
(5, 'Westland', 'Chennai');

-- Insert into Book
INSERT INTO Book (BookID, Title, AuthorID, PublisherID, Price, PublicationYear)
VALUES
(101, 'Five Point Someone', 1, 1, 250.00, 2004),
(102, 'The God of Small Things', 2, 2, 350.00, 1997),
(103, 'Immortals of Meluha', 3, 3, 300.00, 2010),
(104, 'The Blue Umbrella', 4, 1, 180.00, 1980),
(105, 'The Lowland', 5, 2, 400.00, 2013),
(106, 'Revolution 2020', 1, 1, 275.00, 2011),
(107, 'Sita: Warrior of Mithila', 3, 3, 320.00, 2017),
(108, 'The Room on the Roof', 4, 4, 200.00, 1956),
(109, 'A Suitable Boy', 8, 2, 600.00, 1993),
(110, 'Scion of Ikshvaku', 3, 5, 350.00, 2015),
(111, 'Wise and Otherwise', 7, 2, 210.00, 2002),
(112, '2 States', 1, 1, 260.00, 2009);

--1. List all books with their authors. 
SELECT BOOK.TITLE,AUTHOR.AUTHORNAME
FROM Book LEFT JOIN Author
ON Book.AuthorID = Author.AuthorID

--2. List all books with their publishers.
SELECT BOOK.TITLE,Publisher.PublisherName
FROM Book LEFT JOIN Publisher
ON Book.PublisherID = Publisher.PublisherID

--3. List all books with their authors and publishers.
SELECT BOOK.TITLE,AUTHOR.AuthorName,PUBLISHER.PublisherName
FROM Book LEFT JOIN Author
ON Book.AuthorID = Author.AuthorID
LEFT JOIN Publisher
ON Book.PublisherID = Publisher.PublisherID

--4. List all books published after 2010 with their authors and publisher and price.
SELECT Book.Title,Author.AuthorName,Publisher.PublisherName,Book.Price
FROM Book JOIN Author
ON Book.AuthorID = Author.AuthorID
JOIN Publisher
ON Book.PublisherID = Publisher.PublisherID
WHERE Book.PUBLICATIONYEAR > 2010

--5. List all authors and the number of books they have written.
SELECT AUTHOR.AUTHORNAME,COUNT(BOOK.BookID) AS NUMBER_OF_BOOKS
FROM Book RIGHT JOIN Author
ON Book.AuthorID = Author.AuthorID
GROUP BY Author.AuthorName

--6. List all publishers and the total price of books they have published.
SELECT Publisher.PublisherName,SUM(Book.Price) AS TOTAL_PRICE
FROM Publisher LEFT JOIN Book
ON Publisher.PublisherID = Book.PublisherID
GROUP BY Publisher.PublisherName

--7. List authors who have not written any books.
SELECT Author.AuthorName,Book.BookID
FROM Author LEFT JOIN Book
ON Author.AuthorID = Book.AuthorID
WHERE Book.BookID IS NULL

--8. Display total number of Books and Average Price of every Author.
SELECT Author.AuthorName,COUNT(Book.BookID),AVG(Book.Price) AS AVG_PRICE
FROM Author LEFT JOIN Book
ON Author.AuthorID = Book.AuthorID
GROUP BY AUTHOR.AuthorName

--9. lists each publisher along with the total number of books they have published, sorted from highest to lowest.
SELECT Publisher.PublisherName,COUNT(Book.BookID) AS BOOKCOUNT
FROM Publisher LEFT JOIN Book
ON Publisher.PublisherID = Book.PublisherID
GROUP BY Publisher.PublisherName
ORDER BY COUNT(BOOK.BOOKID) DESC

--10. Display number of books published each year.
SELECT PUBLICATIONYEAR,COUNT(BOOKID) AS NUMBER_OF_BOOKS
FROM Book
GROUP BY PublicationYear

----------------------------------PART--B-------------------------------------
--1. List the publishers whose total book prices exceed 500, ordered by the total price.
SELECT Publisher.PublisherName,SUM(Book.Price) AS TOTAL_PRICE
FROM Publisher LEFT JOIN Book
ON Publisher.PublisherID = Book.PublisherID
GROUP BY Publisher.PublisherName
HAVING SUM(BOOK.PRICE) > 500
ORDER BY SUM(BOOK.PRICE) DESC

--2. List most expensive book for each author, sort it with the highest price.
WITH MOSTEXPENSIVE AS(
	SELECT Author.AuthorName,Author.AuthorID,MAX(Book.Price) AS HIGHEST_PRICE
	FROM Author LEFT JOIN Book
	ON Author.AuthorID = Book.AuthorID
	GROUP BY AUTHOR.AUTHORNAME,Author.AuthorID 
)
SELECT M.AuthorName,Book.Title,M.HIGHEST_PRICE
FROM MOSTEXPENSIVE AS M LEFT JOIN Book 
ON Book.Price = M.HIGHEST_PRICE
WHERE Book.AuthorID = M.AuthorID
ORDER BY M.HIGHEST_PRICE DESC