// ============================================
// USE CASE — Me
// Obtiene los datos del usuario autenticado
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { MeUseCasePort } from '../../../domain/ports/in/me-use-case.port';
import type { AdminUserRepositoryPort } from '../../../domain/ports/out/admin-user-repository.port';
import { ADMIN_USER_REPOSITORY } from '../../../domain/tokens';
import { UserNotFoundException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class MeUseCase implements MeUseCasePort {
  constructor(
    @Inject(ADMIN_USER_REPOSITORY)
    private adminUserRepository: AdminUserRepositoryPort,
  ) {}

  async execute(userId: string) {
    const user = await this.adminUserRepository.findById(userId);
    if (!user) throw new UserNotFoundException();
    return user.toPublic();
  }
}
