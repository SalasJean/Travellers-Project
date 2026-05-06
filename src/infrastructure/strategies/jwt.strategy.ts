import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

//recuerda que aqui se usa de manera extensiva los decoradores de nestjs y passport para crear una estrategia de autenticacion con jwt
//al igual que en spring si? recuerda siempre los decoradores son como anotaciones en java y se usan para agregar metadata a las clases y metodos para que nestjs pueda entender como usarlos

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'secret_dev',
    });
  }

  async validate(payload: any) {
    return {
      id: payload.sub,
      email: payload.email,
      role: payload.role,
    };
  }
}
