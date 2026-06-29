# BatikQuest Supabase

Run the migration in `supabase/migrations/202606120001_create_batikquest_schema.sql`
from the Supabase SQL editor or with the Supabase CLI.

The migration creates:

- Auth profile trigger
- PostgreSQL tables for the MVP
- RLS policies for authenticated users
- Public `batik-uploads` storage bucket
- Seed data for Parang, Bali, Kawung, Megamendung
- Daily task pool seed data
