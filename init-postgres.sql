-- Создаем таблицы метаданных Iceberg
CREATE TABLE IF NOT EXISTS iceberg_namespaces (
    catalog_name VARCHAR(255) NOT NULL,
    table_namespace VARCHAR(255) NOT NULL,
    PRIMARY KEY (catalog_name, table_namespace)
);

CREATE TABLE IF NOT EXISTS iceberg_tables (
    catalog_name VARCHAR(255) NOT NULL,
    table_namespace VARCHAR(255) NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    metadata_location VARCHAR(1000) NOT NULL,
    previous_metadata_location VARCHAR(1000),
    PRIMARY KEY (catalog_name, table_namespace, table_name)
);

CREATE TABLE IF NOT EXISTS iceberg_namespace_properties (
    catalog_name VARCHAR(255) NOT NULL,
    namespace VARCHAR(255) NOT NULL,
    property_key VARCHAR(255) NOT NULL,
    property_value VARCHAR(1000) NOT NULL,
    PRIMARY KEY (catalog_name, namespace, property_key)
);

CREATE TABLE IF NOT EXISTS iceberg_lock (
    catalog_name VARCHAR(255) NOT NULL,
    table_namespace VARCHAR(255) NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    lock_id BIGINT NOT NULL,
    PRIMARY KEY (catalog_name, table_namespace, table_name)
);