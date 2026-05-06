// ============================================
// PUERTO DE ENTRADA — Me
// ============================================
export interface MeUseCasePort {
  execute(userId: string): Promise<{
    id: string;
    name: string;
    email: string;
    role: string;
    isActive: boolean;
    avatarUrl?: string | null;
    lastLoginAt?: Date | null;
    createdAt?: Date;
  }>;
}
