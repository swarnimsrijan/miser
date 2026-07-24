-- =============================================
-- Finance Tracker - Initial Schema
-- =============================================

CREATE TABLE users (
    id              BIGSERIAL PRIMARY KEY,
    email           VARCHAR(255) NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,
    name            VARCHAR(255) NOT NULL,
    profile_image   VARCHAR(512),
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE banks (
    id       BIGSERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL UNIQUE,
    logo     VARCHAR(512),
    country  VARCHAR(100) NOT NULL DEFAULT 'IN'
);

CREATE TABLE accounts (
    id                    BIGSERIAL PRIMARY KEY,
    user_id               BIGINT NOT NULL REFERENCES users(id),
    bank_id               BIGINT NOT NULL REFERENCES banks(id),
    nickname              VARCHAR(255),
    account_number_masked VARCHAR(50),
    account_type          VARCHAR(50) NOT NULL,
    currency              VARCHAR(10) NOT NULL DEFAULT 'INR',
    status                VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at            TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE credit_cards (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT NOT NULL REFERENCES users(id),
    bank_id       BIGINT NOT NULL REFERENCES banks(id),
    card_name     VARCHAR(255) NOT NULL,
    masked_number VARCHAR(50),
    credit_limit  NUMERIC(15, 2),
    billing_date  INT,
    due_date      INT,
    currency      VARCHAR(10) NOT NULL DEFAULT 'INR',
    status        VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE categories (
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE sub_categories (
    id          BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES categories(id),
    name        VARCHAR(100) NOT NULL,
    UNIQUE (category_id, name)
);

CREATE TABLE merchants (
    id              BIGSERIAL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    normalized_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE statements (
    id             BIGSERIAL PRIMARY KEY,
    user_id        BIGINT NOT NULL REFERENCES users(id),
    account_id     BIGINT REFERENCES accounts(id),
    credit_card_id BIGINT REFERENCES credit_cards(id),
    statement_type VARCHAR(20) NOT NULL,
    file_url       VARCHAR(512) NOT NULL,
    checksum       VARCHAR(128),
    status         VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    uploaded_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    from_date      DATE,
    to_date        DATE
);

CREATE TABLE transactions (
    id               BIGSERIAL PRIMARY KEY,
    user_id          BIGINT NOT NULL REFERENCES users(id),
    account_id       BIGINT REFERENCES accounts(id),
    credit_card_id   BIGINT REFERENCES credit_cards(id),
    statement_id     BIGINT REFERENCES statements(id),
    transaction_date DATE NOT NULL,
    description      VARCHAR(512),
    merchant_id      BIGINT REFERENCES merchants(id),
    category_id      BIGINT REFERENCES categories(id),
    sub_category_id  BIGINT REFERENCES sub_categories(id),
    amount           NUMERIC(15, 2) NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    balance          NUMERIC(15, 2),
    currency         VARCHAR(10) NOT NULL DEFAULT 'INR',
    reference        VARCHAR(255),
    remarks          VARCHAR(512),
    created_at       TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_credit_cards_user_id ON credit_cards(user_id);
CREATE INDEX idx_statements_user_id ON statements(user_id);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_credit_card_id ON transactions(credit_card_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_category ON transactions(category_id);
CREATE INDEX idx_transactions_merchant ON transactions(merchant_id);
CREATE INDEX idx_merchants_normalized ON merchants(normalized_name);
