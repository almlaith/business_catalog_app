import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:flutter/material.dart';

class AuroraRefreshWrapper extends StatefulWidget {
  const AuroraRefreshWrapper({
    required this.child,
    required this.onRefresh,
    this.showFailureFeedback = true,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onRefresh;
  final bool showFailureFeedback;

  @override
  State<AuroraRefreshWrapper> createState() => _AuroraRefreshWrapperState();
}

class _AuroraRefreshWrapperState extends State<AuroraRefreshWrapper> {
  Future<void>? _activeRefresh;

  Future<void> _refresh() {
    final activeRefresh = _activeRefresh;
    if (activeRefresh != null) {
      return activeRefresh;
    }

    Future<void> runRefresh() async {
      try {
        await widget.onRefresh();
      } catch (error) {
        if (!mounted) {
          return;
        }

        if (widget.showFailureFeedback) {
          // The visible content is intentionally preserved; this only reports
          // that the local catalog/configuration could not be re-read.
          showAppFeedback(
            context,
            type: AppFeedbackType.error,
            title: context.l10n.refreshFailedTitle,
            message: context.l10n.refreshFailedMessage,
          );
        }
      }
    }

    final refresh = runRefresh().whenComplete(() {
      if (mounted) {
        _activeRefresh = null;
      }
    });

    _activeRefresh = refresh;
    return refresh;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator.adaptive(
      onRefresh: _refresh,
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      displacement: AppSpacing.xxxl,
      edgeOffset: AppSpacing.sm,
      child: widget.child,
    );
  }
}
