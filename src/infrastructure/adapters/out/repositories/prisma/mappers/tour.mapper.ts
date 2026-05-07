import { Tour } from '../../../../../../domain/entities/tour.entity';

export class TourMapper {
  static toDomain(record: any): Tour {
    return new Tour(
      record.id,
      record.slug,
      record.category,
      record.durationDays,
      record.durationHours,
      record.difficulty,
      record.minGroupSize,
      record.maxGroupSize,
      Number(record.pricePerPerson),
      Number(record.discount3to5Pax),
      Number(record.discount6Plus),
      record.bestSeasons,
      record.thumbnailUrl,
      record.status,
      record.totalBookings,
      Number(record.totalRevenue),
      Number(record.avgRating),
      record.createdAt,
      record.updatedAt,
    );
  }
}
