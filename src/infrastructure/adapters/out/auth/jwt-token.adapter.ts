// ============================================
// ADAPTADOR DE SALIDA — JWT Token Service
// Implementa TokenServicePort usando @nestjs/jwt
// Si mañana cambiamos a OAuth — solo cambiamos este archivo
// ============================================
import { Injectable } from '@nestjs/common'
import { JwtService } from '@nestjs/jwt'
import type { TokenServicePort } from '../../../../domain/ports/out/token-service.port'

@Injectable()
export class JwtTokenAdapter implements TokenServicePort {
  constructor(private jwtService: JwtService) {}

  sign(payload: Record<string, unknown>): string {
    return this.jwtService.sign(payload)
  }

  verify(token: string): Record<string, unknown> {
    return this.jwtService.verify(token) as Record<string, unknown>
  }
}
