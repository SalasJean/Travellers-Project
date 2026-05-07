// ============================================
// ADAPTADOR DE ENTRADA — Tours Controller
// Convierte HTTP requests → puertos de entrada
// Rutas públicas y rutas admin protegidas
// ============================================
import {
  Controller, Get, Post, Put, Delete,
  Param, Body, Query,
  UseGuards, HttpCode,
} from '@nestjs/common';
import { Inject } from '@nestjs/common';

// Puertos de entrada
import type { GetToursUseCasePort } from '../../../../domain/ports/in/get-tours-use-case.port';
import type { GetTourBySlugUseCasePort } from '../../../../domain/ports/in/get-tour-by-slug-use-case.port';
import type { CreateTourUseCasePort } from '../../../../domain/ports/in/create-tour-use-case.port';
import type { UpdateTourUseCasePort } from '../../../../domain/ports/in/update-tour-use-case.port';
import type { DeleteTourUseCasePort } from '../../../../domain/ports/in/delete-tour-use-case.port';
import {
  GET_TOURS_USE_CASE_PORT,
} from '../../../../domain/ports/in/get-tours-use-case.port';
import {
  GET_TOUR_BY_SLUG_USE_CASE_PORT,
} from '../../../../domain/ports/in/get-tour-by-slug-use-case.port';
import {
  CREATE_TOUR_USE_CASE_PORT,
} from '../../../../domain/ports/in/create-tour-use-case.port';
import {
  UPDATE_TOUR_USE_CASE_PORT,
} from '../../../../domain/ports/in/update-tour-use-case.port';
import {
  DELETE_TOUR_USE_CASE_PORT,
} from '../../../../domain/ports/in/delete-tour-use-case.port';

// DTOs
import { CreateTourDto } from '../dto/tours/create-tour.dto';
import { UpdateTourDto } from '../dto/tours/update-tour.dto';
import { TourFiltersDto } from '../dto/tours/tour-filters.dto';

// Guard
import { JwtAuthGuard } from '../../../guards/jwt-auth.guard';

// ============================================
// RUTAS PÚBLICAS — /tours
// ============================================
@Controller('tours')
export class ToursPublicController {
  constructor(
    @Inject(GET_TOURS_USE_CASE_PORT)
    private getToursUseCase: GetToursUseCasePort,

    @Inject(GET_TOUR_BY_SLUG_USE_CASE_PORT)
    private getTourBySlugUseCase: GetTourBySlugUseCasePort,
  ) {}

  // GET /tours
  // GET /tours?category=adventure&minPrice=100
  @Get()
  async getAll(@Query() filters: TourFiltersDto) {
    return this.getToursUseCase.execute(filters)
  }

  // GET /tours/:slug
  @Get(':slug')
  async getBySlug(
    @Param('slug') slug: string,
    @Query('locale') locale?: string,
  ) {
    return this.getTourBySlugUseCase.execute(slug, locale)
  }
}

// ============================================
// RUTAS ADMIN — /admin/tours (protegidas)
// ============================================
@Controller('admin/tours')
@UseGuards(JwtAuthGuard)
export class ToursAdminController {
  constructor(
    @Inject(GET_TOURS_USE_CASE_PORT)
    private getToursUseCase: GetToursUseCasePort,

    @Inject(CREATE_TOUR_USE_CASE_PORT)
    private createTourUseCase: CreateTourUseCasePort,

    @Inject(UPDATE_TOUR_USE_CASE_PORT)
    private updateTourUseCase: UpdateTourUseCasePort,

    @Inject(DELETE_TOUR_USE_CASE_PORT)
    private deleteTourUseCase: DeleteTourUseCasePort,
  ) {}

  // GET /admin/tours
  @Get()
  async getAll() {
    return this.getToursUseCase.execute({})
  }

  // POST /admin/tours
  @Post()
  async create(@Body() dto: CreateTourDto) {
    return this.createTourUseCase.execute(dto)
  }

  // PUT /admin/tours/:id
  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateTourDto,
  ) {
    return this.updateTourUseCase.execute(id, dto)
  }

  // DELETE /admin/tours/:id
  @Delete(':id')
  @HttpCode(204)
  async delete(@Param('id') id: string) {
    return this.deleteTourUseCase.execute(id)
  }
}