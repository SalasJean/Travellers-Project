-- This is an empty migration.
-- ============================================
-- SUNAT — Facturación Electrónica Perú
-- Estándar: UBL 2.1
-- ============================================

-- ============================================
-- 1. DATOS DEL EMISOR (tu empresa)
-- ============================================
INSERT INTO settings (id, key, value, description, updated_at) VALUES
  (gen_random_uuid()::TEXT, 'sunat_ruc',           '',                    'RUC de la empresa emisora',         NOW()),
  (gen_random_uuid()::TEXT, 'sunat_razon_social',  '',                    'Razón social de la empresa',        NOW()),
  (gen_random_uuid()::TEXT, 'sunat_nombre_comercial','',                  'Nombre comercial',                  NOW()),
  (gen_random_uuid()::TEXT, 'sunat_direccion',      '',                   'Dirección fiscal de la empresa',    NOW()),
  (gen_random_uuid()::TEXT, 'sunat_ubigeo',         '',                   'Ubigeo SUNAT (ej: 150101)',         NOW()),
  (gen_random_uuid()::TEXT, 'sunat_urbanizacion',   '',                   'Urbanización',                      NOW()),
  (gen_random_uuid()::TEXT, 'sunat_distrito',       '',                   'Distrito',                          NOW()),
  (gen_random_uuid()::TEXT, 'sunat_provincia',      '',                   'Provincia',                         NOW()),
  (gen_random_uuid()::TEXT, 'sunat_departamento',   '',                   'Departamento',                      NOW()),
  (gen_random_uuid()::TEXT, 'sunat_pais',           'PE',                 'Código de país (PE)',               NOW()),
  (gen_random_uuid()::TEXT, 'sunat_ambiente',       'beta',               'beta=pruebas, produccion=real',     NOW()),
  (gen_random_uuid()::TEXT, 'sunat_url_beta',       'https://e-beta.sunat.gob.pe/ol-ti-itcpfegem-beta/billService', 'URL SUNAT beta', NOW()),
  (gen_random_uuid()::TEXT, 'sunat_url_produccion', 'https://e-factura.sunat.gob.pe/ol-ti-itcpfegem/billService',   'URL SUNAT producción', NOW()),
  (gen_random_uuid()::TEXT, 'sunat_usuario',        '',                   'Usuario SOL SUNAT',                 NOW()),
  (gen_random_uuid()::TEXT, 'sunat_clave_sol',      '',                   'Clave SOL SUNAT (encriptada)',      NOW()),
  (gen_random_uuid()::TEXT, 'sunat_cert_path',      '',                   'Ruta al certificado digital .pem',  NOW())
ON CONFLICT (key) DO NOTHING;

