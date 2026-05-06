import 'dotenv/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DomainExceptionFilter } from './infrastructure/filters/domain-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.useGlobalFilters(new DomainExceptionFilter());

  app.enableCors({
    origin: 'http://localhost:3000',
  });
  await app.listen(3001);
  console.log('🚀 Backend corriendo en http://localhost:3001');
}
bootstrap();
//pregunta para que sirve el archivo main.ts en nestjs? recuerda que es el punto de entrada de la aplicacion, es donde se crea la instancia de la aplicacion y se configura para escuchar en un puerto determinado. Es como el main method en java, es el lugar donde se inicia la aplicacion y se pone en marcha todo el sistema. RECUERDA SI?
