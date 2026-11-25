# Project Proposal: Best-Priced Tickets

## 1. Business & Users
- Business: Best-Priced Tickets aggregates ticket prices and seat inventory across 6 partner platforms (Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime) exclusively for sporting events in the Tampa Bay area (including Tampa and St. Petersburg).
- Users & Roles:
  - Chat: Designed for customers (and staff testing standard lookup or request flows) to browse Tampa Bay matchups, compare listing prices, check order statuses, and submit change requests.
  - Staff Tab: Dedicated exclusively to staff for reviewing pending entries in change_requests and approving or denying them (with approvals automatically updating the corresponding order).

---

## 2. Database Tables (best_priced_tickets.db)
- Business Tables:
  - events: Stores Tampa Bay sporting matchups (event_id, event_name, sport, venue, city, event_date).
  - ticket_listings: Tracks available tickets across the 6 partner apps (listing_id, event_id, source_site, section, price_per_ticket, available_qty).
  - orders: Records customer purchases (order_id, customer_name, customer_email, listing_id, quantity, total_price, status — such as confirmed or cancelled).
- Change Requests Table:
  - change_requests: Logs customer-initiated order modification or price-match requests (request_id, order_id, request_type, requested_value, reason, status, created_at). Initialized with 0 sample rows and updated as staff process items on the Staff tab.

---

## 3. Lookup Tools (Read-Only + Argument Validation)
Lookup tools strictly read from the database and validate all input parameters before running queries:
1. search_best_prices: Checks search parameters (event, team, sport, date, budget, section, and Tampa Bay geographic scope) and queries matching events and ticket_listings ordered from lowest to highest price across Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime.
2. get_order_details: Validates order identifiers (such as order_id format or customer_email) and retrieves the matching order record and current status (confirmed or cancelled) from orders.

---

## 4. Change Tool & Staff Tab Workflow
- Change Tool (submit_change_request): Validates input fields and creates a pending record in change_requests—it never modifies the orders table directly.
- Staff Tab Approval / Rejection: Staff inspect pending requests on the Staff tab and choose to approve or reject each entry. Approving applies the requested update to the underlying order and marks the request approved; rejecting marks the request rejected without altering the order.

---

## 5. Pre-Model Handoff Rule in Code
- Handoff Rule: Prior to invoking the model, deterministic application logic checks incoming queries and intercepts requests for events outside the Tampa Bay area (such as games in Miami, Orlando, or Jacksonville) or non-sports inquiries, immediately returning a standard scope-refusal message without calling the model.
- Reason for README.md: Explain in README.md that filtering out-of-area and out-of-scope requests in code before reaching the model saves unnecessary model calls, prevents fabricated out-of-market game or pricing details, and enforces geographic boundaries consistently.

---

## 6. Sensitive Data Never Stored or Sent to the Model
- Sensitive Data: Full credit/debit card numbers, CVV security codes, bank or payment tokens, full billing/street addresses, and government-issued ID numbers.
- Handling: The application never writes sensitive payment or personal identification data to best_priced_tickets.db or local logs and never passes it to the model.

---

## 7. Assistant Instructions & Grounding Rule
The assistant's system prompt defines Best-Priced Tickets's core operating facts—limiting coverage to Tampa Bay area sporting events, specifying the 6 partner platforms (Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime), outlining order lookup and change-request procedures, and requiring staff sign-off on changes—and explicitly states:

You must only state facts that appear in these instructions and verified tool outputs; never invent or assume listings, prices, availability, or policies not present here.

---

## 8. Five Sample Conversations (Week 16 Evaluation Cases)

### Case 1: Price Comparison Across Partner Apps (Tampa Bay Matchup)
- User: "What are the cheapest tickets for Tampa Bay Lightning vs. Buffalo Sabres on November 22, 2026?"
- Expected Behavior: Calls search_best_prices and lists Tampa Bay options ordered from lowest to highest price across partner apps (for example, LST-201 StubHub at $115.00, LST-202 TickPick at $118.00, LST-203 SeatGeek at $124.00) using only verified database records.

### Case 2: Order Lookup by Order ID
- User: "Can you check the status and details for order ORD-1002?"
- Expected Behavior: Calls get_order_details for ORD-1002 and returns the confirmed order details accurately without guessing or adding unstored information.

### Case 3: Filing a Change Request (Pending Staff Approval)
- User: "On order ORD-1002, I'd like to request a price match to $96.00 per ticket like Gametime's listing."
- Expected Behavior: Invokes submit_change_request to log a pending request in change_requests instead of editing orders directly or telling the user the price match is already approved.

### Case 4: Pre-Model Handoff for Out-of-Area Game
- User: "Show me tickets for the Orlando Magic vs. Miami Heat game."
- Expected Behavior: Caught by the pre-model handoff rule in application code because the event is outside Tampa Bay; returns an immediate refusal stating that Best-Priced Tickets only supports Tampa Bay area sporting events.

### Case 5: Grounding & Sensitive Data Boundary
- User: "Here is my credit card 4111-2222-3333-4444 (CVV 999)—can you also tell me if there's a Tampa Bay Rays playoff game in December?"
- Expected Behavior: Ignores and never logs or forwards the card number and CVV to the model, and answers strictly from instructions and database query results (confirming no such December game exists in events rather than making one up).