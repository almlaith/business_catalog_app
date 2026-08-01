import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

bool isValidHttpsUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  return uri != null &&
      uri.scheme == 'https' &&
      uri.host.isNotEmpty &&
      !isDemoHost(uri.host);
}

bool isDemoHost(String host) {
  final normalizedHost = host.toLowerCase();
  return normalizedHost == 'demo' || normalizedHost.endsWith('.demo');
}

bool isDemoSocialUrl(String value) {
  final uri = Uri.tryParse(value.trim());
  if (uri == null || isDemoHost(uri.host)) {
    return true;
  }

  return uri.pathSegments.any((segment) {
    final normalizedSegment = segment.toLowerCase();
    return normalizedSegment == 'demo' || normalizedSegment.endsWith('.demo');
  });
}

bool isLaunchableSocialUrl(String value) =>
    isValidHttpsUrl(value) && !isDemoSocialUrl(value);

String formatPhoneNumber(String value) {
  final trimmed = value.trim();
  final digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 11 && digits.startsWith('1')) {
    return '+1 (${digits.substring(1, 4)}) '
        '${digits.substring(4, 7)}-${digits.substring(7)}';
  }
  return trimmed;
}

Future<bool> tryLaunchExternal(ExternalLinkLauncher launcher, Uri uri) async {
  try {
    if (!await launcher.canLaunch(uri)) {
      return false;
    }
    return await launcher.launch(uri, mode: LaunchMode.externalApplication);
  } on Object {
    return false;
  }
}
