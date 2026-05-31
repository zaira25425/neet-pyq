-- Run once in Supabase -> SQL Editor
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  parent_email text, consent_given boolean default false, consent_at timestamptz,
  paid boolean default false, paid_at timestamptz, created_at timestamptz default now()
);
create table attempts (
  id bigint generated always as identity primary key,
  user_id uuid references auth.users(id) on delete cascade,
  exam_label text, score int, total int, correct int, wrong int,
  unattempted int, taken_at timestamptz default now()
);
alter table profiles enable row level security;
alter table attempts enable row level security;
create policy "own profile"  on profiles  for all using (auth.uid() = id);
create policy "own attempts" on attempts for all using (auth.uid() = user_id);
