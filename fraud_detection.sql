-- 1️⃣ Detect Duplicate Transactions (Same Customer, Same Amount, Same Merchant, Within 5 Minutes)

WITH DuplicateTransactions AS (
    SELECT 
        customer_id, 
        transaction_amount, 
        merchant_name, 
        transaction_date, 
        LEAD(transaction_date) OVER (PARTITION BY customer_id, transaction_amount, merchant_name ORDER BY transaction_date) AS next_transaction
    FROM transactions
)
SELECT * 
FROM DuplicateTransactions
WHERE next_transaction IS NOT NULL 
AND next_transaction - transaction_date <= INTERVAL '5 minutes';

--🔹 Why? Fraudsters often try to process the same transaction multiple times in a short period.



--2️⃣ Identify High-Value Transactions (Above $3000)

SELECT * FROM transactions
WHERE transaction_amount > 3000
ORDER BY transaction_amount DESC;

--🔹 Why? Large transactions have a higher fraud risk.



--3️⃣ Find Customers with Multiple Failed Transactions (Potential Card Testing Fraud)

SELECT customer_id, COUNT(*) AS failed_attempts
FROM transactions
WHERE transaction_status = 'Failed'
GROUP BY customer_id
HAVING COUNT(*) > 3;

--🔹 Why? Fraudsters often test stolen cards by making multiple failed attempts.



--4️⃣ Identify Customers with More Than 2 Fraudulent Transactions

SELECT customer_id, COUNT(*) AS fraud_count
FROM transactions
WHERE transaction_status = 'Fraudulent'
GROUP BY customer_id
HAVING COUNT(*) > 2;

--🔹 Why? If a customer has multiple fraudulent transactions, they might be a fraudster.



--5️⃣ Find Transactions at Unusual Hours (Midnight to 5 AM)

SELECT * FROM transactions
WHERE EXTRACT(HOUR FROM transaction_date) BETWEEN 0 AND 5;

--🔹 Why? Most fraudulent transactions occur during non-business hours.