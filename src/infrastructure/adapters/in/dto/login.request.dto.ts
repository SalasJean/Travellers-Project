// ============================================
// DTO — Login Request
// Define los datos que llegan del HTTP request
// Vive en infrastructure — no en domain
// ============================================
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class LoginRequestDto {
  @IsEmail()
  email!: string;

  @IsNotEmpty()
  @IsString()
  password!: string;
}
