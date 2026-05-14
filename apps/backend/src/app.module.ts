import { Module } from '@nestjs/common';

import { PrismaModule }
from './prisma/prisma.module';

import { UsersModule }
from './users/users.module';

import { HouseholdsModule }
from './households/households.module';

import { HouseholdMembersModule }
from './household-members/household-members.module';

import { VisitsModule }
from './visits/visits.module';

import { AlertsModule }
from './alerts/alerts.module';

@Module({

  imports: [

    PrismaModule,

    UsersModule,

    HouseholdsModule,

    HouseholdMembersModule,

    VisitsModule,

    AlertsModule,
  ],
})
export class AppModule {}