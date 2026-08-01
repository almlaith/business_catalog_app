import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_constants.dart';
import 'package:business_catalog_app/core/constants/app_route_paths.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:business_catalog_app/core/widgets/app_async_state.dart';
import 'package:business_catalog_app/core/widgets/app_feedback.dart';
import 'package:business_catalog_app/core/widgets/app_skeleton.dart';
import 'package:business_catalog_app/core/widgets/aurora_background.dart';
import 'package:business_catalog_app/core/widgets/aurora_components.dart';
import 'package:business_catalog_app/core/widgets/aurora_refresh.dart';
import 'package:business_catalog_app/core/widgets/bidi_safe_text.dart';
import 'package:business_catalog_app/features/catalog/data/catalog_providers.dart';
import 'package:business_catalog_app/features/checkout/application/whatsapp_order_launcher.dart';
import 'package:business_catalog_app/models/business_config.dart';
import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:business_catalog_app/services/external_link_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogDataProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.helpSupportTitle)),
      body: AuroraBackground(
        bottomSafeGlow: true,
        child: SafeArea(
          child: catalogState.when(
            skipLoadingOnRefresh: true,
            skipError: true,
            loading: () => const AppSkeletonHelpSupport(),
            error: (error, stackTrace) => AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(catalogDataProvider),
            ),
            data: (catalog) => AuroraRefreshWrapper(
              onRefresh: () => ref.refresh(catalogDataProvider.future),
              child: _HelpSupportContent(business: catalog.business),
            ),
          ),
        ),
      ),
    );
  }
}

class _HelpSupportContent extends ConsumerWidget {
  const _HelpSupportContent({required this.business});

