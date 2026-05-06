// ============================================
// VALUE OBJECT — Email
// Encapsula la lógica de validación del email
// Inmutable — una vez creado no cambia
// ============================================
export class Email {
  private readonly value: string;

  constructor(email: string) {
    if (!this.isValid(email)) {
      throw new Error(`Invalid email: ${email}`);
    }
    this.value = email.toLowerCase().trim();
  }

  private isValid(email: string): boolean {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  }

  toString(): string {
    return this.value;
  }

  equals(other: Email): boolean {
    return this.value === other.value;
  }
}
