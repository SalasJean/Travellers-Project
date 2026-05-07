// ============================================
// PUERTO DE SALIDA — Tour Repository
// Define QUÉ necesita el dominio de la BD
// NO sabe si es Prisma, MongoDB, etc
// ============================================
import type { Tour } from '../../entities/tour.entity';

export interface TourFilters {
  category?:  string
  minPrice?:  number
  maxPrice?:  number
  duration?:  number
  status?:    string
  locale?:    string
}

export interface TourRepositoryPort {
  // Públicos
  findAll(filters: TourFilters):        Promise<Tour[]>
  findBySlug(slug: string):             Promise<Tour | null>
  findFeatured():                       Promise<Tour[]>

  // Admin
  findAllAdmin():                       Promise<Tour[]>
  findById(id: string):                 Promise<Tour | null>
  create(data: CreateTourData):         Promise<Tour>
  update(id: string, data: Partial<CreateTourData>): Promise<Tour>
  delete(id: string):                   Promise<void>
}

export interface CreateTourData {
  slug:           string
  category?:      string
  durationDays?:  number
  durationHours?: number
  difficulty?:    number
  minGroupSize?:  number
  maxGroupSize?:  number
  pricePerPerson: number
  bestSeasons?:   string[]
  thumbnailUrl?:  string
  status?:        string
}

export const TOUR_REPOSITORY_PORT = 'TOUR_REPOSITORY_PORT'