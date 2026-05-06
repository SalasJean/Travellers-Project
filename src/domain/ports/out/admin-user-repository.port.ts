// ============================================
// PUERTO DE SALIDA — AdminUser Repository
// Define QUÉ necesita el dominio de la BD
// NO sabe si es Prisma, MongoDB, MySQL, etc
// ============================================
import type { AdminUser } from '../../entities/admin-user.entity';

export interface AdminUserRepositoryPort {
  findByEmail(email: string): Promise<AdminUser | null>;
  findById(id: string): Promise<AdminUser | null>;
  create(data: {
    name: string;
    email: string;
    passwordHash: string;
    role: string;
  }): Promise<AdminUser>;
  updateLastLogin(id: string): Promise<void>;
}
