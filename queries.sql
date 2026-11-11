-- Add data to tables
PRAGMA foreign_keys = OFF;
.mode csv
.separator ";"
.import --skip 1 clients.csv clients
.import --skip 1 suppliers.csv suppliers
.import products.csv temp
INSERT OR IGNORE INTO "products" ("code", "name", "purchase_price", "selling_price", "stock")
SELECT "code", "name", "purchase_price", "selling_price", "stock" FROM "temp";
DROP TABLE "temp";
.import --skip 1 orders.csv orders
.import --skip 1 receipts.csv receipts
.import --skip 1 order_c.csv order_contents
.import --skip 1 receipt_c.csv receipt_contents
PRAGMA foreign_keys = ON;
.mode table
.headers on

EXPLAIN QUERY PLAN
--Find all unpaid invoices
SELECT * FROM "orders" WHERE "status" = 'not paid';
--Tracking the 10 products with the largest stock levels
SELECT "name", "stock" FROM "products"
ORDER BY "stock" DESC LIMIT 10;
--Find all customers by purchase date
SELECT "last_name", "first_name" FROM "clients"
WHERE "id" = (
    SELECT "id_client"
    FROM "receipts"
    WHERE "date" = '2026-10-01'
);
--Use a view to see the products that customers have purchased
SELECT * FROM "receipt_cont";

