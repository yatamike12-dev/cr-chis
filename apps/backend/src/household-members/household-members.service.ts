import { Injectable } from '@nestjs/common';

import { PrismaService }
from '../prisma/prisma.service';

import { CreateHouseholdMemberDto }
from './dto/create-household-member.dto';

@Injectable()
export class HouseholdMembersService {

  constructor(
    private readonly prisma: PrismaService,
  ) {}

  async findByHousehold(
    householdId: string,
  ) {

    return this.prisma.householdMember.findMany({

      where: {
        householdId,
      },
    });
  }

  async create(
    createDto: CreateHouseholdMemberDto,
  ) {

    return this.prisma.householdMember.create({

      data: createDto,
    });
  }
}