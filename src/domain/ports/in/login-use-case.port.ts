// ============================================
// PUERTO DE ENTRADA — Login
// Define QUÉ puede hacer el mundo exterior
// El controller llama a este puerto
// ============================================
export interface LoginUseCasePort {
  execute(data: { email: string; password: string }): Promise<{
    access_token: string;
    user: {
      id: string;
      name: string;
      email: string;
      role: string;
    };
  }>;
}
