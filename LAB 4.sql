---------------------------------PART-A-----------------------------------------------------
----------1. Write a function to print "hello world".
CREATE FUNCTION FN_HELLOWORLD()
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN 'HELLO WORLD'
END

SELECT dbo.FN_HELLOWORLD()

----------2. Write a function which returns addition of two numbers.
CREATE OR ALTER FUNCTION FN_ADDITIONOFTWONUMBERS(
	@N1 INT,
	@N2 INT
)
RETURNS INT
AS
BEGIN
	RETURN @N1+@N2
END

SELECT dbo.FN_ADDITIONOFTWONUMBERS(10,5)

----------3. Write a function to check whether the given number is ODD or EVEN.
CREATE OR ALTER FUNCTION FN_NUMBERISODDOREVEN(
	@N1 INT
)
RETURNS VARCHAR(25)
AS
BEGIN
	IF (@N1%2=0)
		RETURN 'EVEN'
	ELSE
		RETURN 'ODD'
	RETURN ''
END

SELECT dbo.FN_NUMBERISODDOREVEN(10)

----------4. Write a function which returns a table with details of a person whose first name starts with B.
CREATE OR ALTER FUNCTION FN_RETURNTABLE()
RETURNS TABLE
AS
	RETURN(SELECT * FROM Person
		   WHERE FirstName LIKE 'B%')

SELECT * FROM FN_RETURNTABLE()

----------5. Write a function which returns a table with unique first names from the person table.
CREATE OR ALTER FUNCTION FN_UNIQUENAME()
RETURNS TABLE
AS
	RETURN(SELECT DISTINCT FIRSTNAME FROM Person)

SELECT * FROM FN_UNIQUENAME()

----------6. Write a function to print number from 1 to N. (Using while loop)
CREATE OR ALTER FUNCTION FN_PRINT1TON(
	@N INT
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @I INT
	DECLARE @ANS VARCHAR(MAX)
	SET @I=1
	SET @ANS = ''
	WHILE(@I<=@N)
	BEGIN
		SET @ANS = @ANS + CAST(@I AS varchar)
		SET @I=@I+1
	END
	RETURN @ANS
END

SELECT dbo.FN_PRINT1TON(12)

----------7. Write a function to find the factorial of a given integer.CREATE OR ALTER FUNCTION FN_FACTORIAL(	@N INT)RETURNS INTASBEGIN	DECLARE @I INT = 1	DECLARE @FACT INT = 1	WHILE (@I<=@N)	BEGIN		SET @FACT = @FACT*@I		SET @I=@I+1	END	RETURN @FACTENDSELECT dbo.FN_FACTORIAL(4)---------------------------------------------PART-B---------------------------------------------------8. Write a function to compare two integers and return the comparison result. (Using Case statement)
CREATE OR ALTER FUNCTION FN_CHECK(
	@N1 INT,
	@N2 INT
)
RETURNS VARCHAR(25)
AS
BEGIN
	DECLARE @ANS VARCHAR(50)
	SET @ANS = CASE
		WHEN @N1>@N2 THEN CAST(@N1 AS varchar)+' IS GREATER '
		WHEN @N1<@N2 THEN CAST(@N2 AS varchar)+'IS GREATER'
		WHEN @N1=@N2 THEN 'BOTH ARE EQUAL'
	END
	RETURN @ANS
END

SELECT dbo.FN_CHECK(2,8)

------9. Write a function to print the sum of even numbers between 1 to 20.
------10. Write a function that checks if a given string is a palindrome