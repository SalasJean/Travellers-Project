// ============================================
// TOKENS DE INYECCIÓN — Centralizados
// Todos los tokens de NestJS DI en un solo lugar
// Evita imports circulares y facilita el mantenimiento
// ============================================

// Puertos de entrada (IN) — Use Cases
export const LOGIN_USE_CASE = 'LoginUseCase';
export const REGISTER_USE_CASE = 'RegisterUseCase';
export const ME_USE_CASE = 'MeUseCase';

// Puertos de salida (OUT) — Repositorios y Servicios
export const ADMIN_USER_REPOSITORY = 'AdminUserRepository';
export const ENCRYPTION_SERVICE = 'EncryptionService';
export const TOKEN_SERVICE = 'TokenService';
