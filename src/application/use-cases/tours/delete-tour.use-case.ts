// ============================================
// USE CASE — Delete Tour (Admin)
// Elimina un tour del sistema
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { DeleteTourUseCasePort } from '../../../domain/ports/in/delete-tour-use-case.port';
import type { TourRepositoryPort } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';
import { TourNotFoundException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class DeleteTourUseCase implements DeleteTourUseCasePort {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute(id: string): Promise<void> {
    // 1️⃣ Verificar que el tour existe
    const tour = await this.tourRepository.findById(id)
    if (!tour) throw new TourNotFoundException()

    // 2️⃣ Eliminar el tour
    await this.tourRepository.delete(id)
  }
}