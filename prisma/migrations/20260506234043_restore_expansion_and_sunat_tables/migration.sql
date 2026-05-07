-- CreateEnum
CREATE TYPE "DiscountType" AS ENUM ('percent', 'fixed');

-- CreateEnum
CREATE TYPE "CommissionType" AS ENUM ('percent', 'fixed');

-- CreateEnum
CREATE TYPE "SubscriberSource" AS ENUM ('website', 'popup', 'booking', 'blog', 'social', 'other');

-- CreateEnum
CREATE TYPE "CampaignTarget" AS ENUM ('all', 'vip', 'inactive', 'custom');

-- CreateEnum
CREATE TYPE "CampaignStatus" AS ENUM ('draft', 'scheduled', 'sent', 'canceled');

-- CreateEnum
CREATE TYPE "PackageStatus" AS ENUM ('draft', 'published', 'featured', 'hidden');

-- CreateEnum
CREATE TYPE "InsuranceStatus" AS ENUM ('active', 'canceled', 'claimed');

-- CreateEnum
CREATE TYPE "SunatNotaStatus" AS ENUM ('pendiente', 'generado', 'enviado', 'aceptado', 'rechazado', 'observado');

-- CreateEnum
CREATE TYPE "SunatBajaStatus" AS ENUM ('pendiente', 'enviado', 'aceptado', 'rechazado');

-- AlterTable
ALTER TABLE "bookings" ADD COLUMN     "affiliate_id" TEXT,
ADD COLUMN     "commission_amount" DECIMAL(10,2) NOT NULL DEFAULT 0,
ADD COLUMN     "guide_id" TEXT,
ADD COLUMN     "insurance_amount" DECIMAL(10,2) NOT NULL DEFAULT 0,
ADD COLUMN     "package_id" TEXT,
ADD COLUMN     "promo_code" VARCHAR(50),
ADD COLUMN     "promo_code_id" TEXT,
ADD COLUMN     "referral_code" VARCHAR(50);

-- AlterTable
ALTER TABLE "invoices" ADD COLUMN     "document_type" VARCHAR(20) NOT NULL DEFAULT 'boleta',
ADD COLUMN     "ruc" VARCHAR(11);

