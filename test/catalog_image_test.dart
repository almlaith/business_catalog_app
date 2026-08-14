import 'package:business_catalog_app/core/widgets/local_asset_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('detects supported network image sources', () {
    expect(isNetworkImageSource('https://example.com/image.webp'), isTrue);
    expect(isNetworkImageSource('http://10.0.2.2:8080/image.png'), isTrue);
    expect(isNetworkImageSource('assets/images/product.webp'), isFalse);
    expect(isNetworkImageSource('ftp://example.com/image.png'), isFalse);
    expect(isNetworkImageSource('not a URI'), isFalse);
  });
}
