# Zomato-SQL-Analysis
Analyzed food delivery transactions, customer ordering patterns, rider logistics, and restaurant revenue using SQL to identify peak operational windows, delivery bottlenecks, retention risks, and city level performance trends.
## Business Context
The food delivery ecosystem requires balancing consumer demand, restaurant preparation, and delivery logistics. 

The core business problem is:
A high volume of orders is placed across cities, but operational inefficiencies such as undelivered orders, cancellation spikes, delivery delays, and customer drop offs can undermine revenue and customer retention.

The analysis investigates order transactions, rider fulfillment times, restaurant sales, and customer activity to identify:
- High-value customer cohorts and churn risks between operating years
- Peak order time windows and seasonal item level demand
- Order cancellation and fulfillment breakdowns across restaurants
- Rider logistics, average delivery durations, and service rating tiers
- City-level and restaurant level revenue generation and monthly growth rates

The overall goal is to connect transactional data with logistics and customer behavior to deliver actionable operational insights.

## Dataset Overview
The analysis uses five relational tables linked primarily through primary and foreign key constraints (`customer_id`, `restaurant_id`, `order_id`, `rider_id`):

| Dataset | Purpose |
| :--- | :--- |
| **`customers`** | Customer demographic and account registration records |
| **`restaurants`** | Restaurant profiles, city locations, and operating hours |
| **`orders`** | Transaction-level order details, items, timestamps, status, and amounts |
| **`riders`** | Delivery partner information and sign-up dates |
| **`deliveries`** | Order fulfillment logs, delivery timestamps, and delivery status |

### Customers
Contains customer profile details:
- `customer_id`
- `customer_name`
- `reg_date`

### Restaurants
Contains dining and merchant metadata:
- `restaurant_id`
- `restaurant_name`
- `city`
- `opening_hours`

### Orders
Contains granular order transactional data:
- `order_id`
- `customer_id`
- `restaurant_id`
- `order_item`
- `order_date`
- `order_time`
- `order_status`
- `total_amount`

### Riders
Contains delivery partner records:
- `rider_id`
- `rider_name`
- `sign_up`

### Deliveries
Contains fulfillment and delivery logistics tracking:
- `delivery_id`
- `order_id`
- `delivery_status`
- `delivery_time`
- `rider_id`

## Key Analysis
- Conducted data cleaning and integrity checks to handle missing records and null values.
- Identified peak demand intervals using 2-hour order time slots.
- Evaluated high-value spenders (>100k) and calculated Average Order Value (AOV) for frequent customers.
- Detected placed orders with missing deliveries by restaurant and city.
- Ranked restaurants by annual gross revenue within their respective cities.
- Identified the most popular dish across each city.
- Analyzed customer churn by identifying active customers in 2023 with no orders in 2024.
- Evaluated year over year cancellation rates across restaurants.
- Measured rider delivery turnaround times (handling midnight crossovers) and categorized riders into 3 star, 4 star, and 5 star performance tiers.
- Tracked month over month restaurant growth ratios and sales trends.
- Segmented customer base into Gold and Silver categories relative to average order value.
- Calculated rider monthly commission earnings based on gross order volume.
- Assessed Customer Lifetime Value (CLV) and mapped seasonal demand patterns across food items.

## Tech Stack
SQL | PostgreSQL | CTEs | Window Functions | Joins | Aggregations | Date & Time Functions
