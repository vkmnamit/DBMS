create database lab_employees;
use lab_employees;
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(50)
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Salary DECIMAL(10,2),
    Manager_ID INT,
    Dept_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID),
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Incentive (
    Inc_ID INT PRIMARY KEY,
    Emp_ID INT,
    Inc_Amount DECIMAL(10,2),
    Inc_Date DATE,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID)
);
INSERT INTO Department VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employee VALUES
(101, 'Amit', 70000, NULL, 1),
(102, 'Neha', 50000, 101, 1),
(103, 'Raj', 45000, 101, 1),
(104, 'Kiran', 80000, NULL, 2),
(105, 'Meena', 60000, 104, 2),
(106, 'Sanjay', 55000, 104, 2),
(107, 'Ravi', 90000, NULL, 3),
(108, 'Pooja', 65000, 107, 3),
(109, 'Nina', 48000, 107, 3);

INSERT INTO Incentive VALUES
(1, 102, 2000, '2019-01-15'),
(2, 103, 3500, '2019-01-18'),
(3, 105, 4000, '2019-01-10'),
(4, 106, 2500, '2019-01-15'),
(5, 108, 4500, '2019-01-20'),
(6, 109, 3000, '2019-01-12');




SELECT E.Emp_Name AS Manager_Name
FROM Employee E
WHERE E.Emp_ID IN (
    SELECT Manager_ID
    FROM Employee
    GROUP BY Manager_ID
    HAVING COUNT(*) = (
        SELECT MAX(emp_count)
        FROM (
            SELECT COUNT(*) AS emp_count
            FROM Employee
            WHERE Manager_ID IS NOT NULL
            GROUP BY Manager_ID
        ) AS counts
    )
);

SELECT M.Emp_Name AS Manager_Name
FROM Employee M
WHERE M.Emp_ID IN (
    SELECT E.Manager_ID
    FROM Employee E
    GROUP BY E.Manager_ID
    HAVING AVG(E.Salary) < (
        SELECT Salary FROM Employee WHERE Emp_ID = E.Manager_ID
    )
);



SELECT DISTINCT E.Emp_Name AS Second_Top_Manager, D.Dept_Name
FROM Employee E
JOIN Department D ON E.Dept_ID = D.Dept_ID
WHERE E.Emp_ID IN (
    SELECT DISTINCT M1.Emp_ID
    FROM Employee M1
    WHERE M1.Emp_ID IN (SELECT DISTINCT Manager_ID FROM Employee)
      AND M1.Manager_ID IN (
          SELECT Emp_ID FROM Employee WHERE Manager_ID IS NULL
      )
);


SELECT E.*
FROM Employee E
JOIN Incentive I ON E.Emp_ID = I.Emp_ID
WHERE I.Inc_Amount = (
    SELECT MAX(Inc_Amount)
    FROM Incentive
    WHERE Inc_Amount < (
        SELECT MAX(Inc_Amount)
        FROM Incentive
        WHERE MONTH(Inc_Date) = 1 AND YEAR(Inc_Date) = 2019
    )
    AND MONTH(Inc_Date) = 1 AND YEAR(Inc_Date) = 2019
);



SELECT E.Emp_Name AS Employee, M.Emp_Name AS Manager, D.Dept_Name
FROM Employee E
JOIN Employee M ON E.Manager_ID = M.Emp_ID
JOIN Department D ON E.Dept_ID = D.Dept_ID
WHERE E.Dept_ID = M.Dept_ID;


