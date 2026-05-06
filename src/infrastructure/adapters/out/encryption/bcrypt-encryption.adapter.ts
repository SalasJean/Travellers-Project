// ============================================
// ADAPTADOR DE SALIDA — Encriptación con bcrypt
// Implementa EncryptionServicePort
// Si mañana cambiamos a argon2 — solo cambiamos este archivo
// ============================================
import { Injectable } from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import type { EncryptionServicePort } from '../../../../domain/ports/out/encryption-service.port';

@Injectable()
export class BcryptEncryptionAdapter implements EncryptionServicePort {
  // Encripta un texto plano
  async hash(plain: string): Promise<string> {
    return bcrypt.hash(plain, 10);
  }

  // Compara texto plano con hash
  async compare(plain: string, hash: string): Promise<boolean> {
    return bcrypt.compare(plain, hash);
  }
}
