-- ============================================
-- 1. CÓDIGOS DE DESCUENTO
-- ============================================
CREATE TABLE promo_codes (
  id             TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  code           VARCHAR(50) UNIQUE NOT NULL,
  description    VARCHAR(200),
  discount_type  VARCHAR(20) CHECK (discount_type IN ('percent', 'fixed')),
  discount_value DECIMAL(10,2) NOT NULL,
  min_amount     DECIMAL(10,2) DEFAULT 0,
  max_uses       INT,
  uses_count     INT DEFAULT 0,
  valid_from     TIMESTAMP DEFAULT NOW(),
  valid_until    TIMESTAMP,
  applicable_tours TEXT[],
  is_active      BOOLEAN DEFAULT true,
  created_by     TEXT REFERENCES admin_users(id),
  created_at     TIMESTAMP DEFAULT NOW(),
  updated_at     TIMESTAMP DEFAULT NOW()
);

ALTER TABLE bookings
  ADD COLUMN promo_code_id TEXT REFERENCES promo_codes(id),
  ADD COLUMN promo_code    VARCHAR(50);

CREATE INDEX idx_promo_code ON promo_codes(code);

CREATE TRIGGER trg_promo_codes
  BEFORE UPDATE ON promo_codes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 2. GUÍAS TURÍSTICOS
