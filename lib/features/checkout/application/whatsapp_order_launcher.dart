import 'package:business_catalog_app/services/external_link_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

final whatsappOrderLauncherProvider = Provider<WhatsAppOrderLauncher>(
  (ref) => WhatsAppOrderLauncher(
    externalLinkLauncher: ref.watch(externalLinkLauncherProvider),
  ),
);

class WhatsAppOrderLauncher {
  const WhatsAppOrderLauncher({required this.externalLinkLauncher});

  final ExternalLinkLauncher externalLinkLauncher;

  String normalizeWhatsAppNumber(String value) {
    final normalized = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    if (normalized.isEmpty ||
        !RegExp(r'^\d+$').hasMatch(normalized) ||
        normalized.length < 7) {
      throw const FormatException('Invalid WhatsApp number.');
    }

    return normalized;
  }

  Uri buildWhatsAppUri({
    required String whatsappNumber,
    required String message,
  }) {
    final normalizedNumber = normalizeWhatsAppNumber(whatsappNumber);

    return Uri.https('wa.me', '/$normalizedNumber', {'text': message});
  }

  Future<bool> launchOrder({
    required String whatsappNumber,
    required String message,
  }) async {
    final uri = buildWhatsAppUri(
      whatsappNumber: whatsappNumber,
      message: message,
    );

    final canLaunch = await externalLinkLauncher.canLaunch(uri);
    if (!canLaunch) {
      return false;
    }

    return externalLinkLauncher.launch(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}
