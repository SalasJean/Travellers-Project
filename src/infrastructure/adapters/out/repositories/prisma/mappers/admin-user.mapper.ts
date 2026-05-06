// ============================================
// MAPPER — AdminUser
// Convierte registros de Prisma → Entidad del dominio
// El dominio nunca conoce el formato de Prisma
// ============================================
import { AdminUser } from '../../../../../../domain/entities/admin-user.entity';

export class AdminUserMapper {
  // Prisma record → Entidad del dominio
  static toDomain(record: any): AdminUser {
    return new AdminUser(
      record.id,
      record.name,
      record.email,
      record.passwordHash,
      record.role,
      record.isActive,
      record.avatarUrl,
      record.lastLoginAt,
      record.createdAt,
      record.updatedAt,
    );
  }
}
