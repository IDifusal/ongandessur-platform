-- Adds body column to pages table
-- Run this if you already applied 001_initial.sql before body was added

alter table public.pages
  add column if not exists body text;
