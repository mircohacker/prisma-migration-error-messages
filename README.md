# Prisma migration with transaction fails without good error message

According to this [blog post](https://www.prisma.io/blog/prisma-migrate-dx-primitives#what-if-schema-migrations-were-atomic) Prisma supports transactions for migrations when using the postgres database. To use this feature we need to manually edit the created migrations and add `BEGIN;` and `COMMIT;` at the appropriate locations. When such a migration wrapped in a transaction fails. The error message is pretty unhelpful as seen in `Actual output`. 

## Commands to reproduce

```bash
git clone git@github.com:mircohaug/prisma-migration-error-messages.git
cd prisma-migration-error-messages

npm install
docker-compose up -d
npx prisma migrate reset -f
```

## Actual output

```
❯ npx prisma migrate reset -f
Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": PostgreSQL database "db_name", schema "public" at "localhost:6543"

Applying migration `20220913090323_init`
Error: db error: ERROR: current transaction is aborted, commands ignored until end of transaction block
   0: migration_core::commands::apply_migrations::Applying migration
           with migration_name="20220913090323_init"
             at migration-engine/core/src/commands/apply_migrations.rs:91
   1: migration_core::state::ApplyMigrations
             at migration-engine/core/src/state.rs:185
```

## Expected output

Created by removing the transaction from the migration script

```
❯ npx prisma migrate reset -f
Environment variables loaded from .env
Prisma schema loaded from prisma/schema.prisma
Datasource "db": PostgreSQL database "db_name", schema "public" at "localhost:6543"

Applying migration `20220913090323_init`
Error: P3018

A migration failed to apply. New migrations cannot be applied before the error is recovered from. Read more about how to resolve migration issues in a production database: https://pris.ly/d/migrate-resolve

Migration name: 20220913090323_init

Database error code: 23505

Database error:
ERROR: could not create unique index "User_email_key"
DETAIL: Key (email)=(a@example.com) is duplicated.

DbError { severity: "ERROR", parsed_severity: Some(Error), code: SqlState(E23505), message: "could not create unique index \"User_email_key\"", detail: Some("Key (email)=(a@example.com) is duplicated."), hint: None, position: None, where_: None, schema: Some("public"), table: Some("User"), column: None, datatype: None, constraint: Some("User_email_key"), file: Some("tuplesort.c"), line: Some(4058), routine: Some("comparetup_index_btree") }
```