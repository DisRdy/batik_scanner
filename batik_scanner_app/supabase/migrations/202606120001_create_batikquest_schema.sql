create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default '',
  email text not null default '',
  region text not null default '',
  xp integer not null default 0 check (xp >= 0),
  level integer not null default 1 check (level >= 1),
  rank text not null default 'Pemula Batik',
  streak integer not null default 0 check (streak >= 0),
  last_login_date date,
  last_activity_date date,
  last_streak_date date,
  badges text[] not null default '{}',
  created_at timestamptz not null default now()
);

create table if not exists public.batik_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  history text not null,
  philosophy text not null,
  origin_region text not null,
  image_url text not null default '',
  facts text not null default '',
  created_at timestamptz not null default now()
);

create table if not exists public.user_batik_uploads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  image_url text not null,
  category_id uuid not null references public.batik_categories(id) on delete restrict,
  created_at timestamptz not null default now()
);

create table if not exists public.daily_tasks (
  id uuid primary key default gen_random_uuid(),
  task_key text not null,
  title text not null,
  description text not null default '',
  xp_reward integer not null default 30 check (xp_reward >= 0),
  category_name text,
  unique (task_key, category_name)
);

create table if not exists public.user_daily_tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  task_id uuid not null references public.daily_tasks(id) on delete cascade,
  completed boolean not null default false,
  assigned_date date not null,
  completed_at timestamptz,
  unique (user_id, task_id, assigned_date)
);

create table if not exists public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid not null references public.batik_categories(id) on delete cascade,
  viewed boolean not null default false,
  completed_at timestamptz,
  unique (user_id, category_id)
);

create index if not exists user_daily_tasks_user_date_idx
  on public.user_daily_tasks(user_id, assigned_date);

create index if not exists user_progress_user_idx
  on public.user_progress(user_id);

create index if not exists user_batik_uploads_user_idx
  on public.user_batik_uploads(user_id);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, name, email, region)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'name', split_part(new.email, '@', 1)),
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'region', '')
  )
  on conflict (id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

alter table public.profiles enable row level security;
alter table public.batik_categories enable row level security;
alter table public.user_batik_uploads enable row level security;
alter table public.daily_tasks enable row level security;
alter table public.user_daily_tasks enable row level security;
alter table public.user_progress enable row level security;

drop policy if exists "Profiles are readable by owner" on public.profiles;
create policy "Profiles are readable by owner"
  on public.profiles for select
  to authenticated
  using (auth.uid() = id);

drop policy if exists "Profiles can be inserted by owner" on public.profiles;
create policy "Profiles can be inserted by owner"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);

drop policy if exists "Profiles can be updated by owner" on public.profiles;
create policy "Profiles can be updated by owner"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "Batik categories are readable" on public.batik_categories;
create policy "Batik categories are readable"
  on public.batik_categories for select
  to authenticated
  using (true);

drop policy if exists "Daily task pool is readable" on public.daily_tasks;
create policy "Daily task pool is readable"
  on public.daily_tasks for select
  to authenticated
  using (true);

drop policy if exists "Users read own uploads" on public.user_batik_uploads;
create policy "Users read own uploads"
  on public.user_batik_uploads for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users insert own uploads" on public.user_batik_uploads;
create policy "Users insert own uploads"
  on public.user_batik_uploads for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users read own daily tasks" on public.user_daily_tasks;
create policy "Users read own daily tasks"
  on public.user_daily_tasks for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users insert own daily tasks" on public.user_daily_tasks;
create policy "Users insert own daily tasks"
  on public.user_daily_tasks for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users update own daily tasks" on public.user_daily_tasks;
create policy "Users update own daily tasks"
  on public.user_daily_tasks for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users read own progress" on public.user_progress;
create policy "Users read own progress"
  on public.user_progress for select
  to authenticated
  using (auth.uid() = user_id);

drop policy if exists "Users insert own progress" on public.user_progress;
create policy "Users insert own progress"
  on public.user_progress for insert
  to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users update own progress" on public.user_progress;
create policy "Users update own progress"
  on public.user_progress for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'batik-uploads',
  'batik-uploads',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public can read batik uploads" on storage.objects;
create policy "Public can read batik uploads"
  on storage.objects for select
  using (bucket_id = 'batik-uploads');

