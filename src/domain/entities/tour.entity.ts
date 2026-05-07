// ============================================
// ENTIDAD — Tour
// Representa el concepto puro de un tour
// Sin dependencias de Prisma, NestJS o BD
// Es el corazón del dominio de Tours
// ============================================
export class Tour {
  constructor(
    public readonly id:              string,
    public readonly slug:            string,
    public readonly category:        string | null,
    public readonly durationDays:    number | null,
    public readonly durationHours:   number | null,
    public readonly difficulty:      number | null,
    public readonly minGroupSize:    number,
    public readonly maxGroupSize:    number,
    public readonly pricePerPerson:  number,
    public readonly discount3to5Pax: number,
    public readonly discount6Plus:   number,
    public readonly bestSeasons:     string[],
    public readonly thumbnailUrl:    string | null,
    public readonly status:          string,
    public readonly totalBookings:   number,
    public readonly totalRevenue:    number,
    public readonly avgRating:       number,
    public readonly createdAt:       Date,
    public readonly updatedAt:       Date,
  ) {}

  // ============================================
  // ¿El tour está publicado?
  // ============================================
  isPublished(): boolean {
    return this.status === 'published' || this.status === 'featured'
  }

  // ============================================
  // Calcula precio según número de viajeros
  // Aplica descuentos por grupo automáticamente
  // ============================================
  calculatePrice(travelers: number): number {
    if (travelers >= 6) {
      return this.pricePerPerson * (1 - this.discount6Plus / 100)
    }
    if (travelers >= 3) {
      return this.pricePerPerson * (1 - this.discount3to5Pax / 100)
    }
    return this.pricePerPerson
  }

  // ============================================
  // ¿El tour acepta más viajeros?
  // ============================================
  hasCapacity(travelers: number): boolean {
    return travelers >= this.minGroupSize &&
           travelers <= this.maxGroupSize
  }

  // ============================================
  // Retorna datos públicos — sin datos internos
  // Lo que ve el turista en el frontend
  // ============================================
  toPublic() {
    return {
      id:              this.id,
      slug:            this.slug,
      category:        this.category,
      durationDays:    this.durationDays,
      durationHours:   this.durationHours,
      difficulty:      this.difficulty,
      minGroupSize:    this.minGroupSize,
      maxGroupSize:    this.maxGroupSize,
      pricePerPerson:  this.pricePerPerson,
      discount3to5Pax: this.discount3to5Pax,
      discount6Plus:   this.discount6Plus,
      bestSeasons:     this.bestSeasons,
      thumbnailUrl:    this.thumbnailUrl,
      status:          this.status,
      avgRating:       this.avgRating,
      createdAt:       this.createdAt,
    }
  }

  // ============================================
  // Retorna datos admin — con datos internos
  // Lo que ve el equipo en el CMS
  // ============================================
  toAdmin() {
    return {
      ...this.toPublic(),
      totalBookings: this.totalBookings,
      totalRevenue:  this.totalRevenue,
      updatedAt:     this.updatedAt,
    }
  }
}