// ============================================
// USE CASE — Get Tours Admin
// Obtiene TODOS los tours para el panel CMS
// Sin filtro de status — el admin ve todo
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { TourRepositoryPort } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';

@Injectable()
export class GetToursAdminUseCase {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute() {
    // Admin ve todos los tours — incluye draft, hidden
    const tours = await this.tourRepository.findAllAdmin()
    return tours.map(tour => tour.toAdmin())
  }
}