// ============================================
// INFRASTRUCTURE MODULE
// Ensambla todos los adaptadores
// Vincula puertos con implementaciones
// ============================================
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';

// Adaptadores IN — Controllers
import { AuthController } from './adapters/in/controllers/auth.controller';
import { ToursPublicController, ToursAdminController } from './adapters/in/controllers/tours.controller';

// Adaptadores OUT — Auth
import { PrismaService } from './adapters/out/repositories/prisma/prisma.service';
import { PrismaAdminUserAdapter } from './adapters/out/repositories/prisma/prisma-admin-user.adapter';
import { BcryptEncryptionAdapter } from './adapters/out/encryption/bcrypt-encryption.adapter';
import { JwtTokenAdapter } from './adapters/out/auth/jwt-token.adapter';

// Adaptadores OUT — Tours
import { PrismaTourAdapter } from './adapters/out/repositories/prisma/prisma-tour.adapter';

// Guards y Strategy
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { JwtStrategy } from './strategies/jwt.strategy';

// Use Cases — Auth
import { LoginUseCase } from '../application/use-cases/auth/login.use-case';
import { RegisterUseCase } from '../application/use-cases/auth/register.use-case';
import { MeUseCase } from '../application/use-cases/auth/me.use-case';

// Use Cases — Tours
import { GetToursUseCase } from '../application/use-cases/tours/get-tours.use-case';
import { GetTourBySlugUseCase } from '../application/use-cases/tours/get-tour-by-slug.use-case';
import { GetToursAdminUseCase } from '../application/use-cases/tours/get-tours-admin.use-case';
import { CreateTourUseCase } from '../application/use-cases/tours/create-tour.use-case';
import { UpdateTourUseCase } from '../application/use-cases/tours/update-tour.use-case';
import { DeleteTourUseCase } from '../application/use-cases/tours/delete-tour.use-case';

// Tokens
import {
  LOGIN_USE_CASE,
  REGISTER_USE_CASE,
  ME_USE_CASE,
  ADMIN_USER_REPOSITORY,
  ENCRYPTION_SERVICE,
  TOKEN_SERVICE,
} from '../domain/tokens';

// Tokens — Tours
import { TOUR_REPOSITORY_PORT } from '../domain/ports/out/tour-repository.port';
import { GET_TOURS_USE_CASE_PORT } from '../domain/ports/in/get-tours-use-case.port';
import { GET_TOUR_BY_SLUG_USE_CASE_PORT } from '../domain/ports/in/get-tour-by-slug-use-case.port';
import { CREATE_TOUR_USE_CASE_PORT } from '../domain/ports/in/create-tour-use-case.port';
import { UPDATE_TOUR_USE_CASE_PORT } from '../domain/ports/in/update-tour-use-case.port';
import { DELETE_TOUR_USE_CASE_PORT } from '../domain/ports/in/delete-tour-use-case.port';

@Module({
  imports: [
    PassportModule,
    JwtModule.register({
      secret: process.env.JWT_SECRET || 'secret_dev',
      signOptions: { expiresIn: '7d' },
    }),
  ],
  controllers: [
    AuthController,
    ToursPublicController,
    ToursAdminController,
  ],
  providers: [
    // Infraestructura base
    PrismaService,

    // — Auth —
    { provide: ADMIN_USER_REPOSITORY, useClass: PrismaAdminUserAdapter },
    { provide: ENCRYPTION_SERVICE,  useClass: BcryptEncryptionAdapter },
    { provide: TOKEN_SERVICE,       useClass: JwtTokenAdapter },
    { provide: LOGIN_USE_CASE,      useClass: LoginUseCase },
    { provide: REGISTER_USE_CASE,   useClass: RegisterUseCase },
    { provide: ME_USE_CASE,         useClass: MeUseCase },

    // — Tours —
    { provide: TOUR_REPOSITORY_PORT,           useClass: PrismaTourAdapter },
    { provide: GET_TOURS_USE_CASE_PORT,        useClass: GetToursUseCase },
    { provide: GET_TOUR_BY_SLUG_USE_CASE_PORT, useClass: GetTourBySlugUseCase },
    { provide: CREATE_TOUR_USE_CASE_PORT,      useClass: CreateTourUseCase },
    { provide: UPDATE_TOUR_USE_CASE_PORT,      useClass: UpdateTourUseCase },
    { provide: DELETE_TOUR_USE_CASE_PORT,      useClass: DeleteTourUseCase },

    // Guards y Strategy
    JwtAuthGuard,
    RolesGuard,
    JwtStrategy,
  ],
  exports: [JwtAuthGuard, RolesGuard, JwtModule, PrismaService],
})
export class InfrastructureModule {}

