import { Injectable } from '@nestjs/common';

import { PrismaService }
from '../prisma/prisma.service';

import { CreateAlertDto }
from './dto/create-alert.dto';

@Injectable()
export class AlertsService {

  constructor(
    private readonly prisma: PrismaService,
  ) {}

  async findByHousehold(
    householdId: string,
  ) {

    return this.prisma.alert.findMany({

      where: {
        householdId,
      },

      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async create(
    createDto: CreateAlertDto,
  ) {

    return this.prisma.alert.create({

      data: createDto,
    });
  }

  async resolve(
    id: string,
  ) {

    return this.prisma.alert.update({

      where: {
        id,
      },

      data: {
        resolved: true,
      },
    });
  }
}