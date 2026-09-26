# Zomato-SQL-Analysis
Analyzed food delivery transactions, customer ordering patterns, rider logistics, and restaurant revenue using SQL to identify peak operational windows, delivery bottlenecks, retention risks, and city level performance trends.
## Business Context

The project analyzes food delivery data across customers, restaurants, orders, riders, and deliveries to understand how ordering behavior, restaurant performance, and delivery operations contribute to overall business performance.

The core business problem is:

> Food delivery platforms generate large volumes of transactional and operational data, but identifying customer trends, revenue opportunities, and delivery inefficiencies requires structured analysis.

The analysis connects customer activity, order transactions, restaurant performance, and delivery operations to identify:

- Customers with high spending and long-term value
- Customers at risk of churn
- Restaurants generating high revenue within their cities
- Peak ordering periods and popular dishes
- Rider delivery performance and efficiency
- Cities with higher overall revenue contribution

The overall goal is to transform transactional food delivery data into **actionable business and operational insights**.

## Dataset Overview

The analysis uses five interconnected datasets linked primarily through customer, restaurant, order, and rider IDs:

| **Dataset** | **Rows** | **Purpose** |
|---|---:|---|
| **Customers** | 33 | Customer information and registration details |
| **Restaurants** | 71 | Restaurant information, cities, and opening hours |
| **Orders** | 10,000 | Order transactions, items, dates, times, status, and order value |
| **Riders** | 34 | Rider information and sign-up details |
| **Deliveries** | 9,750 | Delivery status, delivery time, and rider assignments |

### Customers

Contains customer information such as:

- Customer ID
- Customer Name
- Registration Date

### Restaurants

Contains restaurant information such as:

- Restaurant ID
- Restaurant Name
- City
- Opening Hours

### Orders

Contains transaction-level information such as:

- Order ID
- Customer ID
- Restaurant ID
- Order Item
- Order Date
- Order Time
- Order Status
- Total Amount

### Riders

Contains rider information such as:

- Rider ID
- Rider Name
- Sign-up Date

### Deliveries

Contains delivery information such as:

- Delivery ID
- Order ID
- Delivery Status
- Delivery Time
- Rider ID

## Key Analysis

The project contains 20 business-focused SQL analyses covering:

- Identified popular ordering time slots.
- Analyzed Average Order Value (AOV).
- Identified high-value customers based on total spending.
- Analyzed orders without delivery records.
- Ranked restaurants by revenue within their cities.
- Identified the most popular dishes across cities.
- Identified customers who stopped ordering.
- Compared restaurant-level cancellation/non-delivery rates.
- Calculated average rider delivery time.
- Measured monthly restaurant growth.
- Segmented customers based on spending behavior.
- Calculated monthly rider earnings.
- Analyzed rider ratings based on delivery time.
- Identified peak ordering days for restaurants.
- Calculated Customer Lifetime Value (CLV).
- Analyzed monthly sales trends.
- Evaluated rider delivery efficiency.
- Tracked order-item popularity and seasonal demand.
- Ranked cities based on total revenue.

## Tech Stack

**SQL | PostgreSQL | CTEs | Window Functions | Joins | Subqueries | Aggregations | Date & Time Functions**
