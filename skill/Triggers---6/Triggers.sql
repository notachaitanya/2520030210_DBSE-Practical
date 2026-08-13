DROP DATABASE IF EXISTS BankLabDB;
CREATE DATABASE BankLabDB;
USE BankLabDB;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(50)
);

CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12,2) DEFAULT 0,
    Branch VARCHAR(50),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Bank_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Account_No) REFERENCES Account(Account_No)
);

CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Loan_Type VARCHAR(30),
    Loan_Amount DECIMAL(12,2),
    Interest_Rate DECIMAL(5,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Transaction_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Transaction_ID INT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Audit_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Account_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Old_Balance DECIMAL(12,2),
    New_Balance DECIMAL(12,2),
    Changed_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Customer VALUES
(101,'Ravi Kumar','9876543210','ravi@gmail.com','Hyderabad'),
(102,'Priya Sharma','9876543211','priya@gmail.com','Vijayawada'),
(103,'Arjun Reddy','9876543212','arjun@gmail.com','Bangalore'),
(104,'Sneha Rao','9876543213','sneha@gmail.com','Chennai'),
(105,'Kiran Kumar','9876543214','kiran@gmail.com','Hyderabad'),
(106,'Rahul Verma','9876543215','rahul@gmail.com','Delhi'),
(107,'Anjali Singh','9876543216','anjali@gmail.com','Mumbai'),
(108,'Vikram Das','9876543217','vikram@gmail.com','Pune'),
(109,'Neha Reddy','9876543218','neha@gmail.com','Hyderabad'),
(110,'Aman Gupta','9876543219','aman@gmail.com','Chennai');

INSERT INTO Account VALUES
(10001,101,'Savings',50000,'Hyderabad'),
(10002,102,'Savings',75000,'Vijayawada'),
(10003,103,'Current',120000,'Bangalore'),
(10004,104,'Savings',45000,'Chennai'),
(10005,105,'Current',90000,'Hyderabad'),
(10006,106,'Savings',65000,'Delhi'),
(10007,107,'Savings',85000,'Mumbai'),
(10008,108,'Current',110000,'Pune'),
(10009,109,'Savings',55000,'Hyderabad'),
(10010,110,'Savings',40000,'Chennai');

INSERT INTO Bank_Transaction
(Account_No,Transaction_Type,Amount)
VALUES
(10001,'DEPOSIT',10000),
(10001,'WITHDRAW',5000),
(10002,'DEPOSIT',15000),
(10002,'WITHDRAW',5000),
(10003,'DEPOSIT',20000),
(10003,'WITHDRAW',10000),
(10004,'DEPOSIT',5000),
(10004,'WITHDRAW',2000),
(10005,'DEPOSIT',10000),
(10005,'WITHDRAW',5000),
(10006,'DEPOSIT',8000),
(10006,'WITHDRAW',3000),
(10007,'DEPOSIT',12000),
(10007,'WITHDRAW',4000),
(10008,'DEPOSIT',15000),
(10008,'WITHDRAW',5000),
(10009,'DEPOSIT',7000),
(10009,'WITHDRAW',2000),
(10010,'DEPOSIT',6000),
(10010,'WITHDRAW',1000);

INSERT INTO Loan VALUES
(501,101,'Home Loan',5000000,7.5),
(502,102,'Education Loan',1000000,6.5),
(503,103,'Car Loan',800000,8.2),
(504,104,'Personal Loan',500000,10.5),
(505,105,'Home Loan',3000000,7.2),
(506,106,'Car Loan',900000,8.5),
(507,107,'Education Loan',700000,6.8),
(508,108,'Personal Loan',400000,11.0);

DELIMITER //

CREATE PROCEDURE GetAllCustomers()
BEGIN
SELECT * FROM Customer;
END //

CREATE PROCEDURE GetAccountDetails(IN p_Account_No INT)
BEGIN
SELECT * FROM Account
WHERE Account_No=p_Account_No;
END //

CREATE PROCEDURE GetCustomerAccounts(IN p_Customer_ID INT)
BEGIN
SELECT C.Customer_ID,C.Customer_Name,C.Phone,C.Email,
A.Account_No,A.Account_Type,A.Balance,A.Branch
FROM Customer C
JOIN Account A ON C.Customer_ID=A.Customer_ID
WHERE C.Customer_ID=p_Customer_ID;
END //

CREATE PROCEDURE GetBranchAccounts(IN p_Branch VARCHAR(50))
BEGIN
SELECT * FROM Account
WHERE Branch=p_Branch;
END //

CREATE PROCEDURE GetCustomerAccountDetails(IN p_Customer_ID INT)
BEGIN
SELECT C.Customer_Name,C.Phone,C.Email,
A.Account_No,A.Account_Type,A.Balance
FROM Customer C
JOIN Account A ON C.Customer_ID=A.Customer_ID
WHERE C.Customer_ID=p_Customer_ID;
END //

CREATE PROCEDURE GetTotalBalance(IN p_Customer_ID INT)
BEGIN
SELECT p_Customer_ID AS Customer_ID,
SUM(Balance) AS Total_Balance
FROM Account
WHERE Customer_ID=p_Customer_ID;
END //

CREATE PROCEDURE HighBalanceAccounts(IN MinimumBalance DECIMAL(12,2))
BEGIN
SELECT * FROM Account
WHERE Balance>=MinimumBalance
ORDER BY Balance DESC;
END //

CREATE TRIGGER CheckBalance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
IF NEW.Balance<0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Transaction failed: Insufficient balance';
END IF;
END //

CREATE TRIGGER CheckTransactionAmount
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
IF NEW.Amount<=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Transaction amount must be greater than zero';
END IF;
END //

CREATE TRIGGER TransactionAudit
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
INSERT INTO Transaction_Audit
(Transaction_ID,Account_No,Transaction_Type,Amount)
VALUES
(NEW.Transaction_ID,NEW.Account_No,NEW.Transaction_Type,NEW.Amount);
END //

CREATE TRIGGER UpdateBalanceAfterTransaction
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
IF NEW.Transaction_Type='DEPOSIT' THEN
UPDATE Account
SET Balance=Balance+NEW.Amount
WHERE Account_No=NEW.Account_No;
ELSEIF NEW.Transaction_Type='WITHDRAW' THEN
UPDATE Account
SET Balance=Balance-NEW.Amount
WHERE Account_No=NEW.Account_No;
END IF;
END //

CREATE TRIGGER PreventInsufficientWithdrawal
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
DECLARE CurrentBalance DECIMAL(12,2);

SELECT Balance INTO CurrentBalance
FROM Account
WHERE Account_No=NEW.Account_No;

IF NEW.Transaction_Type='WITHDRAW'
AND NEW.Amount>CurrentBalance THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Withdrawal failed: Insufficient balance';
END IF;
END //

CREATE PROCEDURE TransferMoney(
IN SenderAccount INT,
IN ReceiverAccount INT,
IN TransferAmount DECIMAL(12,2)
)
BEGIN
DECLARE SenderBalance DECIMAL(12,2);
DECLARE SenderExists INT;
DECLARE ReceiverExists INT;

SELECT COUNT(*) INTO SenderExists
FROM Account
WHERE Account_No=SenderAccount;

SELECT COUNT(*) INTO ReceiverExists
FROM Account
WHERE Account_No=ReceiverAccount;

IF SenderExists=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Sender account does not exist';

ELSEIF ReceiverExists=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Receiver account does not exist';

ELSEIF TransferAmount<=0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Transfer amount must be greater than zero';

ELSE
SELECT Balance INTO SenderBalance
FROM Account
WHERE Account_No=SenderAccount;

IF SenderBalance<TransferAmount THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Transfer failed: Insufficient balance';

ELSE
UPDATE Account
SET Balance=Balance-TransferAmount
WHERE Account_No=SenderAccount;

UPDATE Account
SET Balance=Balance+TransferAmount
WHERE Account_No=ReceiverAccount;
END IF;
END IF;
END //

CREATE PROCEDURE CalculateLoanInterest(
IN LoanAmount DECIMAL(12,2),
IN InterestRate DECIMAL(5,2),
IN NumberOfYears INT
)
BEGIN
DECLARE SimpleInterest DECIMAL(12,2);
DECLARE TotalAmount DECIMAL(12,2);

SET SimpleInterest=(LoanAmount*InterestRate*NumberOfYears)/100;
SET TotalAmount=LoanAmount+SimpleInterest;

SELECT LoanAmount,InterestRate,NumberOfYears,
SimpleInterest,TotalAmount;
END //

CREATE TRIGGER PreventCustomerDelete
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
IF EXISTS(
SELECT 1 FROM Account
WHERE Customer_ID=OLD.Customer_ID
) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Cannot delete customer: Active account exists';
END IF;
END //

CREATE TRIGGER AccountBalanceAudit
AFTER UPDATE ON Account
FOR EACH ROW
BEGIN
IF OLD.Balance<>NEW.Balance THEN
INSERT INTO Account_Audit
(Account_No,Old_Balance,New_Balance)
VALUES
(NEW.Account_No,OLD.Balance,NEW.Balance);
END IF;
END //

CREATE PROCEDURE Top5Accounts()
BEGIN
SELECT * FROM Account
ORDER BY Balance DESC
LIMIT 5;
END //

CREATE PROCEDURE AccountCountByBranch()
BEGIN
SELECT Branch,COUNT(*) AS Number_of_Accounts
FROM Account
GROUP BY Branch;
END //

CREATE PROCEDURE CustomersWithHighLoans(
IN MinimumLoanAmount DECIMAL(12,2)
)
BEGIN
SELECT C.Customer_ID,C.Customer_Name,
L.Loan_ID,L.Loan_Type,L.Loan_Amount,L.Interest_Rate
FROM Customer C
JOIN Loan L ON C.Customer_ID=L.Customer_ID
WHERE L.Loan_Amount>MinimumLoanAmount;
END //

CREATE TRIGGER PreventAccountDelete
BEFORE DELETE ON Account
FOR EACH ROW
BEGIN
IF EXISTS(
SELECT 1 FROM Bank_Transaction
WHERE Account_No=OLD.Account_No
) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Cannot delete account: Transactions exist';
END IF;
END //

CREATE PROCEDURE GetTransactionHistory(IN p_Account_No INT)
BEGIN
SELECT *
FROM Bank_Transaction
WHERE Account_No=p_Account_No
ORDER BY Transaction_Date;
END //

CREATE PROCEDURE GetAllAccountDetails()
BEGIN
SELECT A.Account_No,C.Customer_Name,
A.Account_Type,A.Balance,A.Branch
FROM Account A
JOIN Customer C ON A.Customer_ID=C.Customer_ID;
END //

CREATE PROCEDURE DepositMoney(
IN p_Account_No INT,
IN p_Amount DECIMAL(12,2)
)
BEGIN
INSERT INTO Bank_Transaction
(Account_No,Transaction_Type,Amount)
VALUES
(p_Account_No,'DEPOSIT',p_Amount);
END //

CREATE PROCEDURE WithdrawMoney(
IN p_Account_No INT,
IN p_Amount DECIMAL(12,2)
)
BEGIN
INSERT INTO Bank_Transaction
(Account_No,Transaction_Type,Amount)
VALUES
(p_Account_No,'WITHDRAW',p_Amount);
END //

CREATE PROCEDURE GetCustomerLoans(IN p_Customer_ID INT)
BEGIN
SELECT C.Customer_Name,L.Loan_ID,L.Loan_Type,
L.Loan_Amount,L.Interest_Rate
FROM Customer C
JOIN Loan L ON C.Customer_ID=L.Customer_ID
WHERE C.Customer_ID=p_Customer_ID;
END //

CREATE PROCEDURE GetBalance(
IN p_Account_No INT,
OUT p_Balance DECIMAL(12,2)
)
BEGIN
SELECT Balance INTO p_Balance
FROM Account
WHERE Account_No=p_Account_No;
END //

DELIMITER ;

CALL GetAllCustomers();
CALL GetBranchAccounts('Hyderabad');
CALL GetCustomerAccountDetails(101);
CALL GetTotalBalance(101);
CALL HighBalanceAccounts(100000);
CALL DepositMoney(10001,5000);
CALL WithdrawMoney(10001,2000);
CALL TransferMoney(10001,10002,3000);
CALL CalculateLoanInterest(500000,8.5,5);
CALL Top5Accounts();
CALL AccountCountByBranch();
CALL CustomersWithHighLoans(1000000);
CALL GetTransactionHistory(10001);
CALL GetAllAccountDetails();
CALL GetCustomerLoans(101);
CALL GetBalance(10001,@CurrentBalance);

SELECT @CurrentBalance;

SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Transaction_Audit;
SELECT * FROM Account_Audit;
SELECT * FROM Loan;