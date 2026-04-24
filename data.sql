# customer id, name, country
INSERT INTO customers VALUES
(1, 'Ana', 'Costa Rica'),
(2, 'Luis', 'Mexico'),
(3, 'Maria', 'Colombia'),
(4, 'Carlos', 'Chile'),
(5, 'Sofia', 'Argentina'),
(6, 'Diego', 'Peru'),
(7, 'Valeria', 'Costa Rica'),
(8, 'Jorge', 'Mexico');

# product id, name, category, price
INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 800),
(2, 'Mouse', 'Electronics', 20),
(3, 'Desk', 'Furniture', 150),
(4, 'Keyboard', 'Electronics', 50),
(5, 'Monitor', 'Electronics', 300),
(6, 'Chair', 'Furniture', 120),
(7, 'Headphones', 'Accessories', 80),
(8, 'USB Cable', 'Accessories', 10);

# order id, customer id, date
INSERT INTO orders VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-15'),
(3, 3, '2024-02-05'),
(4, 4, '2024-02-20'),
(5, 5, '2024-03-01'),
(6, 1, '2024-03-10'),
(7, 6, '2024-03-15'),
(8, 7, '2024-04-01'),
(9, 8, '2024-04-10'),
(10, 2, '2024-04-15'),
(11, 3, '2024-05-05'),
(12, 4, '2024-05-12');

# order detail id, order id, product id, quantity
INSERT INTO order_details VALUES
(1, 1, 1, 1),   -- Ana buys Laptop
(2, 1, 2, 2),   -- Ana buys Mouse
(3, 2, 3, 1),   -- Luis buys Desk
(4, 3, 4, 1),   -- Maria buys Keyboard
(5, 3, 7, 1),   -- Maria buys Headphones
(6, 4, 5, 1),   -- Carlos buys Monitor
(7, 5, 6, 2),   -- Sofia buys Chairs
(8, 6, 1, 1),   -- Ana buys another Laptop
(9, 7, 8, 3),   -- Diego buys USB cables
(10, 8, 7, 2),  -- Valeria buys Headphones
(11, 9, 2, 5),  -- Jorge buys Mouse
(12, 10, 5, 1), -- Luis buys Monitor
(13, 11, 3, 1), -- Maria buys Desk
(14, 12, 6, 1); -- Carlos buys Chair