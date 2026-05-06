-- This is an empty migration.
-- ============================================
-- RECREAR SUNAT SERIES
-- ============================================
CREATE TABLE sunat_series (
  id             TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  tipo_documento VARCHAR(2) NOT NULL,
  serie          VARCHAR(4) NOT NULL,
  correlativo    INT DEFAULT 1,
  is_active      BOOLEAN DEFAULT true,
  created_at     TIMESTAMP DEFAULT NOW(),
  updated_at     TIMESTAMP DEFAULT NOW(),
  UNIQUE(tipo_documento, serie)
);

-- Series iniciales
INSERT INTO sunat_series (id, tipo_documento, serie, correlativo) VALUES
  (gen_random_uuid()::TEXT, '01', 'F001', 1),
  (gen_random_uuid()::TEXT, '03', 'B001', 1),
  (gen_random_uuid()::TEXT, '07', 'FC01', 1),
  (gen_random_uuid()::TEXT, '07', 'BC01', 1),
  (gen_random_uuid()::TEXT, '08', 'FD01', 1),
  (gen_random_uuid()::TEXT, '08', 'BD01', 1);

CREATE TRIGGER trg_sunat_series
  BEFORE UPDATE ON sunat_series
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();