import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final externalLinkLauncherProvider = Provider<ExternalLinkLauncher>(
  (ref) => const UrlExternalLinkLauncher(),
);

abstract interface class ExternalLinkLauncher {
  Future<bool> canLaunch(Uri uri);

  Future<bool> launch(Uri uri, {LaunchMode mode = LaunchMode.platformDefault});
}

class UrlExternalLinkLauncher implements ExternalLinkLauncher {
  const UrlExternalLinkLauncher();

  @override
  Future<bool> canLaunch(Uri uri) => canLaunchUrl(uri);

  @override
  Future<bool> launch(Uri uri, {LaunchMode mode = LaunchMode.platformDefault}) {
    return launchUrl(uri, mode: mode);
  }
}
