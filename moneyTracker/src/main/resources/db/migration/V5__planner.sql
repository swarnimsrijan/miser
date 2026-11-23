-- Transfers between the user's own accounts/cards (e.g. paying the card bill
-- from savings) appear on both statements. Linked pairs are excluded from
-- income and spend so nothing is double counted.
ALTER TABLE transactions ADD COLUMN is_transfer BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE transactions ADD COLUMN transfer_pair_id BIGINT REFERENCES transactions(id) ON DELETE SET NULL;
CREATE INDEX idx_transactions_user_date ON transactions(user_id, transaction_date);

-- Monthly spending cap per category.
CREATE TABLE budgets (
    id                      BIGSERIAL PRIMARY KEY,
    user_id                 BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id             BIGINT NOT NULL REFERENCES categories(id),
    monthly_limit           NUMERIC(15, 2) NOT NULL CHECK (monthly_limit > 0),
    alert_threshold_percent INT NOT NULL DEFAULT 80 CHECK (alert_threshold_percent BETWEEN 1 AND 100),
    created_at              TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, category_id)
);

CREATE TABLE savings_goals (
    id            BIGSERIAL PRIMARY KEY,
    user_id       BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name          VARCHAR(255) NOT NULL,
    target_amount NUMERIC(15, 2) NOT NULL CHECK (target_amount > 0),
    saved_amount  NUMERIC(15, 2) NOT NULL DEFAULT 0,
    target_date   DATE,
    priority      INT NOT NULL DEFAULT 3,
    status        VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE goal_contributions (
    id         BIGSERIAL PRIMARY KEY,
    goal_id    BIGINT NOT NULL REFERENCES savings_goals(id) ON DELETE CASCADE,
    amount     NUMERIC(15, 2) NOT NULL,
    note       VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
