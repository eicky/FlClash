# Xboard API 实测规格

基于 https://mirrors.ndjp.net/ (Xboard, 版本 20260602) 实际抓取。

## 1. 登录

```
POST /api/v1/passport/auth/login
Content-Type: application/json

Request:
{ "email": "support@mirrors.ndjp.net", "password": "xxx" }

Response (200):
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "token": "91ec6e6ad72d4403d125b90f870b174d",        // 订阅 token (用于 subscribe_url)
    "auth_data": "Bearer 9IbLqIqUZFp4GOCh0NoXJvBccwmT8UTKbho3ktm6794f674e",  // API 鉴权
    "is_admin": false
  }
}
```

**关键发现：**
- `data.token` — 用于构造订阅 URL（`/sub/{token}`），不是 API 鉴权
- `data.auth_data` — `Bearer xxx`，用于 API 请求的 Authorization header
- 两次登录 `auth_data` 不同（动态生成），但 `token` 相同（用户级别固定）
- Xboard 前端把 `auth_data` 存入 `localStorage`，key 为 `authorization`

## 2. 获取订阅信息

```
GET /api/v1/user/getSubscribe
Authorization: Bearer {auth_data}

Response (200):
{
  "status": "success",
  "data": {
    "plan_id": 1,
    "token": "91ec6e6ad72d4403d125b90f870b174d",
    "expired_at": null,                              // null = 永不过期
    "u": 26116093,                                   // 已上传 (bytes)
    "d": 3743025979,                                 // 已下载 (bytes)
    "transfer_enable": 107374182400,                  // 总流量 (bytes) = 100GB
    "email": "support@mirrors.ndjp.net",
    "uuid": "5b968b13-de48-4c40-a031-2858630e9452",
    "device_limit": null,
    "speed_limit": null,
    "next_reset_at": null,
    "plan": {
      "id": 1,
      "name": "⛽　基础套餐",
      "transfer_enable": 100,                         // GB
      "device_limit": 3,
      "prices": {
        "monthly": "80.00",
        "half_yearly": "432.00",
        "yearly": "816.00"
      }
    },
    "subscribe_url": "https://mirrors.ndjp.net/sub/91ec6e6ad72d4403d125b90f870b174d",
    "reset_day": null
  }
}
```

**关键发现：**
- `subscribe_url` 是订阅链接，直接可用于 `addProfileFormURL()`
- 默认返回 v2ray 格式 (base64)，需要加 `?flag=clash` 或 `?flag=meta` 获取 Clash/Meta 格式
- 流量信息也在此接口返回（u/d/transfer_enable），可以不用单独调 getUserInfo

## 3. 订阅内容格式

### 默认（无 flag）
```
GET /sub/{token}
Content-Type: text/plain
subscription-userinfo: upload=26116093; download=3743025979; total=107374182400; expire=

返回: base64 编码的 v2ray 节点列表
```

### Clash 格式
```
GET /sub/{token}?flag=clash
Content-Type: text/yaml
content-disposition: attachment;filename*=UTF-8''Mirrors
subscription-userinfo: upload=26116093; download=3743025979; total=107374182400; expire=
profile-update-interval: 24

返回: Clash YAML 配置 (proxies, proxy-groups, rules)
```

### Meta 格式（Clash.Meta / Mihomo）
```
GET /sub/{token}?flag=meta
Content-Type: text/yaml
返回: Meta 格式 YAML 配置（内容比 clash 更丰富）
```

**FlClash 使用 Mihomo 内核，应该用 `?flag=meta` 获取配置。**

### HTTP Headers（所有格式通用）
| Header | 含义 | 示例值 |
|--------|------|--------|
| `subscription-userinfo` | 流量信息 | `upload=26116093; download=3743025979; total=107374182400; expire=` |
| `content-disposition` | 配置文件名 | `attachment;filename*=UTF-8''Mirrors` |
| `profile-update-interval` | 建议更新间隔(小时) | `24` |

`subscription-userinfo` 中的 `expire=` 为空表示永不过期。

## 4. 获取用户信息

```
GET /api/v1/user/info
Authorization: Bearer {auth_data}

Response (200):
{
  "status": "success",
  "data": {
    "email": "support@mirrors.ndjp.net",
    "transfer_enable": 107374182400,
    "last_login_at": 1780904567,
    "created_at": 1779854759,
    "banned": false,
    "remind_expire": true,
    "remind_traffic": true,
    "expired_at": null,
    "balance": 0,
    "commission_balance": 0,
    "plan_id": 1,
    "discount": null,
    "commission_rate": null,
    "telegram_id": null,
    "uuid": "5b968b13-de48-4c40-a031-2858630e9452",
    "avatar_url": "https://cdn.v2ex.com/gravatar/..."
  }
}
```

## 5. 检查登录状态

```
GET /api/v1/user/checkLogin
Authorization: Bearer {auth_data}

Response (200):
{
  "status": "success",
  "data": { "is_login": true }
}
```

## 6. 站点公开配置

```
GET /api/v1/guest/comm/config

Response (200):
{
  "status": "success",
  "data": {
    "tos_url": "https://mirrors.ndjp.net/terms",
    "is_email_verify": 1,
    "is_invite_force": 0,
    "email_whitelist_suffix": ["qq.com","gmail.com","outlook.com",...],
    "is_captcha": 0,
    "captcha_type": "turnstile",
    "turnstile_site_key": "0x4AAAAAADWpBHTad_gsGxvp",
    "app_description": "❤️",
    "app_url": null,
    "logo": null
  }
}
```

**注意：`is_captcha: 0` 表示当前未启用验证码，但 `captcha_type: turnstile` 说明支持 Cloudflare Turnstile。**

## 7. 前端页面结构

Xboard 前端是 Vue SPA（Umi.js），入口：
```html
<script type="module" crossorigin src="/theme/Xboard/assets/umi.js"></script>
<script>
  window.settings = {
    title: 'Mirrors',
    assets_path: '/theme/Xboard/assets',
    version: '20260602-5b573f7',
    ...
  }
</script>
```

登录后 token 存储方式（从 Karing custom.js 分析 + 前端源码确认）：
- `localStorage.setItem('authorization', auth_data)` — Bearer token
- 登录页路由：`/#/login`
- 注册页路由：`/#/register`

## JS Bridge 注入策略

基于以上实测数据，xboard-bridge.js 需要：

1. **轮询 `localStorage.getItem('authorization')`** — 检测用户登录
2. **登录后调 `fetch('/api/v1/user/getSubscribe', { headers: { Authorization: token } })`**
3. **从 response 中提取 `subscribe_url`**
4. **subscribe_url 需要加 `?flag=meta`** 才能获取 Mihomo 格式配置
5. **通过 `FlClashBridge.postMessage()` 传回 Flutter**
6. **同时提取流量信息**（u/d/transfer_enable/expired_at/plan）用于展示
