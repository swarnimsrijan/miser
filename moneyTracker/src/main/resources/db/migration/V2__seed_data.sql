-- Seed Banks
INSERT INTO banks (name, country) VALUES
    ('HDFC', 'IN'),
    ('ICICI', 'IN'),
    ('Axis', 'IN'),
    ('SBI', 'IN'),
    ('IDFC', 'IN'),
    ('YES', 'IN'),
    ('Kotak', 'IN'),
    ('IndusInd', 'IN');

-- Seed Categories
INSERT INTO categories (name) VALUES
    ('Food'),
    ('Shopping'),
    ('Bills'),
    ('Investment'),
    ('Travel'),
    ('Medical'),
    ('Entertainment'),
    ('Education'),
    ('Salary'),
    ('Transfer'),
    ('Other');

-- Seed SubCategories
INSERT INTO sub_categories (category_id, name) VALUES
    ((SELECT id FROM categories WHERE name = 'Food'), 'Restaurant'),
    ((SELECT id FROM categories WHERE name = 'Food'), 'Delivery'),
    ((SELECT id FROM categories WHERE name = 'Food'), 'Cafe'),
    ((SELECT id FROM categories WHERE name = 'Food'), 'Grocery'),
    ((SELECT id FROM categories WHERE name = 'Shopping'), 'Online'),
    ((SELECT id FROM categories WHERE name = 'Shopping'), 'Clothing'),
    ((SELECT id FROM categories WHERE name = 'Shopping'), 'Electronics'),
    ((SELECT id FROM categories WHERE name = 'Bills'), 'Electricity'),
    ((SELECT id FROM categories WHERE name = 'Bills'), 'Internet'),
    ((SELECT id FROM categories WHERE name = 'Bills'), 'Phone'),
    ((SELECT id FROM categories WHERE name = 'Bills'), 'Rent'),
    ((SELECT id FROM categories WHERE name = 'Travel'), 'Fuel'),
    ((SELECT id FROM categories WHERE name = 'Travel'), 'Cab'),
    ((SELECT id FROM categories WHERE name = 'Travel'), 'Flight'),
    ((SELECT id FROM categories WHERE name = 'Travel'), 'Hotel');
