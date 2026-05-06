/*
  Warnings:

  - You are about to drop the column `receptor_direccion` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `receptor_num_doc` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `receptor_razon_social` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `receptor_tipo_doc` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_aceptado_at` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_cdr` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_cdr_codigo` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_cdr_descripcion` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_correlativo` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_enviado_at` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_hash` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_pdf_url` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_serie` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_status` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_tipo_doc` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_xml` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the column `sunat_xml_firmado` on the `invoices` table. All the data in the column will be lost.
  - You are about to drop the `sunat_bajas` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sunat_logs` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sunat_notas` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sunat_series` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "sunat_bajas" DROP CONSTRAINT "sunat_bajas_created_by_fkey";

-- DropForeignKey
ALTER TABLE "sunat_bajas" DROP CONSTRAINT "sunat_bajas_invoice_id_fkey";

-- DropForeignKey
ALTER TABLE "sunat_logs" DROP CONSTRAINT "sunat_logs_invoice_id_fkey";

-- DropForeignKey
ALTER TABLE "sunat_notas" DROP CONSTRAINT "sunat_notas_created_by_fkey";

-- DropForeignKey
ALTER TABLE "sunat_notas" DROP CONSTRAINT "sunat_notas_invoice_id_fkey";

-- AlterTable
ALTER TABLE "invoices" DROP COLUMN "receptor_direccion",
DROP COLUMN "receptor_num_doc",
DROP COLUMN "receptor_razon_social",
DROP COLUMN "receptor_tipo_doc",
DROP COLUMN "sunat_aceptado_at",
DROP COLUMN "sunat_cdr",
DROP COLUMN "sunat_cdr_codigo",
DROP COLUMN "sunat_cdr_descripcion",
DROP COLUMN "sunat_correlativo",
DROP COLUMN "sunat_enviado_at",
DROP COLUMN "sunat_hash",
DROP COLUMN "sunat_pdf_url",
DROP COLUMN "sunat_serie",
DROP COLUMN "sunat_status",
DROP COLUMN "sunat_tipo_doc",
DROP COLUMN "sunat_xml",
DROP COLUMN "sunat_xml_firmado";

-- DropTable
DROP TABLE "sunat_bajas";

-- DropTable
DROP TABLE "sunat_logs";

-- DropTable
DROP TABLE "sunat_notas";

-- DropTable
DROP TABLE "sunat_series";
