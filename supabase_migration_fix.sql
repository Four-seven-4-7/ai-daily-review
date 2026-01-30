-- 1. 清理无法归属的旧数据（最稳妥的方案，防止报错）
-- 因为旧数据没有 user_id，无法适配新的多用户模型
TRUNCATE TABLE daily_reviews;

-- 2. 移除旧的主键
ALTER TABLE daily_reviews DROP CONSTRAINT IF EXISTS daily_reviews_pkey;

-- 3. 添加 user_id 字段
ALTER TABLE daily_reviews ADD COLUMN user_id uuid references auth.users(id) NOT NULL;

-- 4. 设置新的联合主键 (同一天，不同用户可以各自写复盘)
ALTER TABLE daily_reviews ADD PRIMARY KEY (date, user_id);

-- 5. 启用行级安全 (RLS)
ALTER TABLE daily_reviews ENABLE ROW LEVEL SECURITY;

-- 6. 删除旧策略（防止冲突）
DROP POLICY IF EXISTS "Enable all access for anon key" ON daily_reviews;
DROP POLICY IF EXISTS "Users can view their own reviews" ON daily_reviews;
DROP POLICY IF EXISTS "Users can insert their own reviews" ON daily_reviews;
DROP POLICY IF EXISTS "Users can update their own reviews" ON daily_reviews;

-- 7. 创建新策略：严格隔离，每个人只能增删改查自己的数据
CREATE POLICY "Users can view their own reviews" 
ON daily_reviews FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own reviews" 
ON daily_reviews FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews" 
ON daily_reviews FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reviews" 
ON daily_reviews FOR DELETE 
USING (auth.uid() = user_id);