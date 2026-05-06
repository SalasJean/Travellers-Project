// ============================================
// USE CASE — Login
// Lógica pura de negocio para autenticar un admin
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { LoginUseCasePort } from '../../../domain/ports/in/login-use-case.port';
import type { AdminUserRepositoryPort } from '../../../domain/ports/out/admin-user-repository.port';
import type { EncryptionServicePort } from '../../../domain/ports/out/encryption-service.port';
import type { TokenServicePort } from '../../../domain/ports/out/token-service.port';
import {
  ADMIN_USER_REPOSITORY,
  ENCRYPTION_SERVICE,
  TOKEN_SERVICE,
} from '../../../domain/tokens';
import {
  InvalidCredentialsException,
  UserInactiveException,
} from '../../../domain/exceptions/domain.exception';

@Injectable()
export class LoginUseCase implements LoginUseCasePort {
  constructor(
    @Inject(ADMIN_USER_REPOSITORY)
    private adminUserRepository: AdminUserRepositoryPort,

    @Inject(ENCRYPTION_SERVICE)
    private encryptionService: EncryptionServicePort,

    @Inject(TOKEN_SERVICE)
    private tokenService: TokenServicePort,
  ) {}

  async execute(data: { email: string; password: string }) {
    // 1️⃣ Buscar usuario
    const user = await this.adminUserRepository.findByEmail(data.email);
    if (!user) throw new InvalidCredentialsException();

    // 2️⃣ Verificar si está activo
    if (!user.isEnabled()) throw new UserInactiveException();

    // 3️⃣ Verificar password via puerto de encriptación
    const isValid = await this.encryptionService.compare(
      data.password,
      user.passwordHash,
    );
    if (!isValid) throw new InvalidCredentialsException();

    // 4️⃣ Actualizar último login
    await this.adminUserRepository.updateLastLogin(user.id);

    // 5️⃣ Generar token via puerto
    return {
      access_token: this.tokenService.sign({
        sub: user.id,
        email: user.email,
        role: user.role,
      }),
      user: user.toPublic(),
    };
  }
}
