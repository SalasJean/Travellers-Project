// ============================================
// PUERTO DE ENTRADA — Get Tours
// ============================================
import type { TourFilters } from '../out/tour-repository.port';

export interface GetToursUseCasePort {
  execute(filters: TourFilters): Promise<any[]>
}

export const GET_TOURS_USE_CASE_PORT = 'GET_TOURS_USE_CASE_PORT'