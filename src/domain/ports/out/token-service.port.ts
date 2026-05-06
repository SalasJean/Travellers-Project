// ============================================
// PUERTO DE SALIDA — Token Service
// Define QUÉ necesita el dominio para generar/verificar tokens
// NO sabe si es JWT, OAuth, sesiones, etc
// ============================================
export interface TokenServicePort {
  sign(payload: Record<string, unknown>): string
  verify(token: string): Record<string, unknown>
}
