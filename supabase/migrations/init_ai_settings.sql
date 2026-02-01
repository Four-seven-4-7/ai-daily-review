-- 1. 创建用户设置表
CREATE TABLE IF NOT EXISTS user_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. 开启 RLS
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

-- 3. 创建访问策略：允许所有用户读取配置 (为了简单起见，且是单用户工具，我们允许 public 读取)
-- 注意：在真实生产多用户环境中，应该限制只能读取属于自己的配置。
-- 但当前架构是单机设备ID模式，且 API Key 是预埋的全局配置，所以开放读取权限。
DROP POLICY IF EXISTS "Allow public read access" ON user_settings;
CREATE POLICY "Allow public read access" ON user_settings FOR SELECT USING (true);

-- 4. 插入 API Key (如果存在则更新)
INSERT INTO user_settings (key, value, description)
VALUES ('moonshot_api_key', 'ms-00ce24c6-49ad-46e3-84a6-5bf105f78cc1', 'Moonshot AI API Key for Daily Review Analysis')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;
