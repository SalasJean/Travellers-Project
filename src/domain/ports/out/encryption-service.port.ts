// ============================================
// PUERTO DE SALIDA — Encryption Service
// Define QUÉ necesita el dominio para encriptar
// NO sabe si es bcrypt, argon2, etc
// ============================================
export interface EncryptionServicePort {
  hash(plain: string): Promise<string>;
  compare(plain: string, hash: string): Promise<boolean>;
}
