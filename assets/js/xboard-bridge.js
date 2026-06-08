/**
 * Xboard panel bridge for FlClash
 *
 * 注入到 WebView 中，完成以下任务:
 * 1. 轮询 localStorage 中的 authorization token（用户登录后 Xboard 前端存入）
 * 2. 登录成功后调用 getSubscribe API 获取订阅 URL 和用户信息
 * 3. 通过 FlClashBridge JavaScript channel 将数据传回 Flutter
 *
 * 数据流: Xboard 登录 → localStorage['VUE_NAIVE_ACCESS_TOKEN'] → getSubscribe API → FlClashBridge
 *
 * 注意: Xboard 使用 NaiveUI 框架，token 存储在 VUE_NAIVE_ACCESS_TOKEN 中，
 * 格式为 JSON: {"value": "Bearer xxx", "time": ..., "expire": ...}
 */
const _flclash = {
  timer: null,
  // 最多轮询 120 秒 (240 * 500ms)
  maxPolls: 240,
  pollCount: 0,

  start() {
    // 通知 Flutter: bridge 已就绪
    this.send('bridge_ready', {});

    this.timer = setInterval(() => {
      this.pollCount++;
      if (this.pollCount > this.maxPolls) {
        clearInterval(this.timer);
        this.send('timeout', { message: 'Login timeout' });
        return;
      }

      // Xboard (NaiveUI) 登录后存入 localStorage 的 key 是 'VUE_NAIVE_ACCESS_TOKEN'
      // 值为 JSON 字符串: {"value":"Bearer xxx","time":...,"expire":...}
      const tokenJson = localStorage.getItem('VUE_NAIVE_ACCESS_TOKEN');
      if (tokenJson) {
        try {
          const parsed = JSON.parse(tokenJson);
          const authData = parsed.value;
          if (authData) {
            clearInterval(this.timer);
            this.onLogin(authData);
          }
        } catch (e) {
          console.error('[FlClash] Failed to parse token JSON:', e);
        }
      }
    }, 500);
  },

  async onLogin(authData) {
    try {
      const resp = await fetch('/api/v1/user/getSubscribe', {
        headers: { 'Authorization': authData }
      });
      const json = await resp.json();

      if (json.status !== 'success') {
        this.send('error', { message: json.message || 'getSubscribe failed' });
        return;
      }

      const data = json.data;
      // subscribe_url 需要 ?flag=meta 获取 Mihomo 格式配置
      const subscribeUrl = data.subscribe_url
        ? data.subscribe_url + '?flag=meta'
        : '';

      this.send('login_success', {
        auth_data: authData,
        subscribe_url: subscribeUrl,
        token: data.token,
        user_info: {
          email: data.email || '',
          upload: data.u || 0,
          download: data.d || 0,
          transfer_enable: data.transfer_enable || 0,
          expired_at: data.expired_at,
          plan_name: data.plan ? data.plan.name : null,
          device_limit: data.plan ? data.plan.device_limit : null,
        }
      });
    } catch (e) {
      this.send('error', { message: e.message || 'Unknown error' });
    }
  },

  send(type, data) {
    try {
      FlClashBridge.postMessage(JSON.stringify({
        type: type,
        data: data,
        timestamp: Date.now()
      }));
    } catch (e) {
      console.error('[FlClash] Failed to send message:', e);
    }
  },

  stop() {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }
};

_flclash.start();
