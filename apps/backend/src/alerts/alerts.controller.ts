import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
} from '@nestjs/common';

import { AlertsService }
from './alerts.service';

import { CreateAlertDto }
from './dto/create-alert.dto';

@Controller('alerts')
export class AlertsController {

  constructor(
    private readonly alertsService:
      AlertsService,
  ) {}

  @Get(':householdId')
  async findByHousehold(

    @Param('householdId')
    householdId: string,

  ) {

    return this.alertsService
      .findByHousehold(householdId);
  }

  @Post()
  async create(

    @Body()
    createDto: CreateAlertDto,

  ) {

    return this.alertsService
      .create(createDto);
  }

  @Patch(':id/resolve')
  async resolve(
    @Param('id') id: string,
  ) {

    return this.alertsService
      .resolve(id);
  }
}