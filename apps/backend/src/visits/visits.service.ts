import { Injectable } from '@nestjs/common';

import { PrismaService }
from '../prisma/prisma.service';

import { CreateVisitDto }
from './dto/create-visit.dto';

@Injectable()
export class VisitsService {

  constructor(
    private readonly prisma: PrismaService,
  ) {}

  async findByHousehold(
    householdId: string,
  ) {

    return this.prisma.visit.findMany({

      where: {
        householdId,
      },

      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async create(
    createDto: CreateVisitDto,
  ) {

    return this.prisma.visit.create({

      data: createDto,
    });
  }
}