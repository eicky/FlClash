import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter/material.dart';

class SubscriptionInfoView extends StatelessWidget {
  final SubscriptionInfo? subscriptionInfo;

  const SubscriptionInfoView({super.key, this.subscriptionInfo});

  @override
  Widget build(BuildContext context) {
    if (subscriptionInfo == null) {
      return Container();
    }
    if (subscriptionInfo?.total == 0) {
      return Container();
    }
    final use = subscriptionInfo!.upload + subscriptionInfo!.download;
    final total = subscriptionInfo!.total;
    final progress = use / total;

    final useShow = use.traffic.show;
    final totalShow = total.traffic.show;
    final expireShow =
        subscriptionInfo?.expire != null && subscriptionInfo!.expire != 0
        ? DateTime.fromMillisecondsSinceEpoch(
            subscriptionInfo!.expire * 1000,
          ).show
        : context.appLocalizations.infiniteTime;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          minHeight: 6,
          value: progress,
          backgroundColor: context.colorScheme.primary.opacity15,
        ),
        const SizedBox(height: 8),
        Text(
          '$useShow / $totalShow · $expireShow',
          style: context.textTheme.labelMedium?.toLight,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// 面板用户信息展示 — 从 PanelAuth 获取流量、到期、套餐信息
class PanelUserInfoView extends StatelessWidget {
  final PanelAuth panelAuth;

  const PanelUserInfoView({super.key, required this.panelAuth});

  @override
  Widget build(BuildContext context) {
    final userInfo = panelAuth.userInfo;
    if (userInfo == null) return const SizedBox.shrink();

    final totalBytes = panelAuth.totalBytes;
    final usedBytes = panelAuth.usedBytes;
    final progress = totalBytes > 0 ? usedBytes / totalBytes : 0.0;

    final usedShow = usedBytes.traffic.show;
    final totalShow = totalBytes.traffic.show;
    final expireShow = panelAuth.isNeverExpire
        ? context.appLocalizations.infiniteTime
        : panelAuth.expiredAtDate?.show ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          minHeight: 6,
          value: progress.clamp(0.0, 1.0),
          backgroundColor: context.colorScheme.primary.opacity15,
        ),
        const SizedBox(height: 8),
        Text(
          '$usedShow / $totalShow',
          style: context.textTheme.labelMedium?.toLight,
        ),
        const SizedBox(height: 2),
        if (userInfo.planName != null)
          Text(
            '${userInfo.planName}',
            style: context.textTheme.labelSmall?.toLighter,
          ),
        const SizedBox(height: 2),
        Text(
          '${context.appLocalizations.infiniteTime == expireShow ? "永不过期" : "到期: $expireShow"}',
          style: context.textTheme.labelSmall?.toLighter,
        ),
      ],
    );
  }
}
