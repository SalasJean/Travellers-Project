// ============================================
// APP MODULE — Ensamblador final
// Solo importa módulos — no tiene lógica
// ============================================
import { Module } from '@nestjs/common';
import { InfrastructureModule } from './infrastructure/infrastructure.module';

@Module({
  imports: [InfrastructureModule],
})
export class AppModule {}
