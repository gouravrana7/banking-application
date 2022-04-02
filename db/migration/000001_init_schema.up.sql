-- We need 3 CREATE TABLE queries to create the accounts, entries and transfers table.
-- Then 3 ALTER TABLE queries to add foreign keys to the tables.
-- Then 5 CREATE INDEX queries to create all the indexes.
-- And finally 2 COMMENT queries to add the comments to the amount columns.

-- table to hold basic account information
CREATE TABLE "accounts" (
  "id" bigserial PRIMARY KEY,
  "owner" varchar(255) NOT NULL,
  "balance" bigint NOT NULL,
  "currency" varchar(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

-- to record all changes to the bank account
CREATE TABLE "entries" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint NOT NULL,
  "amount" bigint NOT NULL, --COMMENT 'can be negative or positive',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

-- to record money transfer b/w two accounts
CREATE TABLE "transfers" (
  "id" bigserial PRIMARY KEY,
  "from_account_id" bigint NOT NULL,
  "to_account_id" bigint NOT NULL,
  "amount" bigint NOT NULL, --COMMENT 'must be positive',
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

ALTER TABLE "entries" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");
ALTER TABLE "transfers" ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts" ("id");
ALTER TABLE "transfers" ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts" ("id");

-- if we might want to search for accounts by owner name, So let;s add owner to the list of the indexes.
CREATE INDEX "accounts_index_0" ON "accounts" ("owner");

-- if we might want to list all entries of a specific account, so let;s add account_id to the index
CREATE INDEX "entries_index_1" ON "entries" ("account_id");

-- We might want to search for all transfers that going out of an account. So from_account_id should be a index.
CREATE INDEX "transfers_index_2" ON "transfers" ("from_account_id");

-- We might want to look for all transfers that going in to an account. So to_account_id should be another index.
CREATE INDEX "transfers_index_3" ON "transfers" ("to_account_id");

-- if we want to search for all transfers between 2 specific accounts, then we need a composite index of both from_account_id and to_account_id
CREATE INDEX "transfers_index_4" ON "transfers" ("from_account_id", "to_account_id");

-- dbdiagram.io
-- refer: https://docs.google.com/document/d/1rlBtD3GpXsav_neIBf2BW1pvTxsPqIFCjQRHZmlZLCY/edit?usp=sharing
-- Table accounts as A {
--   id bigserial [pk]
--   owner varchar [not null]
--   balance bigint [not null]
--   currency varchar [not null]
--   created_at timestamptz [not null, default: "now()"]

--   Indexes {
--     owner
--   }
-- }

-- Table entries {
--   id bigserial [pk]
--   account_id bigint [ref: > A.id, not null]
--   amount bigint [not null, note: 'can be negative or positive']
--   created_at timestamptz [not null, default: "now()"]

--   Indexes {
--     account_id
--   }
-- }

-- Table transfers {
--   id bigserial [pk]
--   from_account_id bigint [ref: > A.id, not null]
--   to_account_id bigint [ref: > A.id, not null]
--   amount bigint [not null, note: 'must be positive']
--   created_at timestamptz [not null, default: "now()"]

--   Indexes {
--     from_account_id
--     to_account_id
--     (from_account_id, to_account_id)
--   }
-- }