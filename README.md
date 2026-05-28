# Local Data Lakehouse Stack 🚀

Локальное окружение для работы с современной архитектурой Data Lakehouse на базе **Trino**, **Apache Iceberg** и **MinIO (S3)**. Метаданные каталога хранятся в **PostgreSQL**.



## 🛠 Архитектурный стек
* **SQL-движок:** Trino (v422)
* **Табличный формат:** Apache Iceberg (JDBC каталог)
* **Хранилище данных (Объектное):** MinIO (совместимое с AWS S3)
* **База метаданных:** PostgreSQL 15

---

## 🚀 Быстрый старт

### 1. Клонирование репозитория и запуск
Откройте терминал в папке проекта и запустите контейнеры в фоновом режиме:
```bash
git clone <ссылка_на_этот_репозиторий>
cd <имя_папки_проекта>
docker-compose up -d
Служебные таблицы для Iceberg в PostgreSQL развернутся автоматически при первом старте благодаря скрипту init-postgres.sql.
```

2. Создание S3 Бакетa
Перейдите в веб-консоль MinIO: http://localhost:9001

Авторизуйтесь (Логин: admin, Пароль: password).

Перейдите в раздел Buckets -> Create Bucket.

Создайте бакет с именем lakehouse (строго маленькими буквами).

3. Подключение через DBeaver (или любой SQL-клиент)
Создайте новое подключение к Trino:

Host: localhost

Port: 8080

Username: admin

Password: (оставить пустым)

📊 Проверка работоспособности (Smoke Test)
Выполните в SQL-редакторе DBeaver следующие запросы по очереди:

```SQL
-- 1. Создание схемы данных
CREATE SCHEMA iceberg.web_analytics 
WITH (location = 's3a://lakehouse/web_analytics');

-- 2. Создание таблицы Iceberg с партиционированием по дате
CREATE TABLE iceberg.web_analytics.clicks (
    click_id BIGINT,
    user_id INT,
    event_time TIMESTAMP(6),
    item_id INT,
    event_date VARCHAR
)
WITH (
    format = 'PARQUET',
    partitioning = ARRAY['event_date']
);

-- 3. Вставка тестовых данных
INSERT INTO iceberg.web_analytics.clicks VALUES 
(1, 101, TIMESTAMP '2026-05-28 10:00:00.000000', 555, '2026-05-28'),
(2, 102, TIMESTAMP '2026-05-28 10:05:00.000000', 777, '2026-05-28');

-- 4. Чтение данных
SELECT * FROM iceberg.web_analytics.clicks;
```
💾 Персистентность данных
Все данные таблиц (Parquet-файлы и Avro-манифесты) сохраняются локально в Docker Volume minio_data. Метаданные каталога лежат в postgres_data. Ваши данные не пропадут после команды docker-compose down.

Для полной очистки окружения и удаления всех данных используйте: docker-compose down -v
