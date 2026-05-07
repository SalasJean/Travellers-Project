// ============================================
// PUERTO DE ENTRADA — Get Tour By Slug
// ============================================
export interface GetTourBySlugUseCasePort {
  execute(slug: string, locale?: string): Promise<any>
}

export const GET_TOUR_BY_SLUG_USE_CASE_PORT = 'GET_TOUR_BY_SLUG_USE_CASE_PORT'