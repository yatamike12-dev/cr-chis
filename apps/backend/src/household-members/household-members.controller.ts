import {
  Controller,
  Get,
  Post,
  Body,
  Param,
} from '@nestjs/common';

import { HouseholdMembersService }
from './household-members.service';

import { CreateHouseholdMemberDto }
from './dto/create-household-member.dto';

@Controller('household-members')
export class HouseholdMembersController {

  constructor(
    private readonly householdMembersService:
      HouseholdMembersService,
  ) {}

  @Get(':householdId')
  async findByHousehold(
    @Param('householdId') householdId: string,
  ) {

    return this.householdMembersService
      .findByHousehold(householdId);
  }

  @Post()
  async create(
    @Body()
    createDto: CreateHouseholdMemberDto,
  ) {

    return this.householdMembersService
      .create(createDto);
  }
}