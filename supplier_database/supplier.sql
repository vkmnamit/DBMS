create database supplier;
use  supplier;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE Part (
    pid INT PRIMARY KEY,
    pname VARCHAR(100),
    color VARCHAR(50)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Part(pid)
);

INSERT INTO Supplier VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO Supplier VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO Supplier VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO Supplier VALUES (10004, 'Reliance', 'Delhi');
select * from Supplier;

INSERT INTO Part VALUES (20001, 'Book', 'Red');
INSERT INTO Part VALUES (20002, 'Pen', 'Red');
INSERT INTO Part VALUES (20003, 'Pencil', 'Green');
INSERT INTO Part VALUES (20004, 'Mobile', 'Green');
INSERT INTO Part VALUES (20005, 'Charger', 'Black');
select * from part;

INSERT INTO Catalog VALUES (10001, 20001, 10);
INSERT INTO Catalog VALUES (10001, 20002, 20);
INSERT INTO Catalog VALUES (10001, 20003, 30);
INSERT INTO Catalog VALUES (10001, 20004, 10);
INSERT INTO Catalog VALUES (10001, 20005, 10);
INSERT INTO Catalog VALUES (10002, 20001, 10);
INSERT INTO Catalog VALUES (10002, 20002, 20);
INSERT INTO Catalog VALUES (10003, 20003, 30);
INSERT INTO Catalog VALUES (10004, 20003, 40);
select * from catalog;

SELECT DISTINCT p.pname
FROM Part p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Part p
    WHERE p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);




SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Part p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

SELECT DISTINCT p.pname
FROM Part p
JOIN Catalog c ON p.pid = c.pid;
SELECT p.pname
FROM Part p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON s.sid = c.sid
WHERE s.sname = 'Acme Widget'
AND p.pid NOT IN (
    SELECT c1.pid
    FROM Catalog c1
    JOIN Supplier s1 ON s1.sid = c1.sid
    WHERE s1.sname <> 'Acme Widget'
);

SELECT DISTINCT c1.sid
FROM Catalog c1
WHERE c1.cost > (
    SELECT AVG(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c1.pid
);


SELECT c.pid, s.sname
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(c2.cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
)
ORDER BY c.pid;
