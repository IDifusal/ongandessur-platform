-- Adds feature image column to news and services tables

alter table public.news add column if not exists image text;
alter table public.services add column if not exists image text;
