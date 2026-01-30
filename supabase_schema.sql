-- 在 Supabase 的 SQL Editor 中运行此语句以创建表

create table daily_reviews (
  date date primary key,
  content jsonb not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- 开启行级安全策略 (虽然单人使用，但作为最佳实践建议开启)
alter table daily_reviews enable row level security;

-- 创建策略：允许匿名用户(持有 anon key) 进行所有操作
-- 注意：这意味着任何拥有你 anon key 的人都可以读写你的数据。
-- 对于个人本地使用的工具，这通常是可以接受的，只要你不泄露 key。
create policy "Enable all access for anon key" on daily_reviews
for all using (true) with check (true);
