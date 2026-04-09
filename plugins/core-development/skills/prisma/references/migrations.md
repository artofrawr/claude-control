# Prisma Migrations — Safe Patterns

Guidance for schema changes that can break production if done carelessly.

## Adding a Required Column to an Existing Table

Never do this in a single migration. Three-step process:

```sql
-- Migration 1: Add as optional
ALTER TABLE "User" ADD COLUMN "department" TEXT;

-- Migration 2 (or backfill script): Populate data
UPDATE "User" SET "department" = 'General' WHERE "department" IS NULL;

-- Migration 3: Make required
ALTER TABLE "User" ALTER COLUMN "department" SET NOT NULL;
```

In Prisma terms: add with `?` → deploy → backfill → remove `?` → deploy again.

## Renaming a Column

Use `@map` to avoid a destructive rename:

```prisma
model User {
  fullName String @map("name") // Code says fullName, DB column stays "name"
}
```

If you actually need to rename the DB column:
```sql
ALTER TABLE "User" RENAME COLUMN "name" TO "full_name";
```

Then update the schema to match. Create migration with `--create-only`, edit the SQL, then apply.

## Changing a Column Type

```sql
-- 1. Add new column
ALTER TABLE "User" ADD COLUMN "age_new" INTEGER;

-- 2. Migrate data
UPDATE "User" SET "age_new" = CAST("age" AS INTEGER) WHERE "age" ~ '^\d+$';

-- 3. Swap
ALTER TABLE "User" DROP COLUMN "age";
ALTER TABLE "User" RENAME COLUMN "age_new" TO "age";
```

## Adding a Unique Constraint

Handle existing duplicates first:
```sql
-- Remove duplicates (keep lowest ID)
DELETE FROM "User" a USING "User" b
WHERE a.id < b.id AND a.email = b.email;

-- Then add constraint
ALTER TABLE "User" ADD CONSTRAINT "User_email_key" UNIQUE ("email");
```

## Dropping a Column Safely

1. Remove from Prisma schema (code stops using it)
2. Deploy — column still exists in DB but is unused
3. Later migration: `ALTER TABLE "User" DROP COLUMN "name";`

## Production Workflow

```bash
# Check what's pending
npx prisma migrate status

# Apply pending migrations (no prompts, no reset)
npx prisma migrate deploy

# If a migration failed and you've fixed it manually
npx prisma migrate resolve --applied "20240101000000_migration_name"

# If you need to roll back a failed migration
npx prisma migrate resolve --rolled-back "20240101000000_migration_name"
```

## Squashing Migrations

For a clean baseline in production:
```bash
npx prisma migrate diff \
  --from-empty \
  --to-schema-datamodel prisma/schema.prisma \
  --script > prisma/migrations/0_init/migration.sql

npx prisma migrate resolve --applied 0_init
```

## Always Back Up Before Migrating Production

```bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d_%H%M%S).sql
npx prisma migrate deploy
# Rollback if needed: psql $DATABASE_URL < backup_file.sql
```
