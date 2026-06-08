# 提案：对接 Xboard 机场面板 — WebView + JS Bridge 方案

## 是什么

通过 WebView + 内置 JS Bridge 的方式对接 Xboard（及未来的 V2Board/SSPanel）机场面板，实现用户登录即自动获取订阅配置。参考 Karing 方案A（快捷绑定），无需机场部署任何文件。

## 为什么

当前 FlClash 的订阅导入完全依赖用户手动输入 URL 或扫描文件，没有与机场面板的直接集成。对接机场面板后：

- 用户只需输入机场地址，在 WebView 中登录即可自动导入订阅
- 支持机场原生登录 UI（验证码、2FA 等自动兼容）
- 可展示用户流量、到期时间等信息
- 为后续多面板支持（V2Board/SSPanel）建立可扩展的架构

## 哪里

### 新增文件

```
lib/
├── services/panel/
│   ├── panel_bridge.dart              # WebView JS Bridge 通信封装
│   └── panel_type.dart                # PanelType 枚举 + JS 脚本映射
├── assets/js/
│   ├── xboard-bridge.js               # Xboard 专用：token 拦截 + API 调用
│   ├── v2board-bridge.js              # 占位：V2Board 专用
│   └── sspanel-bridge.js              # 占位：SSPanel 专用
├── models/panel_auth.dart             # 认证状态 freezed model
├── providers/panel_auth.dart          # Riverpod 认证状态 provider
└── views/login/
    ├── login_screen.dart              # 登录页（输入机场地址 → 打开 WebView）
    └── panel_webview.dart             # WebView 容器页面
```

### 修改文件

| 文件 | 变更内容 |
|------|---------|
| `pubspec.yaml` | 添加 `webview_flutter` 依赖，配置 assets/js 目录 |
| `lib/enum/enum.dart` | 新增 `PanelType` 枚举 |
| `lib/common/preferences.dart` | 增加 panel auth token/serverUrl 存取方法 |
| `lib/application.dart` | 启动时检查 panel auth 状态，分流 LoginScreen / HomePage |
| `lib/providers/action.dart` | `ProfilesAction` 增加 panel 订阅关联（token 过期重获取） |
| `lib/views/profiles/profiles.dart` | Profile 卡片展示面板用户信息（流量/到期） |
| `lib/widgets/subscription_info_view.dart` | 增强展示面板用户数据 |
| `lib/state.dart` | globalState 增加 panel auth 状态 |
| `arb/*.arb` | 登录页相关多语言字符串（en/zh_CN/ja/ru） |

## 怎么做

### 核心流程

```
App 启动
  → SP 有 auth_data+serverUrl?
    → YES: checkLogin API 验证 → 有效: HomePage / 无效: LoginScreen
    → NO: LoginScreen
      → 用户输入机场地址 → 点击"连接机场"
      → 打开 WebView 加载 {serverUrl}/#/login
      → 注入 xboard-bridge.js
      → 用户在机场原生 UI 中登录
      → JS 检测到 auth_data（轮询 localStorage['authorization']）
      → JS 调 getSubscribe API
      → JS 通过 FlClashBridge channel 传回数据
      → Flutter: saveAuth + addProfileFormURL(subscribeUrl + "?flag=meta") + 跳转 HomePage
```

### 注入 JS 核心逻辑（xboard-bridge.js）

基于实测数据（详见 [api-spec.md](api-spec.md)），核心逻辑：

```javascript
const _flclash = {
  timer: null,

  start() {
    this.timer = setInterval(() => {
      // Xboard 前端登录后存入 localStorage 的 key 是 'authorization'
      // 值为 "Bearer xxx" 格式
      const auth = localStorage.getItem('authorization');
      if (auth) {
        clearInterval(this.timer);
        this.onLogin(auth);
      }
    }, 500);
  },

  async onLogin(authData) {
    try {
      // 获取订阅信息（包含流量数据）
      const resp = await fetch('/api/v1/user/getSubscribe', {
        headers: { 'Authorization': authData }
      });
      const json = await resp.json();

      if (json.status !== 'success') {
        FlClashBridge.postMessage(JSON.stringify({
          type: 'error', message: json.message
        }));
        return;
      }

      const data = json.data;
      // subscribe_url 需要 ?flag=meta 获取 Mihomo 格式配置
      const subscribeUrl = data.subscribe_url + '?flag=meta';

      FlClashBridge.postMessage(JSON.stringify({
        type: 'login_success',
        auth_data: authData,           // "Bearer xxx" 用于后续 API 调用
        subscribe_url: subscribeUrl,
        token: data.token,             // 订阅 token (用于构造 subscribe_url)
        user_info: {
          email: data.email,
          upload: data.u,              // bytes
          download: data.d,            // bytes
          transfer_enable: data.transfer_enable, // bytes
          expired_at: data.expired_at, // null = 永不过期
          plan_name: data.plan?.name,
          device_limit: data.plan?.device_limit,
        }
      }));
    } catch (e) {
      FlClashBridge.postMessage(JSON.stringify({
        type: 'error', message: e.message
      }));
    }
  }
};

_flclash.start();
```

### 面板类型抽象

```dart
enum PanelType {
  xboard('xboard_bridge.js', '/#/login'),
  v2board('v2board_bridge.js', '/#/login'),    // 占位
  sspanel('sspanel_bridge.js', '/auth/login');  // 占位

  final String jsAssetPath;
  final String loginPath;
}
```

每种面板只需一个 JS 文件 + 一个枚举值，不需要改 Dart 代码。

### 认证状态模型（PanelAuth）

