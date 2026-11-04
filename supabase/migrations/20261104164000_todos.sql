create table public.todos (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  text text not null check (char_length(text) between 1 and 500),
  done boolean not null default false,
  created_at timestamptz not null default now()
);

create index todos_user_id_idx on public.todos (user_id, created_at);

alter table public.todos enable row level security;

create policy "Kendi görevlerini görür" on public.todos
  for select to authenticated using ((select auth.uid()) = user_id);

create policy "Kendi görevini ekler" on public.todos
  for insert to authenticated with check ((select auth.uid()) = user_id);

create policy "Kendi görevini günceller" on public.todos
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Kendi görevini siler" on public.todos
  for delete to authenticated using ((select auth.uid()) = user_id);
