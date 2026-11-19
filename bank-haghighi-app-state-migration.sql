-- این فایل را یک‌بار در SQL Editor پروژه Supabase اجرا کنید.
-- مخزن وضعیت برنامه بانک حقیقی؛ فقط مدیر همان صندوق اجازه خواندن/نوشتن دارد.
create table if not exists public.app_state (
  fund_id uuid primary key references public.funds(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_by uuid references auth.users(id),
  updated_at timestamptz not null default now()
);
alter table public.app_state enable row level security;
drop policy if exists "admin manage app state" on public.app_state;
create policy "admin manage app state" on public.app_state for all to authenticated
using (public.is_fund_admin(fund_id)) with check (public.is_fund_admin(fund_id));
grant select, insert, update on public.app_state to authenticated;
