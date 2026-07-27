import 'package:business_catalog_app/app/app.dart';
import 'package:business_catalog_app/core/constants/app_strings.dart';
import 'package:business_catalog_app/models/app_settings.dart';
import 'package:business_catalog_app/services/local_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows the home route', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appSettingsProvider.overrideWithValue(const AppSettings())],
        child: const BusinessCatalogApp(),
      ),
    );

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.catalogTitle), findsOneWidget);
    expect(find.text(AppStrings.cartTitle), findsOneWidget);
  });
}
