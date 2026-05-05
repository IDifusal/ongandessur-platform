-- ============================================================
-- SEO Meta
-- ============================================================
create table if not exists public.seo_meta (
  id          uuid primary key default gen_random_uuid(),
  title       text,
  description text,
  og_image    text,
  canonical   text,
  noindex     boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ============================================================
-- Pages
-- ============================================================
create table if not exists public.pages (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  title        text not null,
  body         text,
  content      jsonb not null default '{}',
  seo_id       uuid references public.seo_meta(id) on delete set null,
  published_at timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ============================================================
-- Products
-- ============================================================
create table if not exists public.products (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  name         text not null,
  description    text,
  price          numeric(10,2) not null,
  contact_phone  text not null,
  images         text[] not null default '{}',
  seo_id       uuid references public.seo_meta(id) on delete set null,
  published_at timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ============================================================
-- News
-- ============================================================
create table if not exists public.news (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  title        text not null,
  body         text,
  excerpt      text,
  seo_id       uuid references public.seo_meta(id) on delete set null,
  published_at timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ============================================================
-- Services
-- ============================================================
create table if not exists public.services (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  title        text not null,
  description  text,
  content      jsonb not null default '{}',
  icon         text,
  seo_id       uuid references public.seo_meta(id) on delete set null,
  published_at timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ============================================================
-- Indexes
-- ============================================================
create index if not exists idx_pages_slug       on public.pages (slug);
create index if not exists idx_products_slug    on public.products (slug);
create index if not exists idx_news_slug        on public.news (slug);
create index if not exists idx_services_slug    on public.services (slug);
create index if not exists idx_pages_published  on public.pages (published_at desc);
create index if not exists idx_news_published   on public.news (published_at desc);
create index if not exists idx_services_published on public.services (published_at desc);

-- ============================================================
-- Row-Level Security
-- ============================================================
alter table public.seo_meta    enable row level security;
alter table public.pages       enable row level security;
alter table public.products    enable row level security;
alter table public.news        enable row level security;
alter table public.services    enable row level security;

-- Public read
drop policy if exists "Public read: seo_meta"  on public.seo_meta;
create policy "Public read: seo_meta"  on public.seo_meta  for select using (true);
drop policy if exists "Public read: pages"     on public.pages;
create policy "Public read: pages"     on public.pages     for select using (true);
drop policy if exists "Public read: products"  on public.products;
create policy "Public read: products"  on public.products  for select using (true);
drop policy if exists "Public read: news"      on public.news;
create policy "Public read: news"      on public.news      for select using (true);
drop policy if exists "Public read: services"  on public.services;
create policy "Public read: services"  on public.services  for select using (true);

-- Authenticated write (dashboard users)
drop policy if exists "Auth write: seo_meta"  on public.seo_meta;
create policy "Auth write: seo_meta"  on public.seo_meta  for all using (auth.role() = 'authenticated');
drop policy if exists "Auth write: pages"     on public.pages;
create policy "Auth write: pages"     on public.pages     for all using (auth.role() = 'authenticated');
drop policy if exists "Auth write: products"  on public.products;
create policy "Auth write: products"  on public.products  for all using (auth.role() = 'authenticated');
drop policy if exists "Auth write: news"      on public.news;
create policy "Auth write: news"      on public.news      for all using (auth.role() = 'authenticated');
drop policy if exists "Auth write: services"  on public.services;
create policy "Auth write: services"  on public.services  for all using (auth.role() = 'authenticated');

-- ============================================================
-- Storage: images bucket
-- ============================================================
insert into storage.buckets (id, name, public)
values ('images', 'images', true)
on conflict (id) do nothing;

drop policy if exists "Public read: images" on storage.objects;
create policy "Public read: images"
  on storage.objects for select
  using (bucket_id = 'images');

drop policy if exists "Auth write: images" on storage.objects;
create policy "Auth write: images"
  on storage.objects for insert
  with check (bucket_id = 'images' and auth.role() = 'authenticated');

drop policy if exists "Auth update: images" on storage.objects;
create policy "Auth update: images"
  on storage.objects for update
  using (bucket_id = 'images' and auth.role() = 'authenticated');

drop policy if exists "Auth delete: images" on storage.objects;
create policy "Auth delete: images"
  on storage.objects for delete
  using (bucket_id = 'images' and auth.role() = 'authenticated');
