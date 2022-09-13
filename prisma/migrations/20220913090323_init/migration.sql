BEGIN;

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

INSERT INTO "User"("email") VALUES ('a@example.com'), ('a@example.com');

CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

COMMIT;