// 机场面板类型枚举
// 每种面板对应一个 JS bridge 脚本和登录页路径
enum PanelType {
  xboard('xboard-bridge.js', '/#/login'),
  v2board('v2board-bridge.js', '/#/login'),
  sspanel('sspanel-bridge.js', '/auth/login');

  final String jsAssetPath;
  final String loginPath;

  const PanelType(this.jsAssetPath, this.loginPath);

  /// 订阅 URL 拼接的 flag 参数
  /// Xboard 默认返回 v2ray base64 格式，需要 ?flag=meta 获取 Mihomo 配置
  String get subscribeFlag => switch (this) {
    PanelType.xboard => 'meta',
    PanelType.v2board => 'meta',
    PanelType.sspanel => 'clash',
  };
}
