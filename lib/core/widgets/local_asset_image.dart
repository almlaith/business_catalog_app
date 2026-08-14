import 'package:business_catalog_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LocalAssetImage extends StatelessWidget {
  const LocalAssetImage({
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
    super.key,
  });

  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final isNetwork = isNetworkImageSource(assetPath);
    return ClipRRect(
      borderRadius: borderRadius,
      child: isNetwork
          ? Image.network(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : _ImageLoadingPlaceholder(width: width, height: height),
              errorBuilder: (context, error, stackTrace) =>
                  _MissingAssetImage(width: width, height: height),
            )
          : Image.asset(
              assetPath,
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  _MissingAssetImage(width: width, height: height),
            ),
    );
  }
}

bool isNetworkImageSource(String source) {
  final uri = Uri.tryParse(source.trim());
  return uri != null &&
      uri.hasAuthority &&
      (uri.scheme == 'http' || uri.scheme == 'https');
}

class _ImageLoadingPlaceholder extends StatelessWidget {
  const _ImageLoadingPlaceholder({this.width, this.height});
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.center,
    child: const CircularProgressIndicator.adaptive(),
  );
}

class _MissingAssetImage extends StatelessWidget {
  const _MissingAssetImage({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = Localizations.of<AppLocalizations>(context, AppLocalizations);

    return Semantics(
      label: l10n?.missingImage,
      image: true,
      child: Container(
        key: const ValueKey('missing-asset-image-placeholder'),
        width: width,
        height: height,
        color: colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
