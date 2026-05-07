// ============================================
// DTO — Create Tour Request
// Valida los datos que llegan del HTTP request
// ============================================
import {
  IsString, IsNotEmpty, IsOptional,
  IsNumber, IsArray, IsEnum,
  Min, Max, MinLength
} from 'class-validator'

export enum TourCategory {
  CULTURAL  = 'cultural',
  ADVENTURE = 'adventure',
  NATURE    = 'nature',
  MIXED     = 'mixed',
}

export enum TourStatus {
  DRAFT     = 'draft',
  PUBLISHED = 'published',
  FEATURED  = 'featured',
  HIDDEN    = 'hidden',
}

export class CreateTourDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  slug!: string

  @IsOptional()
  @IsEnum(TourCategory)
  category?: TourCategory

  @IsOptional()
  @IsNumber()
  @Min(1)
  durationDays?: number

  @IsOptional()
  @IsNumber()
  @Min(1)
  durationHours?: number

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(5)
  difficulty?: number

  @IsOptional()
  @IsNumber()
  @Min(1)
  minGroupSize?: number

  @IsOptional()
  @IsNumber()
  @Min(1)
  maxGroupSize?: number

  @IsNumber()
  @Min(0)
  pricePerPerson!: number

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  bestSeasons?: string[]

  @IsOptional()
  @IsString()
  thumbnailUrl?: string

  @IsOptional()
  @IsEnum(TourStatus)
  status?: TourStatus
}