CREATE TABLE IF NOT EXISTS  clients (
    id UUID PRIMARY KEY,
    ip TEXT NOT NULL CHECK (ip <> ''),
    first_name TEXT NOT NULL CHECK (first_name <> ''),
    last_name TEXT NOT NULL CHECK (last_name <> '')
);

CREATE TABLE IF NOT EXISTS  currencies (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE CHECK (name <> ''),
    symbol TEXT NOT NULL CHECK (symbol <> ''),
    exchange_rate DECIMAL(18,6) NOT NULL CHECK (exchange_rate > 0)
);

CREATE TABLE IF NOT EXISTS withdraw_statuses (
    id SERIAL PRIMARY KEY,
    status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS withdraw_requests (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW(),
    client_ip TEXT NOT NULL,

    client_id UUID NOT NULL,
    status_id INT NOT NULL,
    currency_id INT NOT NULL,

    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES withdraw_statuses(id) ON DELETE RESTRICT,
    FOREIGN KEY (currency_id) REFERENCES currencies(id) ON DELETE RESTRICT
);

INSERT INTO withdraw_statuses (status)
VALUES
    ('Pending'),
    ('Failed'),
    ('Accepted'),
    ('Ready'),
    ('Finished');

--
-- Procedures
--

CREATE OR REPLACE PROCEDURE sp_save_withdraw_request(
    IN p_request_id UUID,
    IN p_client_id UUID,
    IN p_department_address TEXT,
    IN p_amount DECIMAL(18,2),
    IN p_currency_id INT,
    IN p_client_ip TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO withdraw_requests (id, client_id, department_address, amount, currency_id, client_ip)
    VALUES (p_request_id, p_client_id, p_department_address, p_amount, p_currency_id, p_client_ip);
END;
$$;

CREATE OR REPLACE PROCEDURE sp_get_request_status_by_id(
    IN p_request_id UUID,
    INOUT p_request_id_out UUID,
    INOUT p_status TEXT,
    INOUT p_currency_name TEXT,
    INOUT p_currency_symbol TEXT,
    INOUT p_amount DECIMAL(18,2)
)
LANGUAGE plpgsql AS $$
BEGIN
    SELECT wr.id, ws.status, c.name, c.symbol, wr.amount
    INTO p_request_id_out, p_status, p_currency_name, p_currency_symbol, p_amount
    FROM withdraw_requests wr
    JOIN withdraw_statuses ws ON wr.status_id = ws.id
    JOIN currencies c ON wr.currency_id = c.id
    WHERE wr.id = p_request_id;
END;
$$;


CREATE OR REPLACE PROCEDURE sp_get_requests_by_client_and_department(
    IN p_client_id UUID,
    IN p_department_address TEXT,
    INOUT p_cursor REFCURSOR
)
LANGUAGE plpgsql AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT wr.id, ws.status, c.name, c.symbol, wr.amount
    FROM withdraw_requests wr
    JOIN withdraw_statuses ws ON wr.status_id = ws.id
    JOIN currencies c ON wr.currency_id = c.id
    WHERE wr.client_id = p_client_id
      AND wr.department_address = p_department_address;
END;
$$;

