-- 1. Disable triggers to prevent constraint firing during drop
SET session_replication_role = 'replica';

-- 2. Drop View and Tables in order
DROP VIEW IF EXISTS vw_transactions_full CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS temp_transactions CASCADE; -- For cleanup of ETL temp tables
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS agencies CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;

-- 3. Reset session role
SET session_replication_role = 'origin';

SELECT '✅ All tables and views dropped successfully.' AS status;