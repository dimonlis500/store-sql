--Represents store customers
CREATE TABLE "clients" (
    "id" INTEGER,
    "last_name" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "discount" INTEGER CHECK ("discount" IN (1, 3, 5)),
    PRIMARY KEY ("id")
);
--Conteins information about the supplier
CREATE TABLE "suppliers" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "phone_number" TEXT,
    PRIMARY KEY ("id")
);
--Contains information about the product
CREATE TABLE "products" (
    "id" INTEGER,
    "code" INTEGER NOT NULL,
    "name" TEXT NOT NULL UNIQUE,
    "purchase_price" NUMERIC NOT NULL,
    "selling_price" NUMERIC NOT NULL,
    "stock" NUMERIC,
    PRIMARY KEY ("id")
);
--Provides order information
CREATE TABLE "orders" (
    "id" INTEGER,
    "id_supplier" INTEGER,
    "invoice_number" TEXT UNIQUE,
    "date" TEXT NOT NULL,
    "status" TEXT CHECK ("status" IN ('paid', 'not paid')),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("id_supplier") REFERENCES "suppliers" ("id")
);
--Provides information about the contents of the order
CREATE TABLE "order_contents" (
    "id" INTEGER,
    "id_order" INTEGER,
    "id_product" INTEGER,
    "purchase_price" NUMERIC NOT NULL,
    "quantity_order" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("id_order") REFERENCES "orders" ("id"),
    FOREIGN KEY ("id_product") REFERENCES "products" ("id")
);
--Presents receipt information
CREATE TABLE "receipts" (
    "id" INTEGER,
    "id_client" INTEGER,
    "date" TEXT NOT NULL DEFAULT ("date" ('now', 'localtime')),
    "discount" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("id_client") REFERENCES "clients"("id")
);
--Provides information about the contents of the receipt
CREATE TABLE "receipt_contents" (
    "id" INTEGER,
    "id_receipt" INTEGER,
    "id_product" INTEGER,
    "quantity_sold" NUMERIC NOT NULL,
    "selling_price" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("id_receipt") REFERENCES "receipts" ("id"),
    FOREIGN KEY ("id_product") REFERENCES "products" ("id")
);
--Create indexes to speed common searches
CREATE INDEX "products_stock" ON "products" ("stock" DESC, "name");
CREATE INDEX "receipt_date" ON "receipts" ("date");
CREATE INDEX "orders_status" ON "orders" ("status");
--Create triggers to update data in tables
CREATE TRIGGER "update_purchase_price"
AFTER INSERT ON "order_contents"
BEGIN
    UPDATE "products"
    SET "purchase_price" = NEW."purchase_price"
    WHERE "id" = NEW."id_product";
END;
CREATE TRIGGER "update_stock"
AFTER INSERT ON "order_contents"
BEGIN
    UPDATE "products"
    SET "stock" = "stock" + NEW."quantity_order"
    WHERE "id" = NEW."id_product";
END;
CREATE TRIGGER "update_stock_sold"
AFTER INSERT ON "receipt_contents"
BEGIN
    UPDATE "products"
    SET "stock" = "stock" - NEW."quantity_sold"
    WHERE "id" = NEW."id_product";
END;
--Creating a view to see the products that customers have purchased
CREATE VIEW "receipt_cont" AS
SELECT "last_name", "first_name", "name"
FROM "clients"
JOIN "receipts" ON "receipts"."id_client" = "clients"."id"
JOIN "receipt_contents" ON "receipt_contents"."id_receipt" = "receipts"."id"
JOIN "products" ON "products"."id" = "receipt_contents"."id_product";
