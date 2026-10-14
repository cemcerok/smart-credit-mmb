
-- 1. Пользователи
CREATE TABLE IF NOT EXISTS users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. Предприятия
CREATE TABLE IF NOT EXISTS businesses (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_id BIGINT NOT NULL REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    annual_revenue NUMERIC(16, 2) NOT NULL
        CHECK (annual_revenue >= 0),
    employee_count INTEGER NOT NULL
        CHECK (employee_count >= 0),
    years_operating INTEGER NOT NULL
        CHECK (years_operating >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Кредитные продукты
CREATE TABLE IF NOT EXISTS credit_products (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bank_name VARCHAR(150) NOT NULL,
    name VARCHAR(255) NOT NULL,
    min_amount NUMERIC(16, 2) NOT NULL
        CHECK (min_amount > 0),
    max_amount NUMERIC(16, 2) NOT NULL
        CHECK (max_amount >= min_amount),
    interest_rate NUMERIC(6, 3) NOT NULL
        CHECK (interest_rate >= 0),
    min_term_months INTEGER NOT NULL
        CHECK (min_term_months > 0),
    max_term_months INTEGER NOT NULL
        CHECK (max_term_months >= min_term_months),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- 4. Кредитные заявки
CREATE TABLE IF NOT EXISTS applications (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    business_id BIGINT NOT NULL REFERENCES businesses(id),
    credit_product_id BIGINT NOT NULL
        REFERENCES credit_products(id),
    requested_amount NUMERIC(16, 2) NOT NULL
        CHECK (requested_amount > 0),
    term_months INTEGER NOT NULL
        CHECK (term_months > 0),
    status VARCHAR(30) NOT NULL DEFAULT 'draft'
        CHECK (status IN (
            'draft',
            'submitted',
            'approved',
            'rejected'
        )),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Индексы внешних ключей
CREATE INDEX IF NOT EXISTS idx_businesses_owner
    ON businesses(owner_id);

CREATE INDEX IF NOT EXISTS idx_applications_business
    ON applications(business_id);

CREATE INDEX IF NOT EXISTS idx_applications_product
    ON applications(credit_product_id);
