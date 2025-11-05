CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets REAL
);

CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(50),
    customer_city VARCHAR(50)
);

CREATE TABLE Depositer (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno)
);

CREATE TABLE Loan (
    loan_number INT PRIMARY KEY,
    branch_name VARCHAR(50),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name)
);



INSERT INTO Branch VALUES 
('SBI_ResidencyRoad', 'Bangalore', 12000000),
('SBI_ChurchStreet', 'Bangalore', 8500000),
('HDFC_MG_Road', 'Bangalore', 9400000),
('ICICI_Indiranagar', 'Bangalore', 7600000),
('SBI_MumbaiCentral', 'Mumbai', 13400000);


INSERT INTO BankAccount VALUES
(1001, 'SBI_ResidencyRoad', 50000),
(1002, 'SBI_ResidencyRoad', 70000),
(1003, 'HDFC_MG_Road', 45000),
(1004, 'SBI_MumbaiCentral', 90000),
(1005, 'ICICI_Indiranagar', 55000);


INSERT INTO BankCustomer VALUES
('Ravi Kumar', 'MG Road', 'Bangalore'),
('Anita Sharma', 'Church Street', 'Bangalore'),
('Vikram Rao', 'Indiranagar', 'Bangalore'),
('Sneha Mehta', 'Colaba', 'Mumbai'),
('Ramesh Gupta', 'Residency Road', 'Bangalore');


INSERT INTO Depositer VALUES
('Ravi Kumar', 1001),
('Ravi Kumar', 1002),  
('Anita Sharma', 1003),
('Sneha Mehta', 1004),
('Vikram Rao', 1005);

INSERT INTO Loan VALUES
(2001, 'SBI_ResidencyRoad', 300000),
(2002, 'SBI_ResidencyRoad', 250000),
(2003, 'HDFC_MG_Road', 400000),
(2004, 'ICICI_Indiranagar', 150000),
(2005, 'SBI_MumbaiCentral', 500000);



SELECT 
    branch_name, 
    (assets / 100000) AS "assets in lakhs"
FROM Branch;

SELECT d.customer_name, b.branch_name
FROM Depositer d
JOIN BankAccount b ON d.accno = b.accno
GROUP BY d.customer_name, b.branch_name
HAVING COUNT(d.accno) >= 2;


CREATE VIEW BranchLoanSummary AS
SELECT 
    branch_name,
    SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;


SELECT * FROM BranchLoanSummary;

