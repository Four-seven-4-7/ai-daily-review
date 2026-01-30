-- Create daily_reviews table
create table if not exists daily_reviews (
  date date primary key,
  content jsonb not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Enable RLS
alter table daily_reviews enable row level security;

-- Create policy for public access (anon key)
create policy "Public access" on daily_reviews
for all using (true) with check (true);
