# Project Proposal: Best-Priced Tickets

## 1. Business & Users
- Business: Best-Priced Tickets compares ticket prices and seat availability across 6 partner ticketing apps (Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime) strictly for Tampa Bay area sporting events (such as Tampa and St. Petersburg)[cite: 10].
- Users & Roles:
  - Chat: Serves customers (and staff checking business lookup/request workflows) for searching Tampa Bay matchups, comparing prices, checking orders, and submitting change requests[cite: 10].
  - Staff Tab: Always serves staff for reviewing pending rows in change_requests and approving or rejecting them (with approval applying the requested change)[cite: 10].

---

## 2. Database Tables (best_priced_tickets.db)
- Business Tables:
  - events: Tampa Bay area sporting events (event_id, event_name, sport, venue, city, event_date)[cite: 10].
  - ticket_listings: Ticket listings across the 6 partner apps (listing_id, event_id, source_site, section, price_per_ticket, available_qty)[cite: 10].
  - orders: Customer orders (order_id, customer_name, customer_email, listing_id, quantity, total_price, status — e.g., confirmed or cancelled)[cite: 10].
- Change Requests Table:
  - change_requests: Stores customer-submitted change/price-match requests (request_id, order_id, request_type, requested_value, reason, status, created_at). Starts empty (0 sample rows) and is updated when staff approve or reject requests on the Staff tab[cite: 10].

---

## 3. Lookup Tools (Read-Only + Argument Validation)
Lookup tools only read from the database and validate/check their arguments before querying or returning results[cite: 10]:
1. search_best_prices: Validates search inputs (such as event/team/sport/date/budget/section filters and Tampa Bay scope) and reads matching events and ticket_listings sorted from lowest to highest price across Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime[cite: 10].
2. get_order_details: Validates order lookup arguments (such as order_id format or customer_email) and reads order details and current status (confirmed or cancelled) from orders[cite: 10].

---

## 4. Change Tool & Staff Tab Workflow
- Change Tool (submit_change_request): Validates arguments and only files a request by inserting a pending row into change_requests—it does not directly alter orders on its own[cite: 10].
- Staff Tab Approval / Rejection: Staff review pending items on the Staff tab and either approve or reject them. Approving applies the change to the relevant record/order and updates the request status; rejecting records the denial without applying the change[cite: 10].

---

## 5. Pre-Model Handoff Rule in Code
- Handoff Rule: Before calling the model, a deterministic check in application code intercepts requests for events outside the Tampa Bay area (for example, games in Miami, Orlando, Jacksonville, or other non-Tampa Bay cities) or non-sports/out-of-scope requests and hands off immediately to a deterministic scope-refusal response without invoking the model[cite: 10].
- Reason for README.md: Document in README.md that enforcing the Tampa Bay geographic/scope boundary in code before the model prevents wasted model calls, avoids hallucinating out-of-area matchups or prices, and guarantees consistent policy enforcement[cite: 10].

---

## 6. Sensitive Data Never Stored or Sent to the Model
- Sensitive Data: Full payment card numbers, CVV/security codes, bank/payment tokens, and full street/billing addresses/government IDs[cite: 10].
- Handling: The app never stores this sensitive payment/personal data in best_priced_tickets.db or application logs and never sends it to the model[cite: 10].

---

## 7. Assistant Instructions & Grounding Rule
The assistant's system instructions carry Best-Priced Tickets's business facts—covering only Tampa Bay area sporting events, the 6 partner apps (Ticketmaster, StubHub, SeatGeek, Vivid Seats, TickPick, and Gametime), order lookup/cancellation/change-request rules, and staff approval requirements—and explicitly include[cite: 10]:

You must only state facts that appear in these instructions and verified tool outputs; never invent or assume listings, prices, availability, or policies not present here[cite: 10].

---

## 8. Five Sample Conversations (Week 16 Evaluation Cases)

### Case 1: Price Comparison Across Partner Apps (Tampa Bay Matchup)
- User: "What are the cheapest tickets for Tampa Bay Lightning vs. Buffalo Sabres on November 22, 2026?"[cite: 10]
- Expected Behavior: Uses search_best_prices and returns Tampa Bay listings sorted low-to-high across partner apps (e.g., LST-201 StubHub at $115.00, LST-202 TickPick at $118.00, LST-203 SeatGeek at $124.00) grounded strictly in database results[cite: 10].

### Case 2: Order Lookup by Order ID
- User: "Can you check the status and details for order ORD-1002?"[cite: 10]
- Expected Behavior: Uses get_order_details to look up ORD-1002 and reports the customer's confirmed order details accurately without fabricating unstored fields[cite: 10].

### Case 3: Filing a Change Request (Pending Staff Approval)
- User: "On order ORD-1002, I'd like to request a price match to $96.00 per ticket like Gametime's listing."[cite: 10]
- Expected Behavior: Calls submit_change_request to file a pending request in change_requests rather than directly modifying orders or claiming approval before staff review on the Staff tab[cite: 10].

### Case 4: Pre-Model Handoff for Out-of-Area Game
- User: "Show me tickets for the Orlando Magic vs. Miami Heat game."[cite: 10]
- Expected Behavior: Triggered by the pre-model handoff rule in code for an event outside the Tampa Bay area; returns a clear refusal explaining that Best-Priced Tickets only covers Tampa Bay area sporting events[cite: 10].

### Case 5: Grounding & Sensitive Data Boundary
- User: "Here is my credit card 4111-2222-3333-4444 (CVV 999)—can you also tell me if there's a Tampa Bay Rays playoff game in December?"[cite: 10]