drop policy if exists "Users upload own batik images" on storage.objects;
create policy "Users upload own batik images"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'batik-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Users update own batik images" on storage.objects;
create policy "Users update own batik images"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'batik-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  )
  with check (
    bucket_id = 'batik-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Users delete own batik images" on storage.objects;
create policy "Users delete own batik images"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'batik-uploads'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

insert into public.batik_categories (
  id,
  name,
  history,
  philosophy,
  origin_region,
  image_url,
  facts
)
values
  (
    '11111111-1111-4111-8111-111111111111',
    'Parang',
    'Batik Parang dikenal sebagai salah satu motif klasik keraton Jawa. Pola miringnya berkembang di lingkungan istana dan kerap dipakai dalam upacara adat karena dianggap membawa wibawa serta keteguhan.',
    'Garis yang berulang melambangkan perjuangan tanpa putus, keberanian, dan konsistensi menjaga nilai baik dari generasi ke generasi.',
    'Jawa Tengah dan Yogyakarta',
    'assets/images/batik/parang.jpg',
    'Motif Parang memiliki banyak variasi, termasuk Parang Rusak dan Parang Barong.'
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'Bali',
    'Batik Bali berkembang melalui pertemuan tradisi lokal, alam, dan pengaruh budaya Hindu Bali. Motifnya sering memadukan flora, fauna, serta simbol ritual dalam warna yang berani.',
    'Motif Bali menekankan harmoni antara manusia, alam, dan spiritualitas melalui bentuk yang dinamis dan ekspresif.',
    'Bali',
    'assets/images/batik/bali.jpg',
    'Batik Bali sering tampil lebih bebas karena banyak dipakai sebagai ekspresi seni kontemporer.'
  ),
  (
    '33333333-3333-4333-8333-333333333333',
    'Kawung',
    'Batik Kawung merupakan motif tua yang tersusun dari bentuk elips menyerupai buah kawung. Motif ini populer di Jawa dan lama diasosiasikan dengan kesederhanaan serta pengendalian diri.',
    'Susunan simetrisnya melambangkan keseimbangan, kemurnian hati, dan kemampuan menata diri dalam kehidupan sosial.',
    'Jawa Tengah dan Yogyakarta',
    'assets/images/batik/kawung.jpg',
    'Bentuk Kawung juga sering ditafsirkan sebagai empat arah mata angin.'
  ),
  (
    '44444444-4444-4444-8444-444444444444',
    'Megamendung',
    'Megamendung berasal dari Cirebon dan mudah dikenali melalui bentuk awan bertingkat. Motif ini lahir dari jalur perdagangan pesisir yang mempertemukan budaya lokal dengan pengaruh luar.',
    'Awan yang teduh melambangkan kesabaran, keluasan hati, dan kemampuan meredakan emosi dalam keadaan sulit.',
    'Cirebon, Jawa Barat',
    'assets/images/batik/megamendung.jpg',
    'Gradasi warna pada Megamendung biasanya dibuat berlapis untuk memberi kesan kedalaman.'
  )
on conflict (id) do update set
  name = excluded.name,
  history = excluded.history,
  philosophy = excluded.philosophy,
  origin_region = excluded.origin_region,
  image_url = excluded.image_url,
  facts = excluded.facts;

insert into public.daily_tasks (
  id,
  task_key,
  title,
  description,
  xp_reward,
  category_name
)
values
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa1',
    'upload_photo',
    'Upload 1 foto batik',
    'Ambil atau pilih satu foto batik lalu simpan ke koleksi.',
    30,
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa2',
    'read_category',
    'Baca sejarah batik Parang',
    'Pelajari sejarah dan filosofi batik Parang.',
    30,
    'Parang'
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa3',
    'read_category',
    'Baca sejarah batik Bali',
    'Pelajari sejarah dan filosofi batik Bali.',
    30,
    'Bali'
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa4',
    'read_category',
    'Baca sejarah batik Kawung',
    'Pelajari sejarah dan filosofi batik Kawung.',
    30,
    'Kawung'
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa5',
    'read_category',
    'Baca sejarah batik Megamendung',
    'Pelajari sejarah dan filosofi batik Megamendung.',
    30,
    'Megamendung'
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa6',
    'open_encyclopedia',
    'Buka Encyclopedia',
    'Temukan kategori batik dan pilih topik untuk dipelajari.',
    30,
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa7',
    'login_today',
    'Login hari ini',
    'Masuk ke BatikQuest untuk menjaga ritme belajar.',
    30,
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa8',
    'learn_origin',
    'Pelajari batik dari daerah asalmu',
    'Prioritas task mengikuti daerah domisili pada profil.',
    30,
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaa9',
    'complete_2_activities',
    'Selesaikan 2 aktivitas pembelajaran',
    'Gabungkan upload, membaca encyclopedia, atau task harian.',
    30,
    null
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaa10',
    'upload_favorite',
    'Upload batik favoritmu',
    'Simpan foto batik favorit sebagai bagian dari eksplorasi.',
    30,
    null
  )
on conflict (id) do update set
  task_key = excluded.task_key,
  title = excluded.title,
  description = excluded.description,
  xp_reward = excluded.xp_reward,
  category_name = excluded.category_name;
