DROP DATABASE IF EXISTS skytrack_db;

CREATE DATABASE skytrack_db;

USE skytrack_db;

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL UNIQUE,
    source VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    departure_date DATE NOT NULL,
    ticket_price DECIMAL(10,2) CHECK (ticket_price > 0)
);

INSERT INTO Flights
(flight_id, flight_number, source, destination, departure_date, ticket_price)
VALUES
(1, 'SK101', 'Hyderabad', 'Delhi', '2026-08-10', 5500.00),
(2, 'SK102', 'Hyderabad', 'Mumbai', '2026-08-11', 4500.00),
(3, 'SK103', 'Chennai', 'Delhi', '2026-08-12', 5200.00),
(4, 'SK104', 'Bangalore', 'Kolkata', '2026-08-13', 6000.00),
(5, 'SK105', 'Delhi', 'Hyderabad', '2026-08-14', 5000.00),
(6, 'SK106', 'Mumbai', 'Chennai', '2026-08-15', 4800.00),
(7, 'SK107', 'Kolkata', 'Bangalore', '2026-08-16', 5800.00),
(8, 'SK108', 'Pune', 'Delhi', '2026-08-17', 4300.00),
(9, 'SK109', 'Hyderabad', 'Pune', '2026-08-18', 3500.00),
(10, 'SK110', 'Chennai', 'Mumbai', '2026-08-19', 4700.00);

SELECT * FROM Flights;

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    passenger_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO Passengers
(passenger_id, passenger_name, email)
VALUES
(101, 'Rahul Sharma', 'rahul@example.com'),
(102, 'Priya Reddy', 'priya@example.com'),
(103, 'Arjun Kumar', 'arjun@example.com'),
(104, 'Sneha Rao', 'sneha@example.com'),
(105, 'Vikram Singh', 'vikram@example.com'),
(106, 'Ananya Das', 'ananya@example.com'),
(107, 'Kiran Patel', 'kiran@example.com'),
(108, 'Neha Verma', 'neha@example.com'),
(109, 'Rohit Mehta', 'rohit@example.com'),
(110, 'Pooja Nair', 'pooja@example.com');

SELECT * FROM Passengers;

CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    booking_date DATE,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

INSERT INTO Bookings
(booking_id, passenger_id, flight_id, booking_date)
VALUES
(1, 101, 1, '2026-08-01'),
(2, 102, 2, '2026-08-02'),
(3, 103, 3, '2026-08-03'),
(4, 104, 4, '2026-08-04'),
(5, 105, 5, '2026-08-05'),
(6, 106, 6, '2026-08-06'),
(7, 107, 7, '2026-08-06'),
(8, 108, 8, '2026-08-07'),
(9, 109, 9, '2026-08-07'),
(10, 110, 10, '2026-08-08');

SELECT * FROM Bookings;

SELECT
    p.passenger_name,
    f.flight_number,
    f.source,
    f.destination
FROM Bookings b
INNER JOIN Passengers p ON b.passenger_id = p.passenger_id
INNER JOIN Flights f ON b.flight_id = f.flight_id;

SELECT
    destination,
    COUNT(flight_id) AS Total_Flights
FROM Flights
GROUP BY destination
ORDER BY destination;

CREATE TABLE Flight_History (
    history_id INT PRIMARY KEY,
    flight_id INT,
    action VARCHAR(50),
    action_date DATE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

START TRANSACTION;

INSERT INTO Flights
(flight_id, flight_number, source, destination, departure_date, ticket_price)
VALUES
(11, 'SK111', 'Hyderabad', 'Goa', '2026-08-20', 4200.00);

INSERT INTO Flight_History
(history_id, flight_id, action, action_date)
VALUES
(1, 11, 'New Flight Added', CURDATE());

COMMIT;

SELECT * FROM Flights;

SELECT * FROM Flight_History;

CREATE INDEX idx_flight_number ON Flights(flight_number);

SELECT * FROM Flights
WHERE flight_number = 'SK105';