  final BusinessConfig business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return ListView(
      key: const ValueKey('help-support-scroll-view'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        132,
      ),
      children: [
        _SupportHeader(business: business),
        const SizedBox(height: AppSpacing.lg),
        AuroraCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuroraSectionHeader(
                title: l10n.quickSupportActions,
                subtitle: l10n.quickSupportActionsDescription,
                action: const AuroraIconContainer(
                  icon: Icons.bolt_rounded,
                  size: 42,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ..._supportActions(context, ref).expand(
                (action) => [action, const SizedBox(height: AppSpacing.sm)],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _FaqAccordion(),
        const SizedBox(height: AppSpacing.lg),
        _OrderFlowCard(),
        const SizedBox(height: AppSpacing.lg),
        _TroubleshootingCard(),
        const SizedBox(height: AppSpacing.lg),
        AuroraCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuroraSectionHeader(
                title: l10n.applicationInformation,
                subtitle: l10n.businessApplicationDescription(
                  business.businessName,
                ),
                action: const AuroraIconContainer(
                  icon: Icons.info_outline_rounded,
                  size: 42,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoPill(
                label: l10n.applicationInformation,
                value: business.businessName,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoPill(label: l10n.appVersion, value: AppConstants.appVersion),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _supportActions(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final actions = <Widget>[];

    if (business.phoneNumber.trim().isNotEmpty) {
      actions.add(
        AuroraSupportActionCard(
          valueKey: const ValueKey('support-action-call'),
          icon: Icons.call_rounded,
          title: l10n.callBusiness,
          description: formatPhoneNumber(business.phoneNumber),
          onTap: () => _launchPhone(context, ref),
        ),
      );
    }

    if (business.email.trim().isNotEmpty) {
      actions.add(
        AuroraSupportActionCard(
          valueKey: const ValueKey('support-action-email'),
          icon: Icons.alternate_email_rounded,
          title: l10n.sendEmail,
          description: business.email,
          onTap: () => _launchEmail(context, ref),
        ),
      );
    }

    if (business.whatsappNumber.trim().isNotEmpty) {
      actions.add(
        AuroraSupportActionCard(
          valueKey: const ValueKey('support-action-whatsapp'),
          icon: Icons.chat_rounded,
          title: l10n.openWhatsapp,
          description: l10n.openWhatsappDescription,
          onTap: () => _launchWhatsApp(context, ref),
        ),
      );
    }

    actions.add(
      AuroraSupportActionCard(
        valueKey: const ValueKey('support-action-business-info'),
        icon: Icons.storefront_rounded,
        title: l10n.visitBusinessInformation,
        description: l10n.visitBusinessInformationDescription,
        onTap: () => context.go(AppRoutePaths.businessInfo),
      ),
    );

    if (isLaunchableSocialUrl(business.instagramUrl)) {
      actions.add(
        AuroraSupportActionCard(
          valueKey: const ValueKey('support-action-instagram'),
          icon: Icons.camera_alt_rounded,
          title: l10n.instagram,
          description: l10n.openInstagramAction,
          onTap: () => _launchSocial(
            context,
            ref,
            Uri.parse(business.instagramUrl.trim()),
          ),
        ),
      );
    }

    if (isLaunchableSocialUrl(business.facebookUrl)) {
      actions.add(
        AuroraSupportActionCard(
          valueKey: const ValueKey('support-action-facebook'),
          icon: Icons.facebook_rounded,
          title: l10n.facebook,
          description: l10n.openFacebookAction,
          onTap: () => _launchSocial(
            context,
            ref,
            Uri.parse(business.facebookUrl.trim()),
          ),
        ),
      );
    }

    return actions;
  }

  Future<void> _launchWhatsApp(BuildContext context, WidgetRef ref) async {
    try {
      final launcher = ref.read(whatsappOrderLauncherProvider);
      final number = launcher.normalizeWhatsAppNumber(business.whatsappNumber);
      final launched = await _launch(
        ref,
        Uri.https('wa.me', '/$number', {
          'text': context.l10n.supportWhatsappMessage(business.businessName),
        }),
      );
      if (context.mounted && !launched) {
        _showInfo(context, context.l10n.whatsappAppUnavailable);
      }
    } on FormatException {
      if (context.mounted) {
        _showWarning(context, context.l10n.invalidWhatsappNumber);
      }
    }
  }

  Future<void> _launchPhone(BuildContext context, WidgetRef ref) async {
    final launched = await _launch(
      ref,
      Uri(scheme: 'tel', path: business.phoneNumber.trim()),
    );
    if (context.mounted && !launched) {
      _showInfo(context, context.l10n.noPhoneApp);
    }
  }

  Future<void> _launchEmail(BuildContext context, WidgetRef ref) async {
    final email = business.email.trim();
    if (!await _launch(ref, Uri(scheme: 'mailto', path: email))) {
      await Clipboard.setData(ClipboardData(text: email));
      if (context.mounted) {
        _showInfo(context, context.l10n.emailAddressCopied);
      }
    }
  }

  Future<void> _launchSocial(
    BuildContext context,
    WidgetRef ref,
    Uri uri,
  ) async {
    if (!await _launch(ref, uri) && context.mounted) {
      _showWarning(context, context.l10n.socialLinkUnavailable);
    }
  }

  Future<bool> _launch(WidgetRef ref, Uri uri) =>
      tryLaunchExternal(ref.read(externalLinkLauncherProvider), uri);

  void _showInfo(BuildContext context, String message) {
    showAppFeedback(
      context,
      type: AppFeedbackType.info,
      title: context.l10n.infoTitle,
      message: message,
    );
  }

  void _showWarning(BuildContext context, String message) {
    showAppFeedback(
      context,
      type: AppFeedbackType.warning,
      title: context.l10n.warningTitle,
      message: message,
    );
  }
}

class _SupportHeader extends StatelessWidget {
  const _SupportHeader({required this.business});

  final BusinessConfig business;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? AuroraGradients.heroDark
            : AuroraGradients.heroLight,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        boxShadow: AuroraShadows.glow(theme.colorScheme.primary, opacity: 0.18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            const AuroraIconContainer(
              icon: Icons.support_agent_rounded,
              color: Colors.white,
              size: 56,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.helpSupportTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    context.l10n.helpSupportHeaderDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  BidiSafeText(
                    business.businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuroraSupportActionCard extends StatelessWidget {
  const AuroraSupportActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.valueKey,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      key: valueKey,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuroraIconContainer(icon: icon, size: 44),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      BidiSafeText(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.north_east_rounded,
                  size: AppIconSizes.sm,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqAccordion extends StatefulWidget {
  @override
  State<_FaqAccordion> createState() => _FaqAccordionState();
}

class _FaqAccordionState extends State<_FaqAccordion>
    with TickerProviderStateMixin {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final faqs = [
      (l10n.faqPlaceOrderQuestion, l10n.faqPlaceOrderAnswer),
      (l10n.faqWhatsappQuestion, l10n.faqWhatsappAnswer),
      (l10n.faqChangeOrderQuestion, l10n.faqChangeOrderAnswer),
      (l10n.faqPaymentQuestion, l10n.faqPaymentAnswer),
      (l10n.faqUnavailableQuestion, l10n.faqUnavailableAnswer),
    ];

    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraSectionHeader(
            title: l10n.faqTitle,
            subtitle: l10n.faqDescription,
            action: const AuroraIconContainer(
              icon: Icons.quiz_outlined,
              size: 42,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var index = 0; index < faqs.length; index++) ...[
            _FaqRow(
              question: faqs[index].$1,
              answer: faqs[index].$2,
              expanded: _expandedIndex == index,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == index ? null : index;
                });
              },
            ),
            if (index != faqs.length - 1) const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AuroraMotion.curve,
      decoration: BoxDecoration(
        color: expanded
            ? theme.colorScheme.primary.withValues(alpha: 0.10)
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: expanded
              ? theme.colorScheme.primary.withValues(alpha: 0.46)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: AppDurations.medium,
                      curve: AuroraMotion.curve,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: AppDurations.medium,
                  curve: AuroraMotion.curve,
                  alignment: Alignment.topCenter,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Text(
                            answer,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderFlowCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      (l10n.orderFlowBrowse, l10n.orderFlowBrowseDescription),
      (l10n.orderFlowCart, l10n.orderFlowCartDescription),
      (l10n.orderFlowDetails, l10n.orderFlowDetailsDescription),
      (l10n.orderFlowWhatsapp, l10n.orderFlowWhatsappDescription),
    ];

    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraSectionHeader(
            title: l10n.aboutOrderingTitle,
            subtitle: l10n.aboutOrderingDescription,
            action: const AuroraIconContainer(
              icon: Icons.route_rounded,
              size: 42,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var index = 0; index < steps.length; index++) ...[
            _TimelineStep(
              number: index + 1,
              title: steps[index].$1,
              description: steps[index].$2,
            ),
            if (index != steps.length - 1)
              const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.number,
    required this.title,
    required this.description,
  });

  final int number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: AuroraGradients.primary,
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          child: Text(
            '$number',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TroubleshootingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entries = [
      l10n.troubleshootWhatsapp,
      l10n.troubleshootContactLink,
      l10n.troubleshootImages,
      l10n.troubleshootSettings,
      l10n.troubleshootRetryContact,
    ];

    return AuroraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuroraSectionHeader(
            title: l10n.troubleshootingTitle,
            subtitle: l10n.troubleshootingDescription,
            action: const AuroraIconContainer(
              icon: Icons.build_circle_outlined,
              size: 42,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final entry in entries) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(entry)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: BidiSafeText(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
