import 'dart:async';

import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';

enum AppFeedbackType { success, error, warning, info }

_FeedbackHandle? _activeFeedback;

void showAppFeedback(
  BuildContext context, {
  required AppFeedbackType type,
  required String title,
  required String message,
  SnackBarAction? action,
}) {
  _activeFeedback?.dismiss();

  final overlay = Overlay.of(context, rootOverlay: true);
  late final _FeedbackHandle handle;
  late final OverlayEntry entry;

  handle = _FeedbackHandle();
  entry = OverlayEntry(
    builder: (overlayContext) => _TopFeedbackBanner(
      type: type,
      title: title,
      message: message,
      action: action,
      onDismiss: handle.dismiss,
    ),
  );
  handle.entry = entry;
  _activeFeedback = handle;
  overlay.insert(entry);
}

class _FeedbackHandle {
  OverlayEntry? entry;
  var _dismissed = false;

  void dismiss() {
    if (_dismissed) {
      return;
    }
    _dismissed = true;
    entry?.remove();
    if (identical(_activeFeedback, this)) {
      _activeFeedback = null;
    }
  }
}

class _TopFeedbackBanner extends StatefulWidget {
  const _TopFeedbackBanner({
    required this.type,
    required this.title,
    required this.message,
    required this.onDismiss,
    this.action,
  });

  final AppFeedbackType type;
  final String title;
  final String message;
  final VoidCallback onDismiss;
  final SnackBarAction? action;

  @override
  State<_TopFeedbackBanner> createState() => _TopFeedbackBannerState();
}

class _TopFeedbackBannerState extends State<_TopFeedbackBanner> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2800), widget.onDismiss);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final feedbackStyle = _styleFor(widget.type, colorScheme);
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 8;
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);

    return PositionedDirectional(
      top: topOffset,
      start: AppSpacing.lg,
      end: AppSpacing.lg,
      child: SafeArea(
        top: false,
        bottom: false,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: reduceMotion ? Duration.zero : AppDurations.medium,
          curve: AuroraMotion.curve,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, -18 * (1 - value)),
              child: child,
            ),
          ),
          child: Dismissible(
            key: ValueKey(
              'top-feedback-${DateTime.now().microsecondsSinceEpoch}',
            ),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismiss(),
            child: Material(
              color: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    feedbackStyle.accent.withValues(
                      alpha: theme.brightness == Brightness.dark ? 0.18 : 0.10,
                    ),
                    colorScheme.surface,
                  ),
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                  border: Border.all(
                    color: feedbackStyle.accent.withValues(alpha: 0.28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.26),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: feedbackStyle.accent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        child: Icon(
                          feedbackStyle.icon,
                          color: feedbackStyle.accent,
                          size: AppIconSizes.md,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              widget.message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (widget.action != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton(
                                  onPressed: () {
                                    widget.onDismiss();
                                    widget.action!.onPressed();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: feedbackStyle.accent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                    ),
                                    minimumSize: const Size(0, 34),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(widget.action!.label),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).closeButtonTooltip,
                        onPressed: widget.onDismiss,
                        icon: const Icon(Icons.close_rounded),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _FeedbackStyle _styleFor(AppFeedbackType type, ColorScheme colorScheme) {
    return switch (type) {
      AppFeedbackType.success => const _FeedbackStyle(
        accent: AuroraColors.success,
        icon: Icons.check_circle_rounded,
      ),
      AppFeedbackType.error => const _FeedbackStyle(
        accent: AuroraColors.error,
        icon: Icons.error_rounded,
      ),
      AppFeedbackType.warning => const _FeedbackStyle(
        accent: AuroraColors.warning,
        icon: Icons.warning_rounded,
      ),
      AppFeedbackType.info => _FeedbackStyle(
        accent: colorScheme.secondary,
        icon: Icons.info_rounded,
      ),
    };
  }
}

class _FeedbackStyle {
  const _FeedbackStyle({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;
}