```dart
@freezed
class PanelAuth with _$PanelAuth {
  const factory PanelAuth({
    required String serverUrl,
    String? authData,            // "Bearer xxx" — API 鉴权用
    String? token,               // 订阅 token — 构造 subscribe_url 用
    String? subscribeUrl,        // 完整订阅 URL (含 ?flag=meta)
    PanelUserInfo? userInfo,
    @Default(PanelType.xboard) PanelType panelType,
  }) = _PanelAuth;
}

@freezed
class PanelUserInfo with _$PanelUserInfo {
  const factory PanelUserInfo({
    @Default(0) int transferEnable,  // bytes
    @Default(0) int upload,          // bytes
    @Default(0) int download,        // bytes
    int? expiredAt,                  // unix timestamp, null=永不过期
    String? planName,
    String? email,
    int? deviceLimit,
  }) = _PanelUserInfo;
}
```

### 订阅 URL 格式（实测确认）

| flag 参数 | Content-Type | 格式 | FlClash 使用？ |
|-----------|-------------|------|---------------|
| (无) | text/plain | base64 v2ray | ❌ |
| `clash` | text/yaml | Clash YAML | ⚠️ 可用但非最优 |
| **`meta`** | text/yaml | Mihomo/Meta YAML | **✅ 推荐** |

FlClash 基于 Mihomo 内核，订阅 URL 应拼接 `?flag=meta`。

### 登录页 UI 布局

```
┌─────────────────────────────┐
│       App Logo               │
│                              │
│  ┌─────────────────────┐     │
│  │ 🌐 机场地址          │     │
│  └─────────────────────┘     │
│                              │
│  ┌─────────────────────┐     │
│  │    连接机场          │     │  → 打开 WebView
│  └─────────────────────┘     │
│                              │
│  ─── 或手动导入 ───          │
│  ┌─────────────────────┐     │
│  │ 📋 粘贴订阅链接      │     │
│  └─────────────────────┘     │
└─────────────────────────────┘
```

### Profiles 页增强

Profile 卡片增加面板用户信息展示：

```
┌──────────────────────────────────┐
│ ● 我的订阅                    ⋮  │
│                                  │
│ ████████████░░░░  3.51GB / 100GB│  ← 流量进度条
│ 到期时间: 永不过期                │  ← expired_at=null
│ 套餐: ⛽ 基础套餐                │
│                                  │
│ 上次更新: 3分钟前                 │
└──────────────────────────────────┘
```

### Token 过期处理

```
现有 autoUpdateProfiles()
  → Profile.update() 失败 (HTTP 401/403)
  → 检测到 panel auth 关联的 Profile
  → 清除 SP 中的 auth_data
  → 跳转 LoginScreen 重新登录
```

### Xboard 实测 API 摘要

| API | 方法 | 鉴权 | 关键返回字段 |
|-----|------|------|-------------|
| `/api/v1/passport/auth/login` | POST | 无 | `token`, `auth_data`("Bearer xxx"), `is_admin` |
| `/api/v1/user/getSubscribe` | GET | Authorization: Bearer xxx | `subscribe_url`, `u`, `d`, `transfer_enable`, `expired_at`, `plan` |
| `/api/v1/user/info` | GET | Authorization: Bearer xxx | `email`, `transfer_enable`, `expired_at`, `balance` |
| `/api/v1/user/checkLogin` | GET | Authorization: Bearer xxx | `is_login` |
| `/api/v1/guest/comm/config` | GET | 无 | `is_captcha`, `app_description`, `logo` |
| `/sub/{token}?flag=meta` | GET | 无 | Mihomo YAML 配置 + `subscription-userinfo` header |

完整 API 规格见 [api-spec.md](api-spec.md)。

### 新增依赖

```yaml
webview_flutter: ^4.10.0
# 平台实现自动引入:
# - webview_flutter_android
# - webview_flutter_wkwebview (iOS/macOS)
# - webview_flutter_webview2 (Windows)

# pubspec.yaml assets 配置
flutter:
  assets:
    - assets/js/
```

## 风险

| 风险 | 影响 | 缓解 |
|------|------|------|
| Windows WebView2 在旧系统上不可用 | 登录页无法打开 | 启动时检测 WebView2 可用性，不可用时 fallback 显示提示安装 |
| Xboard 不同主题 localStorage key 不同 | JS 无法提取 token | JS 中做多 key 兼容检测（`authorization`、`token`、`auth_token`） |
| Token 过期后订阅更新 401 | 用户无法更新配置 | catch 401 → 跳转 LoginScreen 重新登录 |
| 桌面端 WebView 弹窗体验 | 全屏 WebView 可能突兀 | 可设计为内嵌式而非弹窗，添加 loading 状态过渡 |
| Xboard ≤0.1.9 认证绕过漏洞 ([CVE-2026-39912](https://github.com/Chocopikk/CVE-2026-39912)) | 安全风险 | 客户端侧无法修复，建议用户确认机场版本 |
| `auth_data` 每次登录不同（动态） | SP 保存的 auth_data 可能频繁过期 | 定期 checkLogin 检测，过期自动引导重新登录 |

## 非目标

- 不做多机场账号支持（单机场，地址占位）
- 不做注册功能（注册引导到浏览器 `url_launcher`）
- 不做 V2Board/SSPanel 的实际实现（仅留占位和抽象接口）
- 不修改 Xboard 面板端代码（零部署原则）

## 参考

- [Karing 方案A：快捷绑定 Xboard](https://karing.app/en/cooperation/xboard) — 核心参考
- [karing-connect 仓库](https://github.com/KaringX/karing-connect) — JS bridge 实现
- [karing.js 源码](https://github.com/KaringX/karing-connect/blob/main/karing.js) — bridge 通信协议
- [Xboard API 文档](https://github.com/cedar2025/Xboard/issues/553) — API 端点参考
- [api-spec.md](api-spec.md) — 实测 API 响应规格
