-- JanSamadhan starter schema. Apply in Supabase SQL Editor.
create extension if not exists pgcrypto;

create type public.app_role as enum ('citizen','representative','official','social_worker','admin');
create type public.complaint_status as enum ('submitted','acknowledged','assigned','in_progress','resolved','rejected');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  phone text,
  role public.app_role not null default 'citizen',
  preferred_language text not null default 'en',
  created_at timestamptz not null default now()
);

create table public.representatives (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete cascade,
  designation text not null check (designation in ('MP','MLA','Ward Member','Councillor','Chairperson','Municipal Officer','Social Worker','Other')),
  public_name text not null,
  constituency text,
  district text,
  state text,
  verification_status text not null default 'pending' check (verification_status in ('pending','verified','rejected')),
  official_contact text,
  created_at timestamptz not null default now()
);

create table public.complaints (
  id uuid primary key default gen_random_uuid(),
  reference_code text unique not null,
  citizen_id uuid not null references public.profiles(id),
  title text not null,
  category text not null,
  description text not null,
  state text,
  district text,
  city_or_village text,
  ward text,
  address_text text,
  latitude double precision,
  longitude double precision,
  media_urls text[] not null default '{}',
  status public.complaint_status not null default 'submitted',
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.complaint_assignments (
  id uuid primary key default gen_random_uuid(),
  complaint_id uuid not null references public.complaints(id) on delete cascade,
  representative_id uuid references public.representatives(id),
  department_name text,
  assigned_by uuid references public.profiles(id),
  note text,
  created_at timestamptz not null default now()
);

create table public.complaint_updates (
  id uuid primary key default gen_random_uuid(),
  complaint_id uuid not null references public.complaints(id) on delete cascade,
  author_id uuid references public.profiles(id),
  status public.complaint_status,
  message text not null,
  evidence_urls text[] not null default '{}',
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.representatives enable row level security;
alter table public.complaints enable row level security;
alter table public.complaint_assignments enable row level security;
alter table public.complaint_updates enable row level security;

-- Starter policies: authenticated users can view public profiles and verified public representatives.
create policy "profiles read authenticated" on public.profiles
for select to authenticated using (true);

create policy "profile owner insert" on public.profiles
for insert to authenticated with check (auth.uid() = id);

create policy "profile owner update" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "verified representatives visible" on public.representatives
for select to authenticated using (verification_status = 'verified');

create policy "citizens read public complaints" on public.complaints
for select to authenticated using (is_public = true or citizen_id = auth.uid());

create policy "citizens create own complaints" on public.complaints
for insert to authenticated with check (citizen_id = auth.uid());

create policy "complaint updates visible for public complaint" on public.complaint_updates
for select to authenticated using (
  exists (select 1 from public.complaints c where c.id = complaint_id and (c.is_public = true or c.citizen_id = auth.uid()))
);

-- IMPORTANT:
-- Add stricter role-aware policies before production. Never allow clients to set
-- representative verification_status or admin roles. Do not expose service_role keys.
-- Use server-side Edge Functions for representative verification and assignment.
