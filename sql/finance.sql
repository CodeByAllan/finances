DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'finances') THEN
        CREATE DATABASE finances;
    END IF;
END $$;

\c finances;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at DATE DEFAULT CURRENT_DATE
);

CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_update_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();

CREATE TABLE revenues (
    id SERIAL PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    value DECIMAL(10, 2) NOT NULL,
    user_id INT REFERENCES users(id),
    date DATE NOT NULL
);

CREATE TABLE expenses (
    id SERIAL PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    value DECIMAL(10, 2) NOT NULL,
    user_id INT REFERENCES users(id) NOT NULL,
    date DATE NOT NULL
);
