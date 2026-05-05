-- Adds contact_phone to products table
-- Run this if you already applied 001_initial.sql before contact_phone was added

alter table public.products
  add column if not exists contact_phone text not null default '';
