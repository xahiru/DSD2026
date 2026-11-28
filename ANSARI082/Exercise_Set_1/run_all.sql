-- Command-line use ONLY (mysql client):  mysql -u root -p < run_all.sql
-- In MySQL Workbench use ALL_IN_ONE.sql instead (Workbench does not support SOURCE).
SOURCE 00_setup.sql;
SOURCE 1_1_insert_single.sql;
SOURCE 1_2_insert_multiple.sql;
SOURCE 1_3_insert_null.sql;
SOURCE 1_4_column_order.sql;
SOURCE 1_5_insert_select.sql;
SOURCE 1_6_default_values.sql;
SOURCE 1_7_duplicate_prevention.sql;
SOURCE 1_8_related_tables.sql;
SOURCE 1_9_conditional_insert.sql;
SOURCE 1_10_single_vs_bulk.sql;
