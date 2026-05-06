// ============================================
// ADAPTADOR DE SALIDA — AdminUser con Prisma
// Implementa el puerto AdminUserRepositoryPort
// Traduce entre el dominio y Prisma
// ============================================
import { Injectable } from '@nestjs/common';
import { AdminRole } from '@prisma/client';
import { PrismaService } from './prisma.service';
import type { AdminUserRepositoryPort } from '../../../../../domain/ports/out/admin-user-repository.port';
import type { AdminUser } from '../../../../../domain/entities/admin-user.entity';
import { AdminUserMapper } from './mappers/admin-user.mapper';

@Injectable()
export class PrismaAdminUserAdapter implements AdminUserRepositoryPort {
  constructor(private prisma: PrismaService) {}

  // ============================================
  // Buscar por email
  // ============================================
  async findByEmail(email: string): Promise<AdminUser | null> {
    const record = await this.prisma.adminUser.findUnique({
      where: { email },
    });
    return record ? AdminUserMapper.toDomain(record) : null;
  }

  // ============================================
  // Buscar por ID
  // ============================================
  async findById(id: string): Promise<AdminUser | null> {
    const record = await this.prisma.adminUser.findUnique({
      where: { id },
    });
    return record ? AdminUserMapper.toDomain(record) : null;
  }

  // ============================================
  // Crear usuario
  // ============================================
  async create(data: {
    name: string;
    email: string;
    passwordHash: string;
    role: string;
  }): Promise<AdminUser> {
    const record = await this.prisma.adminUser.create({
      data: {
        ...data,
        role: data.role as AdminRole,
      },
    });
    return AdminUserMapper.toDomain(record);
  }

  // ============================================
  // Actualizar último login
  // ============================================
  async updateLastLogin(id: string): Promise<void> {
    await this.prisma.adminUser.update({
      where: { id },
      data: { lastLoginAt: new Date() },
    });
  }
}
