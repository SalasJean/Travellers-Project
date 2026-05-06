// ============================================
// ADAPTADOR DE ENTRADA — Auth Controller
// Convierte HTTP requests → puertos de entrada
// No tiene lógica de negocio
// Solo traduce y delega a los use cases
// ============================================
import {
  Controller,
  Post,
  Get,
  Body,
  Request,
  UseGuards,
  HttpCode,
} from '@nestjs/common';
import { Inject } from '@nestjs/common';

// Puertos de entrada
import type { LoginUseCasePort } from '../../../../domain/ports/in/login-use-case.port';
import type { RegisterUseCasePort } from '../../../../domain/ports/in/register-use-case.port';
import type { MeUseCasePort } from '../../../../domain/ports/in/me-use-case.port';
import {
  LOGIN_USE_CASE,
  REGISTER_USE_CASE,
  ME_USE_CASE,
} from '../../../../domain/tokens';

// DTOs
import { LoginRequestDto } from '../dto/login.request.dto';
import { RegisterRequestDto } from '../dto/register.request.dto';

// Guard
import { JwtAuthGuard } from '../../../guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(
    // Inyectamos puertos — no implementaciones
    // El controller no sabe si es LoginUseCase o cualquier otra implementación
    @Inject(LOGIN_USE_CASE)
    private loginUseCase: LoginUseCasePort,

    @Inject(REGISTER_USE_CASE)
    private registerUseCase: RegisterUseCasePort,

    @Inject(ME_USE_CASE)
    private meUseCase: MeUseCasePort,
  ) {}

  // ============================================
  // POST /auth/register
  // ============================================
  @Post('register')
  async register(@Body() dto: RegisterRequestDto) {
    return this.registerUseCase.execute({
      name: dto.name,
      email: dto.email,
      password: dto.password,
    });
  }

  // ============================================
  // POST /auth/login
  // ============================================
  @Post('login')
  @HttpCode(200)
  async login(@Body() dto: LoginRequestDto) {
    return this.loginUseCase.execute({
      email: dto.email,
      password: dto.password,
    });
  }

  // ============================================
  // GET /auth/me — ruta protegida con JWT
  // ============================================
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async me(@Request() req: any) {
    return this.meUseCase.execute(req.user.id);
  }
}
