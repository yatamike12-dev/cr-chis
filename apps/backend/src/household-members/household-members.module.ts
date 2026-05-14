import { Module } from '@nestjs/common';

import { HouseholdMembersController }
from './household-members.controller';

import { HouseholdMembersService }
from './household-members.service';

@Module({

  controllers: [
    HouseholdMembersController,
  ],

  providers: [
    HouseholdMembersService,
  ],
})
export class HouseholdMembersModule {}