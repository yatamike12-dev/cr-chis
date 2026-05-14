-- CreateTable
CREATE TABLE "Household" (
    "id" TEXT NOT NULL,
    "householdHead" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "village" TEXT NOT NULL,
    "district" TEXT NOT NULL,
    "householdSize" INTEGER NOT NULL,
    "hasPregnantWoman" BOOLEAN NOT NULL,
    "hasDisabledMember" BOOLEAN NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Household_pkey" PRIMARY KEY ("id")
);
