// ============================================
// EXCEPCIÓN BASE DEL DOMINIO
// Todas las excepciones de negocio heredan de esta
// El dominio no conoce excepciones de HTTP
// ============================================
export class DomainException extends Error {
  constructor(
    public readonly message: string,
    public readonly code: string,
  ) {
    super(message);
    this.name = 'DomainException';
  }
}

export class UserAlreadyExistsException extends DomainException {
  constructor() {
    super('User already exists', 'USER_ALREADY_EXISTS');
  }
}

export class InvalidCredentialsException extends DomainException {
  constructor() {
    super('Invalid credentials', 'INVALID_CREDENTIALS');
  }
}

export class UserInactiveException extends DomainException {
  constructor() {
    super('User is inactive', 'USER_INACTIVE');
  }
}

export class UserNotFoundException extends DomainException {
  constructor() {
    super('User not found', 'USER_NOT_FOUND');
  }
}
