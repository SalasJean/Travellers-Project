// ============================================
// PUERTO DE ENTRADA — Update Tour (Admin)
// ============================================
import type { CreateTourData } from '../out/tour-repository.port';

export interface UpdateTourUseCasePort {
  execute(id: string, data: Partial<CreateTourData>): Promise<any>
}

export const UPDATE_TOUR_USE_CASE_PORT = 'UPDATE_TOUR_USE_CASE_PORT'