-- CreateTable
CREATE TABLE "guides" (
    "id" TEXT NOT NULL,
    "full_name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(150),
    "phone" VARCHAR(30),
    "whatsapp" VARCHAR(30),
    "photo_url" TEXT,
    "bio" TEXT,
    "languages" TEXT[],
    "specialties" TEXT[],
    "license_number" VARCHAR(100),
    "rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "total_tours" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "guides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_availability_guides" (
    "id" TEXT NOT NULL,
    "availability_id" TEXT NOT NULL,
    "guide_id" TEXT NOT NULL,
    "assigned_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tour_availability_guides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promo_codes" (
    "id" TEXT NOT NULL,
    "code" VARCHAR(50) NOT NULL,
    "description" VARCHAR(200),
    "discount_type" "DiscountType" NOT NULL,
    "discount_value" DECIMAL(10,2) NOT NULL,
    "min_amount" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "max_uses" INTEGER,
    "uses_count" INTEGER NOT NULL DEFAULT 0,
    "valid_from" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "valid_until" TIMESTAMP(3),
    "applicable_tours" TEXT[],
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "promo_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "packages" (
    "id" TEXT NOT NULL,
    "slug" VARCHAR(200) NOT NULL,
    "thumbnail_url" TEXT,
    "duration_days" INTEGER,
    "original_price" DECIMAL(10,2),
    "package_price" DECIMAL(10,2),
    "savings_percent" DECIMAL(5,2),
    "min_travelers" INTEGER NOT NULL DEFAULT 1,
    "max_travelers" INTEGER NOT NULL DEFAULT 15,
    "includes" TEXT[],
    "not_includes" TEXT[],
    "status" "PackageStatus" NOT NULL DEFAULT 'draft',
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "package_tours" (
    "id" TEXT NOT NULL,
    "package_id" TEXT NOT NULL,
    "tour_id" TEXT NOT NULL,
    "day_number" INTEGER,
    "sort_order" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "package_tours_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "affiliates" (
    "id" TEXT NOT NULL,
    "full_name" VARCHAR(150) NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "phone" VARCHAR(30),
    "referral_code" VARCHAR(50) NOT NULL,
    "commission_type" "CommissionType" NOT NULL DEFAULT 'percent',
    "commission_value" DECIMAL(10,2) NOT NULL DEFAULT 10.00,
    "total_referrals" INTEGER NOT NULL DEFAULT 0,
    "total_earned" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "total_paid" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "pending_payment" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "payment_method" VARCHAR(50),
    "payment_details" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "joined_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "affiliates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "affiliate_payments" (
    "id" TEXT NOT NULL,
    "affiliate_id" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "method" VARCHAR(50),
    "reference" VARCHAR(200),
    "notes" TEXT,
    "paid_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "affiliate_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscribers" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(150) NOT NULL,
    "full_name" VARCHAR(150),
    "language" VARCHAR(10) NOT NULL DEFAULT 'es',
    "interests" TEXT[],
    "source" "SubscriberSource",
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "confirmed" BOOLEAN NOT NULL DEFAULT false,
    "confirm_token" VARCHAR(200),
    "subscribed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unsubscribed_at" TIMESTAMP(3),

    CONSTRAINT "subscribers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_campaigns" (
    "id" TEXT NOT NULL,
    "subject" VARCHAR(300) NOT NULL,
    "content" TEXT NOT NULL,
    "target" "CampaignTarget" NOT NULL DEFAULT 'all',
    "status" "CampaignStatus" NOT NULL DEFAULT 'draft',
    "scheduled_at" TIMESTAMP(3),
    "sent_at" TIMESTAMP(3),
    "recipients" INTEGER NOT NULL DEFAULT 0,
    "opens" INTEGER NOT NULL DEFAULT 0,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "email_campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wishlists" (
    "id" TEXT NOT NULL,
    "client_id" TEXT NOT NULL,
    "tour_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "wishlists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "insurance_plans" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "price_per_pax" DECIMAL(10,2) NOT NULL,
    "coverage" TEXT[],
    "max_coverage" DECIMAL(10,2),
    "provider" VARCHAR(150),
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "insurance_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "booking_insurance" (
    "id" TEXT NOT NULL,
    "booking_id" TEXT NOT NULL,
    "plan_id" TEXT,
    "travelers" INTEGER NOT NULL,
    "price_per_pax" DECIMAL(10,2) NOT NULL,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "policy_number" VARCHAR(100),
    "status" "InsuranceStatus" NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "booking_insurance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_translations" (
    "id" TEXT NOT NULL,
    "tour_id" TEXT NOT NULL,
    "language" VARCHAR(10) NOT NULL,
    "name" VARCHAR(200),
    "short_description" TEXT,
    "full_description" TEXT,
    "includes" TEXT[],
    "not_includes" TEXT[],
    "what_to_bring" TEXT[],
    "meeting_point" TEXT,
    "meta_title" VARCHAR(200),
    "meta_description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tour_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "package_translations" (
    "id" TEXT NOT NULL,
    "package_id" TEXT NOT NULL,
    "language" VARCHAR(10) NOT NULL,
    "name" VARCHAR(200),
    "description" TEXT,
    "includes" TEXT[],
    "not_includes" TEXT[],
    "meta_title" VARCHAR(200),
    "meta_description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "package_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blog_translations" (
    "id" TEXT NOT NULL,
    "article_id" TEXT NOT NULL,
    "language" VARCHAR(10) NOT NULL,
    "title" VARCHAR(300),
    "excerpt" TEXT,
    "content" TEXT,
    "meta_title" VARCHAR(200),
    "meta_description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "blog_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sunat_notas" (
    "id" TEXT NOT NULL,
    "invoice_id" TEXT,
    "tipo" VARCHAR(2) NOT NULL,
    "serie" VARCHAR(4) NOT NULL,
    "correlativo" INTEGER NOT NULL,
    "motivo_codigo" VARCHAR(2) NOT NULL,
    "motivo_descripcion" TEXT NOT NULL,
    "monto" DECIMAL(10,2) NOT NULL,
    "sunat_xml" TEXT,
    "sunat_xml_firmado" TEXT,
    "sunat_hash" VARCHAR(200),
    "sunat_cdr" TEXT,
    "sunat_cdr_codigo" VARCHAR(10),
    "sunat_status" "SunatNotaStatus" NOT NULL DEFAULT 'pendiente',
    "sunat_enviado_at" TIMESTAMP(3),
    "sunat_aceptado_at" TIMESTAMP(3),
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sunat_notas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sunat_bajas" (
    "id" TEXT NOT NULL,
    "invoice_id" TEXT,
    "serie" VARCHAR(4) NOT NULL,
    "correlativo" INTEGER NOT NULL,
    "tipo_doc" VARCHAR(2) NOT NULL,
    "fecha_emision" DATE NOT NULL,
    "motivo" TEXT NOT NULL,
    "ticket_sunat" VARCHAR(50),
    "sunat_xml" TEXT,
    "sunat_cdr" TEXT,
    "sunat_status" "SunatBajaStatus" NOT NULL DEFAULT 'pendiente',
    "created_by" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sunat_bajas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sunat_logs" (
    "id" TEXT NOT NULL,
    "invoice_id" TEXT,
    "accion" VARCHAR(50),
    "request_xml" TEXT,
    "response_xml" TEXT,
    "exitoso" BOOLEAN NOT NULL DEFAULT false,
    "error_mensaje" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sunat_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sunat_series" (
    "id" TEXT NOT NULL DEFAULT (gen_random_uuid())::text,
    "tipo_documento" VARCHAR(2) NOT NULL,
    "serie" VARCHAR(4) NOT NULL,
    "correlativo" INTEGER DEFAULT 1,
    "is_active" BOOLEAN DEFAULT true,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sunat_series_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "guides_email_key" ON "guides"("email");

-- CreateIndex
CREATE INDEX "guides_is_active_idx" ON "guides"("is_active");

-- CreateIndex
CREATE UNIQUE INDEX "tour_availability_guides_availability_id_guide_id_key" ON "tour_availability_guides"("availability_id", "guide_id");

-- CreateIndex
CREATE UNIQUE INDEX "promo_codes_code_key" ON "promo_codes"("code");

-- CreateIndex
CREATE INDEX "promo_codes_code_idx" ON "promo_codes"("code");

-- CreateIndex
CREATE UNIQUE INDEX "packages_slug_key" ON "packages"("slug");

-- CreateIndex
CREATE INDEX "packages_slug_idx" ON "packages"("slug");

-- CreateIndex
CREATE INDEX "packages_status_idx" ON "packages"("status");

-- CreateIndex
CREATE UNIQUE INDEX "package_tours_package_id_tour_id_key" ON "package_tours"("package_id", "tour_id");

-- CreateIndex
CREATE UNIQUE INDEX "affiliates_email_key" ON "affiliates"("email");

-- CreateIndex
CREATE UNIQUE INDEX "affiliates_referral_code_key" ON "affiliates"("referral_code");

-- CreateIndex
CREATE INDEX "affiliates_referral_code_idx" ON "affiliates"("referral_code");

-- CreateIndex
CREATE UNIQUE INDEX "subscribers_email_key" ON "subscribers"("email");

-- CreateIndex
CREATE INDEX "subscribers_email_idx" ON "subscribers"("email");

-- CreateIndex
CREATE INDEX "subscribers_is_active_idx" ON "subscribers"("is_active");

-- CreateIndex
CREATE INDEX "wishlists_client_id_idx" ON "wishlists"("client_id");

-- CreateIndex
CREATE INDEX "wishlists_tour_id_idx" ON "wishlists"("tour_id");

-- CreateIndex
CREATE UNIQUE INDEX "wishlists_client_id_tour_id_key" ON "wishlists"("client_id", "tour_id");

-- CreateIndex
CREATE INDEX "booking_insurance_booking_id_idx" ON "booking_insurance"("booking_id");

-- CreateIndex
CREATE UNIQUE INDEX "booking_insurance_booking_id_key" ON "booking_insurance"("booking_id");

-- CreateIndex
CREATE INDEX "tour_translations_tour_id_language_idx" ON "tour_translations"("tour_id", "language");

-- CreateIndex
CREATE UNIQUE INDEX "tour_translations_tour_id_language_key" ON "tour_translations"("tour_id", "language");

-- CreateIndex
CREATE INDEX "package_translations_package_id_language_idx" ON "package_translations"("package_id", "language");

-- CreateIndex
CREATE UNIQUE INDEX "package_translations_package_id_language_key" ON "package_translations"("package_id", "language");

-- CreateIndex
CREATE INDEX "blog_translations_article_id_language_idx" ON "blog_translations"("article_id", "language");

-- CreateIndex
CREATE UNIQUE INDEX "blog_translations_article_id_language_key" ON "blog_translations"("article_id", "language");

-- CreateIndex
CREATE INDEX "sunat_notas_invoice_id_idx" ON "sunat_notas"("invoice_id");

-- CreateIndex
CREATE INDEX "sunat_notas_sunat_status_idx" ON "sunat_notas"("sunat_status");

-- CreateIndex
CREATE INDEX "sunat_bajas_invoice_id_idx" ON "sunat_bajas"("invoice_id");

-- CreateIndex
CREATE INDEX "sunat_logs_invoice_id_idx" ON "sunat_logs"("invoice_id");

-- CreateIndex
CREATE INDEX "sunat_logs_exitoso_idx" ON "sunat_logs"("exitoso");

-- CreateIndex
CREATE UNIQUE INDEX "sunat_series_tipo_documento_serie_key" ON "sunat_series"("tipo_documento", "serie");

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_promo_code_id_fkey" FOREIGN KEY ("promo_code_id") REFERENCES "promo_codes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_guide_id_fkey" FOREIGN KEY ("guide_id") REFERENCES "guides"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bookings" ADD CONSTRAINT "bookings_affiliate_id_fkey" FOREIGN KEY ("affiliate_id") REFERENCES "affiliates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_availability_guides" ADD CONSTRAINT "tour_availability_guides_availability_id_fkey" FOREIGN KEY ("availability_id") REFERENCES "tour_availability"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_availability_guides" ADD CONSTRAINT "tour_availability_guides_guide_id_fkey" FOREIGN KEY ("guide_id") REFERENCES "guides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "promo_codes" ADD CONSTRAINT "promo_codes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "packages" ADD CONSTRAINT "packages_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_tours" ADD CONSTRAINT "package_tours_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_tours" ADD CONSTRAINT "package_tours_tour_id_fkey" FOREIGN KEY ("tour_id") REFERENCES "tours"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "affiliate_payments" ADD CONSTRAINT "affiliate_payments_affiliate_id_fkey" FOREIGN KEY ("affiliate_id") REFERENCES "affiliates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_campaigns" ADD CONSTRAINT "email_campaigns_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wishlists" ADD CONSTRAINT "wishlists_client_id_fkey" FOREIGN KEY ("client_id") REFERENCES "clients"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wishlists" ADD CONSTRAINT "wishlists_tour_id_fkey" FOREIGN KEY ("tour_id") REFERENCES "tours"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_insurance" ADD CONSTRAINT "booking_insurance_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "bookings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking_insurance" ADD CONSTRAINT "booking_insurance_plan_id_fkey" FOREIGN KEY ("plan_id") REFERENCES "insurance_plans"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_translations" ADD CONSTRAINT "tour_translations_tour_id_fkey" FOREIGN KEY ("tour_id") REFERENCES "tours"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "package_translations" ADD CONSTRAINT "package_translations_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blog_translations" ADD CONSTRAINT "blog_translations_article_id_fkey" FOREIGN KEY ("article_id") REFERENCES "blog_articles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunat_notas" ADD CONSTRAINT "sunat_notas_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunat_notas" ADD CONSTRAINT "sunat_notas_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunat_bajas" ADD CONSTRAINT "sunat_bajas_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunat_bajas" ADD CONSTRAINT "sunat_bajas_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "admin_users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sunat_logs" ADD CONSTRAINT "sunat_logs_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoices"("id") ON DELETE SET NULL ON UPDATE CASCADE;
