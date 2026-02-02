const { createClient } = require('@supabase/supabase-js');

// 1. 获取环境变量 (从 GitHub Secrets 注入)
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY; // 必须是 Service Role Key
const FEISHU_WEBHOOK = process.env.FEISHU_WEBHOOK;
const TARGET_DEVICE_ID = process.env.DEVICE_ID;

if (!SUPABASE_URL || !SUPABASE_KEY || !FEISHU_WEBHOOK || !TARGET_DEVICE_ID) {
  console.error('❌ 缺少必要的环境变量，请检查 GitHub Secrets 配置。');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function checkAndNotify() {
  try {
    // 2. 获取北京时间 (UTC+8) 的当前日期
    // GitHub Actions 运行在 UTC 时区
    const now = new Date();
    const beijingTime = new Date(now.getTime() + 8 * 60 * 60 * 1000);
    const today = beijingTime.toISOString().split('T')[0];

    console.log(`📅 正在检查日期: ${today} (用户: ${TARGET_DEVICE_ID})`);

    // 3. 查询数据库
    const { data, error } = await supabase
      .from('daily_reviews')
      .select('date')
      .eq('user_id', TARGET_DEVICE_ID)
      .eq('date', today)
      .maybeSingle();

    if (error) throw error;

    // 4. 如果有数据，直接结束
    if (data) {
      console.log('✅ 今日已复盘，无需提醒。');
      return;
    }

    // 5. 如果没数据，发送飞书提醒
    console.log('⚠️ 今日未复盘，正在发送提醒...');
    const response = await fetch(FEISHU_WEBHOOK, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        msg_type: 'text',
        content: {
          text: `🔔 **复盘提醒**\n\n今天是 ${today}，您还没有提交每日复盘。\n\n🌟 即使只有一句话，也值得被记录。\n\n👉 点击复盘: https://four-seven-4-7.github.io/ai-daily-review/`
        }
      })
    });

    const result = await response.json();
    console.log('📨 飞书响应:', JSON.stringify(result));

  } catch (err) {
    console.error('❌ 执行出错:', err);
    process.exit(1);
  }
}

checkAndNotify();
