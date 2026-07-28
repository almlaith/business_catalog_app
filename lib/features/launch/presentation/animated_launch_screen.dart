import 'package:business_catalog_app/app/theme/aurora_tokens.dart';
import 'package:business_catalog_app/core/constants/app_spacing.dart';
import 'package:business_catalog_app/core/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final launchAnimationEnabledProvider = Provider<bool>((ref) => true);

class LaunchOverlay extends StatefulWidget {
  const LaunchOverlay({required this.child, required this.enabled, super.key});

  final Widget child;
  final bool enabled;

  @override
  State<LaunchOverlay> createState() => _LaunchOverlayState();
}

class _LaunchOverlayState extends State<LaunchOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _visible = true;
  var _completed = false;

  @override
  void initState() {
    super.initState();
    _visible = widget.enabled;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    if (_visible) {
      _controller.forward().whenComplete(_completeOnce);
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _completeOnce() {
    if (!mounted || _completed) {
      return;
    }
    _completed = true;
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return widget.child;
    }

    return Stack(
      children: [
        Positioned.fill(child: Offstage(child: widget.child)),
        Positioned.fill(child: _AnimatedLaunchScreen(controller: _controller)),
      ],
    );
  }
}

class _AnimatedLaunchScreen extends StatelessWidget {
  const _AnimatedLaunchScreen({required this.controller});

  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final animation = reduceMotion
        ? const AlwaysStoppedAnimation<double>(1)
        : CurvedAnimation(parent: controller, curve: AuroraMotion.curve);

    return ColoredBox(
      key: const ValueKey('animated-launch-screen'),
      color: AuroraColors.darkBackground,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final value = animation.value;

          return Stack(
            fit: StackFit.expand,
            children: [
              Opacity(
                opacity: value,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PositionedDirectional(
                      top: 72 - (18 * value),
                      start: -96 + (20 * value),
                      child: _LaunchLightWash(
                        color: AuroraColors.primaryViolet,
                        opacity: 0.28,
                        angle: -0.24,
                      ),
                    ),
                    PositionedDirectional(
                      top: 178 + (18 * value),
                      end: -120 + (26 * value),
                      child: _LaunchLightWash(
                        color: AuroraColors.electricCyan,
                        opacity: 0.22,
                        angle: 0.28,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Transform.scale(scale: 1 + (0.08 * value), child: child),
              ),
              Align(
                alignment: const Alignment(0, 0.46),
                child: Opacity(
                  opacity: Curves.easeOut.transform(
                    ((value - 0.32) / 0.68).clamp(0.0, 1.0),
                  ),
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - value)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxl,
                      ),
                      child: Text(
                        context.l10n.appTitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AuroraColors.darkText,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: Image.asset(
          'assets/branding/splash_logo.png',
          width: 313,
          height: 313,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _LaunchLightWash extends StatelessWidget {
  const _LaunchLightWash({
    required this.color,
    required this.opacity,
    required this.angle,
  });

  final Color color;
  final double opacity;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 320,
          height: 132,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.pill),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0),
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
