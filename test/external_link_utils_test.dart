import 'package:business_catalog_app/services/external_link_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('domains ending in .demo are not launchable social URLs', () {
    expect(isLaunchableSocialUrl('https://social.aura.demo/profile'), isFalse);
  });

  test('demo-only social account paths are not launchable', () {
    expect(
      isLaunchableSocialUrl('https://instagram.com/auraatelier.demo'),
      isFalse,
    );
  });

  test('real HTTPS social URLs are launchable', () {
    expect(isLaunchableSocialUrl('https://instagram.com/aura_atelier'), isTrue);
  });

  test('non-HTTPS social URLs are not launchable', () {
    expect(isLaunchableSocialUrl('http://instagram.com/aura_atelier'), isFalse);
  });
}
