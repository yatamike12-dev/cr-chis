import {
  Controller,
  Get,
  Post,
  Body,
  Param,
} from '@nestjs/common';

import { HouseholdsService } from './households.service';

import { CreateHouseholdDto } from './dto/create-household.dto';

@Controller('households')
export class HouseholdsController {

  constructor(
    private householdsService: HouseholdsService,
  ) {}

  @Get()
  async findAll() {
    return this.householdsService.findAll();
  }

  @Get(':id')
  async findOne(
    @Param('id') id: string,
  ) {

    return this.householdsService.findOne(id);
  }

  @Post()
  async create(
    @Body() createHouseholdDto: CreateHouseholdDto,
  ) {

    return this.householdsService.create(
      createHouseholdDto,
    );
  }
}