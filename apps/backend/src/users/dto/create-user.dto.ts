import { UserRole } from '@prisma/client';

export class CreateUserDto {
  fullName: string;
  email: string;
  password: string;
  role: UserRole;
}