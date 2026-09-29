-- Run this in pgAdmin (Query Tool on the "bookflow" database) AFTER the app
-- has started once, so Hibernate has created the tables.
INSERT INTO inventory (book_id, total_stock, available_stock)
VALUES
(101, 5, 5),
(102, 3, 3),
(103, 2, 0);

SELECT * FROM inventory;
