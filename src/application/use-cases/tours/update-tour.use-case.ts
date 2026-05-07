// ============================================
// USE CASE — Update Tour (Admin)
// Actualiza un tour existente
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { UpdateTourUseCasePort } from '../../../domain/ports/in/update-tour-use-case.port';
import type { TourRepositoryPort, CreateTourData } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';
import { TourNotFoundException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class UpdateTourUseCase implements UpdateTourUseCasePort {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute(id: string, data: Partial<CreateTourData>) {
    // 1️⃣ Verificar que el tour existe
    const tour = await this.tourRepository.findById(id)
    if (!tour) throw new TourNotFoundException()

    // 2️⃣ Actualizar el tour
    const updated = await this.tourRepository.update(id, data)

    // 3️⃣ Retornar datos admin
    return updated.toAdmin()
  }
}