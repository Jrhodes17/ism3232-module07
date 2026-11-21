-- Best-Priced Tickets Database Schema 

CREATE TABLE IF NOT EXISTS events (
    event_id TEXT PRIMARY KEY,
    event_name TEXT NOT NULL,
    sport TEXT NOT NULL,
    venue TEXT NOT NULL,
    city TEXT NOT NULL,
    event_date TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ticket_listings (
    listing_id TEXT PRIMARY KEY,
    event_id TEXT NOT NULL,
    source_site TEXT NOT NULL,
    section TEXT NOT NULL,
    price_per_ticket REAL NOT NULL,
    available_qty INTEGER NOT NULL,
    FOREIGN KEY (event_id) REFERENCES events (event_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    customer_email TEXT NOT NULL,
    listing_id TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    total_price REAL NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (listing_id) REFERENCES ticket_listings (listing_id)
);

CREATE TABLE IF NOT EXISTS change_requests (
    request_id TEXT PRIMARY KEY,
    order_id TEXT NOT NULL,
    request_type TEXT NOT NULL,
    requested_value TEXT NOT NULL,
    reason TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'pending',
    created_at TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (order_id)
);

-- Sample Tampa Bay Area Events 
INSERT OR IGNORE INTO events (event_id, event_name, sport, venue, city, event_date) VALUES
    ('EVT-101', 'Tampa Bay Lightning vs. Buffalo Sabres', 'NHL', 'Benchmark International Arena', 'Tampa', '2026-11-22'),
    ('EVT-102', 'Tampa Bay Lightning vs. Carolina Hurricanes', 'NHL', 'Benchmark International Arena', 'Tampa', '2026-11-25'),
    ('EVT-103', 'Tampa Bay Buccaneers vs. Los Angeles Chargers', 'NFL', 'Raymond James Stadium', 'Tampa', '2026-12-06'),
    ('EVT-104', 'Tampa Bay Lightning vs. Columbus Blue Jackets', 'NHL', 'Benchmark International Arena', 'Tampa', '2026-12-07'),
    ('EVT-105', 'Tampa Bay Lightning vs. Boston Bruins', 'NHL', 'Benchmark International Arena', 'Tampa', '2026-12-10'),
    ('EVT-106', 'South Florida Bulls vs. Alabama Crimson Tide', 'NCAAB', 'Yuengling Center', 'Tampa', '2026-12-16'),
    ('EVT-107', 'Tampa Bay Buccaneers vs. New Orleans Saints', 'NFL', 'Raymond James Stadium', 'Tampa', '2026-12-20'),
    ('EVT-108', 'Tampa Bay Lightning vs. St. Louis Blues', 'NHL', 'Benchmark International Arena', 'Tampa', '2026-12-22');

-- Sample Ticket Listings across 6 ticketing Apps 
INSERT OR IGNORE INTO ticket_listings (listing_id, event_id, source_site, section, price_per_ticket, available_qty) VALUES
    ('LST-201', 'EVT-101', 'StubHub', 'Section 104', 115.00, 6),
    ('LST-202', 'EVT-101', 'TickPick', 'Section 104', 118.00, 4),
    ('LST-203', 'EVT-101', 'SeatGeek', 'Section 104', 124.00, 3),
    ('LST-204', 'EVT-102', 'Gametime', 'Section 118', 96.00, 5),
    ('LST-205', 'EVT-102', 'Vivid Seats', 'Section 118', 98.00, 5),
    ('LST-206', 'EVT-102', 'Ticketmaster', 'Section 118', 107.00, 2),
    ('LST-207', 'EVT-103', 'TickPick', 'Section 120', 164.00, 4),
    ('LST-208', 'EVT-103', 'StubHub', 'Section 120', 168.00, 4),
    ('LST-209', 'EVT-103', 'Ticketmaster', 'Section 120', 175.00, 5),
    ('LST-210', 'EVT-104', 'Gametime', 'Section 112', 88.00, 6),
    ('LST-211', 'EVT-104', 'SeatGeek', 'Section 112', 93.00, 7),
    ('LST-212', 'EVT-105', 'Vivid Seats', 'Section 108', 112.00, 4),
    ('LST-213', 'EVT-105', 'Ticketmaster', 'Section 108', 119.00, 3),
    ('LST-214', 'EVT-106', 'StubHub', 'Section 102', 54.00, 8),
    ('LST-215', 'EVT-107', 'TickPick', 'Section 122', 158.00, 5),
    ('LST-216', 'EVT-108', 'Gametime', 'Section 114', 102.00, 4);

-- Sample Orders
INSERT OR IGNORE INTO orders (order_id, customer_name, customer_email, listing_id, quantity, total_price, status) VALUES
    ('ORD-1001', 'Devon Brooks', 'devon.b@example.com', 'LST-201', 2, 230.00, 'confirmed'),
    ('ORD-1002', 'Samira Patel', 'samira.p@example.com', 'LST-205', 2, 196.00, 'confirmed'),
    ('ORD-1003', 'Liam Chen', 'liam.c@example.com', 'LST-208', 2, 336.00, 'confirmed'),
    ('ORD-1004', 'Hannah Morales', 'hannah.m@example.com', 'LST-214', 2, 108.00, 'confirmed'),
    ('ORD-1005', 'Tariq Robinson', 'tariq.r@example.com', 'LST-215', 2, 316.00, 'cancelled');