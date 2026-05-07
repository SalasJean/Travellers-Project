// ============================================
// USE CASE — Get Tours
// Obtiene todos los tours publicados
// con filtros opcionales
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { GetToursUseCasePort } from '../../../domain/ports/in/get-tours-use-case.port';
import type { TourRepositoryPort, TourFilters } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';

@Injectable()
export class GetToursUseCase implements GetToursUseCasePort {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute(filters: TourFilters) {
    // 1️⃣ Siempre filtramos por publicados en la vista pública
    const tours = await this.tourRepository.findAll({
      ...filters,
      status: 'published',
    })

    // 2️⃣ Retornamos datos públicos de cada tour
    return tours.map(tour => tour.toPublic())
  }
}