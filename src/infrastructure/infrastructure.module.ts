// ============================================
// INFRASTRUCTURE MODULE
// Ensambla todos los adaptadores
// Vincula puertos con implementaciones
// ============================================
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

// Adaptadores IN
import { AuthController } from './adapters/in/controllers/auth.controller';

// Adaptadores OUT
import { PrismaService } from './adapters/out/repositories/prisma/prisma.service';
import { PrismaAdminUserAdapter } from './adapters/out/repositories/prisma/prisma-admin-user.adapter';
import { BcryptEncryptionAdapter } from './adapters/out/encryption/bcrypt-encryption.adapter';
import { JwtTokenAdapter } from './adapters/out/auth/jwt-token.adapter';

// Guards y Strategy
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { JwtStrategy } from './strategies/jwt.strategy';

// Use Cases
import { LoginUseCase } from '../application/use-cases/auth/login.use-case';
import { RegisterUseCase } from '../application/use-cases/auth/register.use-case';
import { MeUseCase } from '../application/use-cases/auth/me.use-case';

// Tokens
import {
  LOGIN_USE_CASE,
  REGISTER_USE_CASE,
  ME_USE_CASE,
  ADMIN_USER_REPOSITORY,
  ENCRYPTION_SERVICE,
  TOKEN_SERVICE,
} from '../domain/tokens';

@Module({
  imports: [
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'secret_dev',
      signOptions: { expiresIn: '7d' },
    }),
  ],
  controllers: [AuthController],
  providers: [
    // Infraestructura base
    PrismaService,

    // Vincula puertos OUT con adaptadores
    {
      provide: ADMIN_USER_REPOSITORY,
      useClass: PrismaAdminUserAdapter,
    },
    {
      provide: ENCRYPTION_SERVICE,
      useClass: BcryptEncryptionAdapter,
    },
    {
      provide: TOKEN_SERVICE,
      useClass: JwtTokenAdapter,
    },

    // Vincula puertos IN con use cases
    {
      provide: LOGIN_USE_CASE,
      useClass: LoginUseCase,
    },
    {
      provide: REGISTER_USE_CASE,
      useClass: RegisterUseCase,
    },
    {
      provide: ME_USE_CASE,
      useClass: MeUseCase,
    },

    // Guards y Strategy
    JwtAuthGuard,
    RolesGuard,
    JwtStrategy,
  ],
  exports: [JwtAuthGuard, RolesGuard, JwtModule, PrismaService],
})
export class InfrastructureModule {}
