export class CreateHouseholdDto {

  householdHead: string;

  phoneNumber: string;

  village: string;

  district: string;

  householdSize: number;

  hasPregnantWoman: boolean;

  hasDisabledMember: boolean;

  notes?: string;
}