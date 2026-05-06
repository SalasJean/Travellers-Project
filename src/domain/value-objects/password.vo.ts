// ============================================
// VALUE OBJECT — Password
// Encapsula reglas de validación del password
// Inmutable — una vez creado no cambia
// ============================================
export class Password {
  private readonly value: string;

  constructor(password: string) {
    if (!this.isValid(password)) {
      throw new Error('Password must be at least 8 characters');
    }
    this.value = password;
  }

  private isValid(password: string): boolean {
    return password.length >= 8;
  }

  toString(): string {
    return this.value;
  }
}
