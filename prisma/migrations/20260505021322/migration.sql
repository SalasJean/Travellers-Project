/*
  Warnings:

  - You are about to drop the column `affiliate_id` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `commission_amount` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `guide_id` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `insurance_amount` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `package_id` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `promo_code` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `promo_code_id` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `referral_code` on the `bookings` table. All the data in the column will be lost.
  - You are about to drop the column `document_type` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `ruc` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the `affiliate_payments` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `affiliates` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `blog_translations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `booking_insurance` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `email_campaigns` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `guides` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `insurance_plans` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `package_tours` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `package_translations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `packages` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `promo_codes` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `subscribers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tour_availability_guides` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tour_translations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `wishlists` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "affiliate_payments" DROP CONSTRAINT "affiliate_payments_affiliate_id_fkey";

-- DropForeignKey
ALTER TABLE "blog_translations" DROP CONSTRAINT "blog_translations_article_id_fkey";

-- DropForeignKey
ALTER TABLE "booking_insurance" DROP CONSTRAINT "booking_insurance_booking_id_fkey";

-- DropForeignKey
ALTER TABLE "booking_insurance" DROP CONSTRAINT "booking_insurance_plan_id_fkey";

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_affiliate_id_fkey";

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_guide_id_fkey";

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_package_id_fkey";

-- DropForeignKey
ALTER TABLE "bookings" DROP CONSTRAINT "bookings_promo_code_id_fkey";

-- DropForeignKey
ALTER TABLE "email_campaigns" DROP CONSTRAINT "email_campaigns_created_by_fkey";

-- DropForeignKey
ALTER TABLE "package_tours" DROP CONSTRAINT "package_tours_package_id_fkey";

-- DropForeignKey
ALTER TABLE "package_tours" DROP CONSTRAINT "package_tours_tour_id_fkey";

-- DropForeignKey
ALTER TABLE "package_translations" DROP CONSTRAINT "package_translations_package_id_fkey";

-- DropForeignKey
ALTER TABLE "packages" DROP CONSTRAINT "packages_created_by_fkey";

-- DropForeignKey
ALTER TABLE "promo_codes" DROP CONSTRAINT "promo_codes_created_by_fkey";

-- DropForeignKey
ALTER TABLE "tour_availability_guides" DROP CONSTRAINT "tour_availability_guides_availability_id_fkey";

-- DropForeignKey
ALTER TABLE "tour_availability_guides" DROP CONSTRAINT "tour_availability_guides_guide_id_fkey";

-- DropForeignKey
ALTER TABLE "tour_translations" DROP CONSTRAINT "tour_translations_tour_id_fkey";

-- DropForeignKey
ALTER TABLE "wishlists" DROP CONSTRAINT "wishlists_client_id_fkey";

-- DropForeignKey
ALTER TABLE "wishlists" DROP CONSTRAINT "wishlists_tour_id_fkey";

-- AlterTable
ALTER TABLE "bookings" DROP COLUMN "affiliate_id",
DROP COLUMN "commission_amount",
DROP COLUMN "guide_id",
DROP COLUMN "insurance_amount",
DROP COLUMN "package_id",
DROP COLUMN "promo_code",
DROP COLUMN "promo_code_id",
DROP COLUMN "referral_code";

-- AlterTable
ALTER TABLE "invoices" DROP COLUMN "document_type",
DROP COLUMN "ruc";

-- DropTable
DROP TABLE "affiliate_payments";

-- DropTable
DROP TABLE "affiliates";

-- DropTable
DROP TABLE "blog_translations";

-- DropTable
DROP TABLE "booking_insurance";

-- DropTable
DROP TABLE "email_campaigns";

-- DropTable
DROP TABLE "guides";

-- DropTable
DROP TABLE "insurance_plans";

-- DropTable
DROP TABLE "package_tours";

-- DropTable
DROP TABLE "package_translations";

-- DropTable
DROP TABLE "packages";

-- DropTable
DROP TABLE "promo_codes";

-- DropTable
DROP TABLE "subscribers";

-- DropTable
DROP TABLE "tour_availability_guides";

-- DropTable
DROP TABLE "tour_translations";

-- DropTable
DROP TABLE "wishlists";
