-- ご意見板テーブル
create table public.feedback (
  id         bigint generated always as identity primary key,
  name       text not null check (char_length(btrim(name)) between 1 and 50),
  message    text not null check (char_length(btrim(message)) between 1 and 1000),
  created_at timestamptz not null default now()
);

-- 新しい順の一覧取得用
create index feedback_created_at_idx on public.feedback (created_at desc);

-- Row Level Security を有効化
alter table public.feedback enable row level security;

-- 誰でも閲覧できる（ご意見板として一覧表示するため）
create policy "feedback_select_anon"
  on public.feedback for select
  to anon, authenticated
  using (true);

-- 誰でも投稿できる
create policy "feedback_insert_anon"
  on public.feedback for insert
  to anon, authenticated
  with check (true);

-- update / delete のポリシーは作らない（= 匿名ユーザーは編集・削除不可）
