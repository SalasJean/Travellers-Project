// ============================================
// PUERTO DE ENTRADA — Register
// ============================================
export interface RegisterUseCasePort {
  execute(data: { name: string; email: string; password: string }): Promise<{
    access_token: string;
    user: {
      id: string;
      name: string;
      email: string;
      role: string;
    };
  }>;
}
