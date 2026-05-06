// ============================================
// ENTIDAD — AdminUser
// Representa el concepto puro de un usuario admin
// SIN dependencias de Prisma, NestJS o BD
// Es el corazón del dominio
// ============================================
export class AdminUser {
  constructor(
    public readonly id: string,
    public readonly name: string,
    public readonly email: string,
    public readonly passwordHash: string,
    public readonly role: string,
    public readonly isActive: boolean,
    public readonly avatarUrl?: string | null,
    public readonly lastLoginAt?: Date | null,
    public readonly createdAt?: Date,
    public readonly updatedAt?: Date,
  ) {}

  // ============================================
  // Verifica si el usuario está activo
  // ============================================
  isEnabled(): boolean {
    return this.isActive;
  }

  // ============================================
  // Verifica si el usuario tiene un rol específico
  // ============================================
  hasRole(role: string): boolean {
    return this.role === role;
  }

  // ============================================
  // Retorna datos seguros (sin passwordHash)
  // ============================================
  toPublic() {
    return {
      id: this.id,
      name: this.name,
      email: this.email,
      role: this.role,
      isActive: this.isActive,
      avatarUrl: this.avatarUrl,
      lastLoginAt: this.lastLoginAt,
      createdAt: this.createdAt,
    };
  }
}
