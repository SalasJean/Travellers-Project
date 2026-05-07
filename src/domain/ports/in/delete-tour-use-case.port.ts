// ============================================
// PUERTO DE ENTRADA — Delete Tour (Admin)
// ============================================
export interface DeleteTourUseCasePort {
  execute(id: string): Promise<void>
}

export const DELETE_TOUR_USE_CASE_PORT = 'DELETE_TOUR_USE_CASE_PORT'