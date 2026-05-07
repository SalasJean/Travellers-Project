import { Injectable } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import type { TourRepositoryPort, TourFilters, CreateTourData } from '../../../../../domain/ports/out/tour-repository.port';
import type { Tour } from '../../../../../domain/entities/tour.entity';
import { TourMapper } from './mappers/tour.mapper';

@Injectable()
export class PrismaTourAdapter implements TourRepositoryPort {
  constructor(private prisma: PrismaService) {}

  async findAll(filters: TourFilters): Promise<Tour[]> {
    const where: any = {};

    if (filters.status) where.status = filters.status;
    if (filters.category) where.category = filters.category;
    if (filters.minPrice !== undefined || filters.maxPrice !== undefined) {
      where.pricePerPerson = {};
      if (filters.minPrice !== undefined) where.pricePerPerson.gte = filters.minPrice;
      if (filters.maxPrice !== undefined) where.pricePerPerson.lte = filters.maxPrice;
    }
    if (filters.duration !== undefined) {
      where.durationDays = filters.duration;
    }

    const records = await this.prisma.tour.findMany({ where });
    return records.map(TourMapper.toDomain);
  }

  async findBySlug(slug: string): Promise<Tour | null> {
    const record = await this.prisma.tour.findUnique({ where: { slug } });
    return record ? TourMapper.toDomain(record) : null;
  }

  async findFeatured(): Promise<Tour[]> {
    const records = await this.prisma.tour.findMany({
      where: { status: 'featured' },
    });
    return records.map(TourMapper.toDomain);
  }

  async findAllAdmin(): Promise<Tour[]> {
    const records = await this.prisma.tour.findMany();
    return records.map(TourMapper.toDomain);
  }

  async findById(id: string): Promise<Tour | null> {
    const record = await this.prisma.tour.findUnique({ where: { id } });
    return record ? TourMapper.toDomain(record) : null;
  }

  async create(data: CreateTourData): Promise<Tour> {
    const record = await this.prisma.tour.create({ data: data as any });
    return TourMapper.toDomain(record);
  }

  async update(id: string, data: Partial<CreateTourData>): Promise<Tour> {
    const record = await this.prisma.tour.update({
      where: { id },
      data: data as any,
    });
    return TourMapper.toDomain(record);
  }

  async delete(id: string): Promise<void> {
    await this.prisma.tour.delete({ where: { id } });
  }
}
