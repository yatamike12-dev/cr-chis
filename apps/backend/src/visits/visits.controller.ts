import {
  Controller,
  Get,
  Post,
  Body,
  Param,
} from '@nestjs/common';

import { VisitsService }
from './visits.service';

import { CreateVisitDto }
from './dto/create-visit.dto';

@Controller('visits')
export class VisitsController {

  constructor(
    private readonly visitsService:
      VisitsService,
  ) {}

  @Get(':householdId')
  async findByHousehold(

    @Param('householdId')
    householdId: string,

  ) {

    return this.visitsService
      .findByHousehold(householdId);
  }

  @Post()
  async create(

    @Body()
    createDto: CreateVisitDto,

  ) {

    return this.visitsService
      .create(createDto);
  }
}