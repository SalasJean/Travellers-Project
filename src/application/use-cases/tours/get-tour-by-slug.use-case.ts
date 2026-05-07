// ============================================
// USE CASE — Get Tour By Slug
// Obtiene el detalle completo de un tour
// ============================================
import { Inject, Injectable } from '@nestjs/common';
import type { GetTourBySlugUseCasePort } from '../../../domain/ports/in/get-tour-by-slug-use-case.port';
import type { TourRepositoryPort } from '../../../domain/ports/out/tour-repository.port';
import { TOUR_REPOSITORY_PORT } from '../../../domain/ports/out/tour-repository.port';
import { TourNotFoundException } from '../../../domain/exceptions/domain.exception';

@Injectable()
export class GetTourBySlugUseCase implements GetTourBySlugUseCasePort {
  constructor(
    @Inject(TOUR_REPOSITORY_PORT)
    private tourRepository: TourRepositoryPort,
  ) {}

  async execute(slug: string, locale?: string) {
    // 1️⃣ Buscar tour por slug
    const tour = await this.tourRepository.findBySlug(slug)

    // 2️⃣ Si no existe → excepción del dominio
    if (!tour) throw new TourNotFoundException()

    // 3️⃣ Si no está publicado → excepción del dominio
    if (!tour.isPublished()) throw new TourNotFoundException()

    // 4️⃣ Retornar datos públicos
    return tour.toPublic()
  }
}