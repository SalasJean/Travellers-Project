import {
  IsString, IsOptional,
  IsNumber, IsArray, IsEnum,
  Min, Max, MinLength,
} from 'class-validator';
import { TourCategory, TourStatus } from './create-tour.dto';

export class UpdateTourDto {
  @IsOptional()
  @IsString()
  @MinLength(3)
  slug?: string;

  @IsOptional()
  @IsEnum(TourCategory)
  category?: TourCategory;

  @IsOptional()
  @IsNumber()
  @Min(1)
  durationDays?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  durationHours?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(5)
  difficulty?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  minGroupSize?: number;

  @IsOptional()
  @IsNumber()
  @Min(1)
  maxGroupSize?: number;

  @IsOptional()
  @IsNumber()
  @Min(0)
  pricePerPerson?: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  bestSeasons?: string[];

  @IsOptional()
  @IsString()
  thumbnailUrl?: string;

  @IsOptional()
  @IsEnum(TourStatus)
  status?: TourStatus;
}
