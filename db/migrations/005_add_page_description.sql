-- Adds description column to pages table for meta descriptions

alter table public.pages add column if not exists description text;