-- ============================================
CREATE TABLE guides (
  id             TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  full_name      VARCHAR(150) NOT NULL,
  email          VARCHAR(150) UNIQUE,
  phone          VARCHAR(30),
  whatsapp       VARCHAR(30),
  photo_url      TEXT,
  bio            TEXT,
  languages      TEXT[],
  specialties    TEXT[],
  license_number VARCHAR(100),
  rating         DECIMAL(3,2) DEFAULT 0,
  total_tours    INT DEFAULT 0,
  is_active      BOOLEAN DEFAULT true,
  created_at     TIMESTAMP DEFAULT NOW(),
  updated_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tour_availability_guides (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  availability_id TEXT REFERENCES tour_availability(id) ON DELETE CASCADE,
  guide_id        TEXT REFERENCES guides(id) ON DELETE CASCADE,
  assigned_at     TIMESTAMP DEFAULT NOW(),
  UNIQUE(availability_id, guide_id)
);

ALTER TABLE bookings
  ADD COLUMN guide_id TEXT REFERENCES guides(id);

CREATE INDEX idx_guides_active ON guides(is_active);

CREATE TRIGGER trg_guides
  BEFORE UPDATE ON guides
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 3. NEWSLETTER
-- ============================================
CREATE TABLE subscribers (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  email           VARCHAR(150) UNIQUE NOT NULL,
  full_name       VARCHAR(150),
  language        VARCHAR(10) DEFAULT 'es',
  interests       TEXT[],
  source          VARCHAR(50)
                  CHECK (source IN (
                    'website', 'popup', 'booking',
                    'blog', 'social', 'other'
                  )),
  is_active       BOOLEAN DEFAULT true,
  confirmed       BOOLEAN DEFAULT false,
  confirm_token   VARCHAR(200),
  subscribed_at   TIMESTAMP DEFAULT NOW(),
  unsubscribed_at TIMESTAMP
);

CREATE TABLE email_campaigns (
  id           TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  subject      VARCHAR(300) NOT NULL,
  content      TEXT NOT NULL,
  target       VARCHAR(30) DEFAULT 'all'
               CHECK (target IN ('all', 'vip', 'inactive', 'custom')),
  status       VARCHAR(20) DEFAULT 'draft'
               CHECK (status IN ('draft', 'scheduled', 'sent', 'canceled')),
  scheduled_at TIMESTAMP,
  sent_at      TIMESTAMP,
  recipients   INT DEFAULT 0,
  opens        INT DEFAULT 0,
  clicks       INT DEFAULT 0,
  created_by   TEXT REFERENCES admin_users(id),
  created_at   TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_subscribers_email  ON subscribers(email);
CREATE INDEX idx_subscribers_active ON subscribers(is_active);

-- ============================================
-- 4. WISHLIST
-- ============================================
CREATE TABLE wishlists (
  id         TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  client_id  TEXT REFERENCES clients(id) ON DELETE CASCADE,
  tour_id    TEXT REFERENCES tours(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(client_id, tour_id)
);

CREATE INDEX idx_wishlist_client ON wishlists(client_id);
CREATE INDEX idx_wishlist_tour   ON wishlists(tour_id);

-- ============================================
-- 5. PAQUETES
-- ============================================
CREATE TABLE packages (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  slug            VARCHAR(200) UNIQUE NOT NULL,
  thumbnail_url   TEXT,
  duration_days   INT,
  original_price  DECIMAL(10,2),
  package_price   DECIMAL(10,2),
  savings_percent DECIMAL(5,2),
  min_travelers   INT DEFAULT 1,
  max_travelers   INT DEFAULT 15,
  includes        TEXT[],
  not_includes    TEXT[],
  status          VARCHAR(20) DEFAULT 'draft'
                  CHECK (status IN (
                    'draft', 'published', 'featured', 'hidden'
                  )),
  created_by      TEXT REFERENCES admin_users(id),
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE TABLE package_tours (
  id         TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  package_id TEXT REFERENCES packages(id) ON DELETE CASCADE,
  tour_id    TEXT REFERENCES tours(id) ON DELETE CASCADE,
  day_number INT,
  sort_order INT DEFAULT 0,
  UNIQUE(package_id, tour_id)
);

ALTER TABLE bookings
  ADD COLUMN package_id TEXT REFERENCES packages(id);

CREATE INDEX idx_packages_slug   ON packages(slug);
CREATE INDEX idx_packages_status ON packages(status);

CREATE TRIGGER trg_packages
  BEFORE UPDATE ON packages
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 6. AFILIADOS
-- ============================================
CREATE TABLE affiliates (
  id               TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  full_name        VARCHAR(150) NOT NULL,
  email            VARCHAR(150) UNIQUE NOT NULL,
  phone            VARCHAR(30),
  referral_code    VARCHAR(50) UNIQUE NOT NULL,
  commission_type  VARCHAR(20) DEFAULT 'percent'
                   CHECK (commission_type IN ('percent', 'fixed')),
  commission_value DECIMAL(10,2) DEFAULT 10.00,
  total_referrals  INT DEFAULT 0,
  total_earned     DECIMAL(10,2) DEFAULT 0,
  total_paid       DECIMAL(10,2) DEFAULT 0,
  pending_payment  DECIMAL(10,2) DEFAULT 0,
  payment_method   VARCHAR(50),
  payment_details  TEXT,
  is_active        BOOLEAN DEFAULT true,
  joined_at        TIMESTAMP DEFAULT NOW(),
  created_at       TIMESTAMP DEFAULT NOW(),
  updated_at       TIMESTAMP DEFAULT NOW()
);

CREATE TABLE affiliate_payments (
  id           TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  affiliate_id TEXT REFERENCES affiliates(id) ON DELETE CASCADE,
  amount       DECIMAL(10,2) NOT NULL,
  method       VARCHAR(50),
  reference    VARCHAR(200),
  notes        TEXT,
  paid_at      TIMESTAMP DEFAULT NOW()
);

ALTER TABLE bookings
  ADD COLUMN affiliate_id      TEXT REFERENCES affiliates(id),
  ADD COLUMN referral_code     VARCHAR(50),
  ADD COLUMN commission_amount DECIMAL(10,2) DEFAULT 0;

CREATE INDEX idx_affiliates_code ON affiliates(referral_code);

CREATE TRIGGER trg_affiliates
  BEFORE UPDATE ON affiliates
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 7. TRADUCCIONES ESPECÍFICAS
-- ============================================
CREATE TABLE tour_translations (
  id                TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  tour_id           TEXT REFERENCES tours(id) ON DELETE CASCADE,
  language          VARCHAR(10) NOT NULL,
  name              VARCHAR(200),
  short_description TEXT,
  full_description  TEXT,
  includes          TEXT[],
  not_includes      TEXT[],
  what_to_bring     TEXT[],
  meeting_point     TEXT,
  meta_title        VARCHAR(200),
  meta_description  TEXT,
  created_at        TIMESTAMP DEFAULT NOW(),
  updated_at        TIMESTAMP DEFAULT NOW(),
  UNIQUE(tour_id, language)
);

CREATE TABLE package_translations (
  id               TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  package_id       TEXT REFERENCES packages(id) ON DELETE CASCADE,
  language         VARCHAR(10) NOT NULL,
  name             VARCHAR(200),
  description      TEXT,
  includes         TEXT[],
  not_includes     TEXT[],
  meta_title       VARCHAR(200),
  meta_description TEXT,
  created_at       TIMESTAMP DEFAULT NOW(),
  updated_at       TIMESTAMP DEFAULT NOW(),
  UNIQUE(package_id, language)
);

CREATE TABLE blog_translations (
  id               TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  article_id       TEXT REFERENCES blog_articles(id) ON DELETE CASCADE,
  language         VARCHAR(10) NOT NULL,
  title            VARCHAR(300),
  excerpt          TEXT,
  content          TEXT,
  meta_title       VARCHAR(200),
  meta_description TEXT,
  created_at       TIMESTAMP DEFAULT NOW(),
  updated_at       TIMESTAMP DEFAULT NOW(),
  UNIQUE(article_id, language)
);

CREATE INDEX idx_tour_lang    ON tour_translations(tour_id, language);
CREATE INDEX idx_package_lang ON package_translations(package_id, language);
CREATE INDEX idx_blog_lang    ON blog_translations(article_id, language);

CREATE TRIGGER trg_tour_translations
  BEFORE UPDATE ON tour_translations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_package_translations
  BEFORE UPDATE ON package_translations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_blog_translations
  BEFORE UPDATE ON blog_translations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 8. SEGURO DE VIAJE
-- ============================================
CREATE TABLE insurance_plans (
  id            TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  name          VARCHAR(150) NOT NULL,
  description   TEXT,
  price_per_pax DECIMAL(10,2) NOT NULL,
  coverage      TEXT[],
  max_coverage  DECIMAL(10,2),
  provider      VARCHAR(150),
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMP DEFAULT NOW(),
  updated_at    TIMESTAMP DEFAULT NOW()
);

CREATE TABLE booking_insurance (
  id            TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  booking_id    TEXT REFERENCES bookings(id) ON DELETE CASCADE,
  plan_id       TEXT REFERENCES insurance_plans(id),
  travelers     INT NOT NULL,
  price_per_pax DECIMAL(10,2) NOT NULL,
  total_amount  DECIMAL(10,2) NOT NULL,
  policy_number VARCHAR(100),
  status        VARCHAR(20) DEFAULT 'active'
                CHECK (status IN ('active', 'canceled', 'claimed')),
  created_at    TIMESTAMP DEFAULT NOW(),
  UNIQUE(booking_id)
);

ALTER TABLE bookings
  ADD COLUMN insurance_amount DECIMAL(10,2) DEFAULT 0;

CREATE INDEX idx_insurance_booking ON booking_insurance(booking_id);

CREATE TRIGGER trg_insurance
  BEFORE UPDATE ON insurance_plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- FACTURAS — columnas adicionales
-- ============================================
ALTER TABLE invoices
  ADD COLUMN IF NOT EXISTS document_type VARCHAR(20) DEFAULT 'boleta'
  CHECK (document_type IN ('boleta', 'factura'));

ALTER TABLE invoices
  ADD COLUMN IF NOT EXISTS ruc VARCHAR(11);