-- ============================================
-- 2. SERIES POR TIPO DE DOCUMENTO
-- ============================================
CREATE TABLE sunat_series (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  tipo_documento  VARCHAR(2) NOT NULL,
    -- '01' = Factura
    -- '03' = Boleta de venta
    -- '07' = Nota de crédito
    -- '08' = Nota de débito
  serie           VARCHAR(4) NOT NULL,
    -- F001 = Factura
    -- B001 = Boleta
    -- FC01 = Nota crédito factura
    -- BC01 = Nota crédito boleta
  correlativo     INT DEFAULT 1,
  is_active       BOOLEAN DEFAULT true,
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW(),
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

-- ============================================
-- 3. CAMPOS SUNAT EN INVOICES
-- ============================================
ALTER TABLE invoices
  -- Tipo de documento SUNAT
  ADD COLUMN IF NOT EXISTS sunat_tipo_doc     VARCHAR(2),
    -- '01' Factura, '03' Boleta

  -- Numeración oficial
  ADD COLUMN IF NOT EXISTS sunat_serie        VARCHAR(4),
    -- F001, B001
  ADD COLUMN IF NOT EXISTS sunat_correlativo  INT,
    -- número correlativo

  -- Datos del receptor (cliente)
  ADD COLUMN IF NOT EXISTS receptor_tipo_doc  VARCHAR(2),
    -- '1'=DNI, '6'=RUC, '7'=Pasaporte, 'A'=Carnet extranjería
  ADD COLUMN IF NOT EXISTS receptor_num_doc   VARCHAR(20),
    -- número de DNI, RUC o pasaporte
  ADD COLUMN IF NOT EXISTS receptor_razon_social VARCHAR(200),
    -- nombre o razón social del cliente
  ADD COLUMN IF NOT EXISTS receptor_direccion TEXT,
    -- dirección del cliente

  -- XML y respuesta SUNAT
  ADD COLUMN IF NOT EXISTS sunat_xml          TEXT,
    -- XML UBL 2.1 generado
  ADD COLUMN IF NOT EXISTS sunat_xml_firmado  TEXT,
    -- XML con firma digital
  ADD COLUMN IF NOT EXISTS sunat_hash         VARCHAR(200),
    -- hash del comprobante
  ADD COLUMN IF NOT EXISTS sunat_cdr          TEXT,
    -- respuesta CDR de SUNAT (ZIP en base64)
  ADD COLUMN IF NOT EXISTS sunat_cdr_codigo   VARCHAR(10),
    -- código de respuesta SUNAT
  ADD COLUMN IF NOT EXISTS sunat_cdr_descripcion TEXT,
    -- descripción de respuesta SUNAT
  ADD COLUMN IF NOT EXISTS sunat_status       VARCHAR(20) DEFAULT 'pendiente'
    CHECK (sunat_status IN (
      'pendiente',    -- aún no enviado
      'generado',     -- XML generado, no enviado
      'enviado',      -- enviado a SUNAT
      'aceptado',     -- aceptado por SUNAT
      'rechazado',    -- rechazado por SUNAT
      'observado',    -- aceptado con observaciones
      'anulado'       -- anulado via comunicación de baja
    )),

  -- Fechas clave
  ADD COLUMN IF NOT EXISTS sunat_enviado_at   TIMESTAMP,
  ADD COLUMN IF NOT EXISTS sunat_aceptado_at  TIMESTAMP,

  -- PDF del comprobante
  ADD COLUMN IF NOT EXISTS sunat_pdf_url      TEXT;

-- ============================================
-- 4. NOTAS DE CRÉDITO Y DÉBITO
-- ============================================
CREATE TABLE sunat_notas (
  id                  TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  invoice_id          TEXT REFERENCES invoices(id),
  tipo                VARCHAR(2) NOT NULL,
    -- '07' nota crédito, '08' nota débito
  serie               VARCHAR(4) NOT NULL,
  correlativo         INT NOT NULL,
  motivo_codigo       VARCHAR(2) NOT NULL,
    -- '01'=anulación, '02'=error RUC, '03'=corrección descripción
    -- '04'=descuento global, '05'=descuento por item
    -- '06'=devolución total, '07'=devolución por item
  motivo_descripcion  TEXT NOT NULL,
  monto               DECIMAL(10,2) NOT NULL,
  sunat_xml           TEXT,
  sunat_xml_firmado   TEXT,
  sunat_hash          VARCHAR(200),
  sunat_cdr           TEXT,
  sunat_cdr_codigo    VARCHAR(10),
  sunat_status        VARCHAR(20) DEFAULT 'pendiente'
                      CHECK (sunat_status IN (
                        'pendiente', 'generado', 'enviado',
                        'aceptado', 'rechazado', 'observado'
                      )),
  sunat_enviado_at    TIMESTAMP,
  sunat_aceptado_at   TIMESTAMP,
  created_by          TEXT REFERENCES admin_users(id),
  created_at          TIMESTAMP DEFAULT NOW(),
  updated_at          TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sunat_notas_invoice ON sunat_notas(invoice_id);
CREATE INDEX idx_sunat_notas_status  ON sunat_notas(sunat_status);

CREATE TRIGGER trg_sunat_notas
  BEFORE UPDATE ON sunat_notas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 5. COMUNICACIÓN DE BAJA (anulaciones SUNAT)
-- ============================================
CREATE TABLE sunat_bajas (
  id              TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  invoice_id      TEXT REFERENCES invoices(id),
  serie           VARCHAR(4) NOT NULL,
  correlativo     INT NOT NULL,
  tipo_doc        VARCHAR(2) NOT NULL,
  fecha_emision   DATE NOT NULL,
  motivo          TEXT NOT NULL,
  ticket_sunat    VARCHAR(50),
    -- ticket de la comunicación de baja
  sunat_xml       TEXT,
  sunat_cdr       TEXT,
  sunat_status    VARCHAR(20) DEFAULT 'pendiente'
                  CHECK (sunat_status IN (
                    'pendiente', 'enviado',
                    'aceptado', 'rechazado'
                  )),
  created_by      TEXT REFERENCES admin_users(id),
  created_at      TIMESTAMP DEFAULT NOW(),
  updated_at      TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sunat_bajas_invoice ON sunat_bajas(invoice_id);

CREATE TRIGGER trg_sunat_bajas
  BEFORE UPDATE ON sunat_bajas
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- 6. LOG DE ENVÍOS A SUNAT
-- ============================================
CREATE TABLE sunat_logs (
  id            TEXT PRIMARY KEY DEFAULT gen_random_uuid()::TEXT,
  invoice_id    TEXT REFERENCES invoices(id),
  accion        VARCHAR(50),
    -- 'generar_xml', 'firmar', 'enviar', 'consultar'
  request_xml   TEXT,
  response_xml  TEXT,
  exitoso       BOOLEAN DEFAULT false,
  error_mensaje TEXT,
  created_at    TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sunat_logs_invoice ON sunat_logs(invoice_id);
CREATE INDEX idx_sunat_logs_exitoso ON sunat_logs(exitoso);