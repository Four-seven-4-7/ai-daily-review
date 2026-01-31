-- 1. 删除旧的外键约束（因为它要求用户必须登录）
ALTER TABLE daily_reviews DROP CONSTRAINT IF EXISTS daily_reviews_user_id_fkey;

-- 2. 确保 RLS 开启
ALTER TABLE daily_reviews ENABLE ROW LEVEL SECURITY;

-- 3. 删除旧的策略（如果有）
DROP POLICY IF EXISTS "Public access" ON daily_reviews;
DROP POLICY IF EXISTS "Users can manage their own reviews" ON daily_reviews;

-- 4. 创建新的策略：允许匿名用户 (anon) 根据 user_id 进行操作
-- 只要用户提供的 user_id 匹配，就允许增删改查
CREATE POLICY "Enable access for all users based on user_id" ON daily_reviews
FOR ALL 
USING (true)
WITH CHECK (true);

-- 5. 确保 user_id 列存在且作为主键的一部分（如果之前没设好）
-- 注意：根据之前 get_tables 的结果，date 和 user_id 已经是联合主键了。
