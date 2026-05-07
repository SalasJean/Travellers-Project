// ============================================
// USE CASE — Create Tour (Admin)
// Crea un nuevo tour en el sistema
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { CreateTourUseCasePort } from '../../../domain/ports/in/create-tour-use-case.port';
import type { TourRepositoryPort, CreateTourData } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';
import { TourSlugAlreadyExistsException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class CreateTourUseCase implements CreateTourUseCasePort {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute(data: CreateTourData) {
    // 1️⃣ Verificar que el slug no existe
    const exists = await this.tourRepository.findBySlug(data.slug)
    if (exists) throw new TourSlugAlreadyExistsException()

    // 2️⃣ Crear el tour
    const tour = await this.tourRepository.create(data)

    // 3️⃣ Retornar datos admin
    return tour.toAdmin()
  }
}