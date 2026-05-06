-- This is an empty migration. recuerda que aqui van la logica para la base de datos siempre si?
-- En este caso, se pueden agregar triggers para actualizar el campo "updatedAt" automáticamente cada vez que se actualice un registro en la tabla "Travel".

-- ============================================
-- FIX EXISTING DATA: Set updated_at for existing rows in settings
-- ============================================
UPDATE settings SET updated_at = NOW() WHERE updated_at IS NULL;

-- ============================================
-- EXTENSIONES
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- ============================================
-- FUNCIÓN: actualizar updated_at automático
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger a todas las tablas con updated_at
CREATE TRIGGER trg_admin_users
  BEFORE UPDATE ON admin_users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_clients
  BEFORE UPDATE ON clients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_tours
  BEFORE UPDATE ON tours
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_bookings
  BEFORE UPDATE ON bookings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_invoices
  BEFORE UPDATE ON invoices
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_reviews
  BEFORE UPDATE ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_blog
  BEFORE UPDATE ON blog_articles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trg_chat
  BEFORE UPDATE ON chat_conversations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================
-- SECUENCIA Y FUNCIÓN: número de reserva
-- Formato: NA-2026-00001
-- ============================================
CREATE SEQUENCE IF NOT EXISTS booking_seq START 1;

CREATE OR REPLACE FUNCTION generate_booking_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.booking_number = 'NA-' ||
    TO_CHAR(NOW(), 'YYYY') || '-' ||
    LPAD(nextval('booking_seq')::TEXT, 5, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_booking_number
  BEFORE INSERT ON bookings
  FOR EACH ROW EXECUTE FUNCTION generate_booking_number();

-- ============================================
-- SECUENCIA Y FUNCIÓN: número de factura
-- Formato: FAC-2026-00001
-- ============================================
CREATE SEQUENCE IF NOT EXISTS invoice_seq START 1;

CREATE OR REPLACE FUNCTION generate_invoice_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.invoice_number = 'FAC-' ||
    TO_CHAR(NOW(), 'YYYY') || '-' ||
    LPAD(nextval('invoice_seq')::TEXT, 5, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_invoice_number
  BEFORE INSERT ON invoices
  FOR EACH ROW EXECUTE FUNCTION generate_invoice_number();

-- ============================================
-- FUNCIÓN: actualizar stats del cliente
-- al completar una reserva
-- ============================================
CREATE OR REPLACE FUNCTION update_client_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
    UPDATE clients SET
      total_bookings = total_bookings + 1,
      total_spent    = total_spent + NEW.total_amount,
      is_vip         = CASE
                         WHEN total_bookings + 1 >= 3
                           OR total_spent + NEW.total_amount >= 500
                         THEN true
                         ELSE is_vip
                       END,
      status         = CASE
                         WHEN total_bookings + 1 >= 3
                           OR total_spent + NEW.total_amount >= 500
                         THEN 'vip'
                         ELSE status
                       END
    WHERE id = NEW.client_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_client_stats
  AFTER UPDATE ON bookings
  FOR EACH ROW EXECUTE FUNCTION update_client_stats();

-- ============================================
-- DATOS INICIALES: Settings
-- ============================================
INSERT INTO settings (id, key, value, description, updated_at) VALUES
  (gen_random_uuid(), 'agency_name',      'NeonAndes Tours',              'Nombre de la agencia',       NOW()),
  (gen_random_uuid(), 'agency_email',     'info@neonandestourscom',       'Email de contacto',          NOW()),
  (gen_random_uuid(), 'agency_phone',     '+51 984 000 000',              'Teléfono principal',         NOW()),
  (gen_random_uuid(), 'agency_whatsapp',  '+51 984 000 000',              'WhatsApp de ventas',         NOW()),
  (gen_random_uuid(), 'agency_address',   'Cusco, Perú',                  'Dirección física',           NOW()),
  (gen_random_uuid(), 'agency_instagram', '@neonandestourscom',           'Instagram',                  NOW()),
  (gen_random_uuid(), 'agency_facebook',  'neonandestourscom',            'Facebook',                   NOW()),
  (gen_random_uuid(), 'igv_percent',      '18',                           'IGV Perú (%)',               NOW()),
  (gen_random_uuid(), 'deposit_percent',  '30',                           'Depósito mínimo (%)',        NOW()),
  (gen_random_uuid(), 'culqi_public_key', '',                             'Culqi public key',           NOW()),
  (gen_random_uuid(), 'paypal_email',     '',                             'PayPal email',               NOW()),
  (gen_random_uuid(), 'ga_tracking_id',   '',                             'Google Analytics ID',        NOW()),
  (gen_random_uuid(), 'fb_pixel_id',      '',                             'Facebook Pixel ID',          NOW()),
  (gen_random_uuid(), 'ai_provider',      'deepseek',                     'Proveedor IA del chat',      NOW()),
  (gen_random_uuid(), 'ai_model',         'deepseek-chat',                'Modelo IA del chat',         NOW()),
  (gen_random_uuid(), 'ai_chat_enabled',  'true',                         'Chat IA activo/inactivo',    NOW()),
  (gen_random_uuid(), 'ai_greeting',      '¡Hola viajero! Soy ANDES AI', 'Mensaje de bienvenida',      NOW())
ON CONFLICT (key) DO NOTHING;