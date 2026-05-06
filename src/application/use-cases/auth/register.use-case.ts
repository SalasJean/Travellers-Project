//mediante la arquitectura hexagonal que es lo que va generalmente en la capa de la aplicacion? en la capa de la aplicacion van los casos de uso, es decir, las acciones que el sistema puede realizar. En este caso, el caso de uso de registro se encarga de manejar la lógica para registrar un nuevo usuario administrador. Esto incluye validar los datos de entrada, verificar si el email ya está registrado, crear el nuevo usuario en la base de datos y retornar los datos del usuario creado. Es importante que esta capa no tenga dependencias directas con la base de datos o con frameworks específicos, para mantener la independencia del dominio y facilitar el mantenimiento y la escalabilidad del sistema. RECUERDA SI?
// ============================================
// USE CASE — Register
// Lógica pura de negocio para registrar un admin
// No sabe nada de HTTP ni de Prisma
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { RegisterUseCasePort } from '../../../domain/ports/in/register-use-case.port';
import type { AdminUserRepositoryPort } from '../../../domain/ports/out/admin-user-repository.port';
import type { EncryptionServicePort } from '../../../domain/ports/out/encryption-service.port';
import type { TokenServicePort } from '../../../domain/ports/out/token-service.port';
import {
  ADMIN_USER_REPOSITORY,
  ENCRYPTION_SERVICE,
  TOKEN_SERVICE,
} from '../../../domain/tokens';
import { UserAlreadyExistsException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class RegisterUseCase implements RegisterUseCasePort {
  constructor(
    @Inject(ADMIN_USER_REPOSITORY)
    private adminUserRepository: AdminUserRepositoryPort,

    @Inject(ENCRYPTION_SERVICE)
    private encryptionService: EncryptionServicePort,

    @Inject(TOKEN_SERVICE)
    private tokenService: TokenServicePort,
  ) {}

  async execute(data: { name: string; email: string; password: string }) {
    // 1️⃣ Verificar si existe
    const exists = await this.adminUserRepository.findByEmail(data.email);
    if (exists) throw new UserAlreadyExistsException();

    // 2️⃣ Encriptar via puerto
    const passwordHash = await this.encryptionService.hash(data.password);

    // 3️⃣ Crear usuario
    const user = await this.adminUserRepository.create({
      name: data.name,
      email: data.email,
      passwordHash: passwordHash,
      role: 'editor',
    });

    // 4️⃣ Generar token via puerto
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
