-- 1. 修改表结构：移除原有的主键约束（因为不同用户可能在同一天复盘），并添加 user_id
-- 注意：如果表里已有数据，我们需要先处理一下。这里假设我们要保留现有数据并归属给第一个注册的用户，或者你可以清空表。
-- 稳妥起见，我们先修改主键逻辑。

-- 移除旧的主键 (date)
ALTER TABLE daily_reviews DROP CONSTRAINT daily_reviews_pkey;

-- 添加 user_id 字段，默认为当前操作用户的 ID (如果有的话)，设为不可空需要谨慎，先设为可空然后填充
ALTER TABLE daily_reviews ADD COLUMN user_id uuid references auth.users(id);

-- 将 user_id 设为新的联合主键的一部分 (date, user_id)
-- 这样不同用户可以在同一天有各自的记录
ALTER TABLE daily_reviews ADD PRIMARY KEY (date, user_id);

-- 2. 启用行级安全 (RLS)
ALTER TABLE daily_reviews ENABLE ROW LEVEL SECURITY;

-- 3. 删除旧的“允许所有”策略
DROP POLICY IF EXISTS "Enable all access for anon key" ON daily_reviews;

-- 4. 创建新策略：每个人只能看自己的数据
CREATE POLICY "Users can view their own reviews" 
ON daily_reviews FOR SELECT 
USING (auth.uid() = user_id);

-- 5. 创建新策略：每个人只能插入/更新自己的数据
CREATE POLICY "Users can insert their own reviews" 
ON daily_reviews FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews" 
ON daily_reviews FOR UPDATE 
USING (auth.uid() = user_id);

-- 6. 自动填充 user_id 的触发器 (可选，但在前端传值更简单，这里作为双重保障)
-- 这一步对于简单应用可以省略，我们将在前端代码里显式传递 user_id 或让 Supabase 自动推断
