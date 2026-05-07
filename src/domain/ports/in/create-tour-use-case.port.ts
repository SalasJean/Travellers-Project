// ============================================
// PUERTO DE ENTRADA — Create Tour (Admin)
// ============================================
import type { CreateTourData } from '../out/tour-repository.port';

export interface CreateTourUseCasePort {
  execute(data: CreateTourData): Promise<any>
}

export const CREATE_TOUR_USE_CASE_PORT = 'CREATE_TOUR_USE_CASE_PORT'