import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

import { CreateHouseholdDto } from './dto/create-household.dto';

@Injectable()
export class HouseholdsService {

  constructor(
    private prisma: PrismaService,
  ) {}

  async findAll() {

    return this.prisma.household.findMany();
  }

  async findOne(id: string) {

    return this.prisma.household.findUnique({
      where: {
        id,
      },
    });
  }

  async create(
    createHouseholdDto: CreateHouseholdDto,
  ) {

    return this.prisma.household.create({
      data: createHouseholdDto,
    });
  }
}