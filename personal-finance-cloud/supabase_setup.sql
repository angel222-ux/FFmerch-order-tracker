-- 个人财务云端版 Supabase 初始化 SQL
-- 在 Supabase -> SQL Editor 执行一次。

create table if not exists public.finance_daily (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  data jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.finance_trip (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  data jsonb not null,
  created_at timestamptz not null default now()
);

create table if not exists public.finance_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.finance_daily enable row level security;
alter table public.finance_trip enable row level security;
alter table public.finance_settings enable row level security;

drop policy if exists "finance_daily_owner" on public.finance_daily;
create policy "finance_daily_owner" on public.finance_daily for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "finance_trip_owner" on public.finance_trip;
create policy "finance_trip_owner" on public.finance_trip for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "finance_settings_owner" on public.finance_settings;
create policy "finance_settings_owner" on public.finance_settings for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
