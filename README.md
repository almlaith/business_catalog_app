# Business Catalog

A reusable Flutter template for small businesses that need a local catalog, in-memory cart, checkout form, and WhatsApp order handoff without a backend. The sample data uses a fictional business, but the app is intended to be customized for restaurants, bakeries, perfume stores, salons, boutiques, and service catalogs.

## Features

- Android and iOS Flutter mobile app.
- Material 3 visual system with business-configurable colors.
- Feature-first folder structure.
- Riverpod state management.
- GoRouter navigation with a persistent bottom app shell.
- Local JSON catalog loaded from assets.
- Freezed and `json_serializable` data models.
- Local in-memory cart.
- Checkout form with pickup and delivery validation.
- WhatsApp order message generation and `wa.me` launch.
- English and Arabic localization with RTL/LTR support.
- Missing-image fallback UI.
- Defensive catalog validation for IDs, category links, and prices.

## Technology Stack

- Flutter and Dart.
- Material 3.
- Riverpod.
- GoRouter.
- Freezed and `json_serializable`.
- `shared_preferences`.
- `url_launcher`.
- `intl`.
- Flutter `gen_l10n` using ARB files.

## Project Structure

```text
lib/
  app/                 App shell, router, theme
  core/                Constants, extensions, validation, utilities, widgets
  features/            Feature-first UI and state modules
  l10n/                English/Arabic ARB files and generated localization code
  models/              Freezed/json_serializable models
  services/            Local settings and external link services
assets/
  data/catalog.json    Main customization entry point
  images/              Business, category, and product image assets
```

## Setup

1. Install Flutter and Android Studio.
2. Run `flutter pub get`.
3. Regenerate code when models or localization files change:

```sh
flutter gen-l10n
dart run build_runner build
```

## Run

```sh
flutter run
```

Use an Android emulator, iOS simulator on macOS, or a physical device.

## Customization Entry Point

Start with `assets/data/catalog.json`. Keep client-specific business values, colors, currency, WhatsApp number, categories, products, and image paths there. Do not put client-specific values into Dart widgets.

### Business Fields

```json
{
  "business": {
    "id": "client-business-id",
    "businessName": "Client Business",
    "shortDescription": "Short reusable business description.",
    "logoAsset": "assets/images/client/logo.png",
    "phoneNumber": "+15550101444",
    "whatsappNumber": "+15550101444",
    "email": "hello@example.com",
    "address": "Street address",
    "currencyCode": "USD",
    "defaultLocale": "en",
    "primaryColorHex": "#1C7C70",
    "secondaryColorHex": "#F4A261",
    "instagramUrl": "https://instagram.com/example",
    "facebookUrl": "https://facebook.com/example",
    "openingHours": {
      "monday": "10:00 AM - 9:00 PM"
    }
  }
}
```

- `defaultLocale` supports `en` and `ar`; invalid values fall back safely.
- Colors must be hex strings such as `#1C7C70`; invalid colors use safe defaults.
- `currencyCode` should be an ISO code such as `USD`, `JOD`, `SAR`, or `AED`.
- `whatsappNumber` should include country code. Spaces, dashes, parentheses, and leading `+` are normalized.
- Empty optional links or contact fields are hidden where appropriate.

### Categories

```json
{
  "id": "category-id",
  "name": "Category name",
  "description": "Short category description",
  "imageAsset": "assets/images/client/categories/category.jpg",
  "displayOrder": 1,
  "isActive": true
}
```

Active categories are sorted by `displayOrder`. Product `categoryId` values must match an existing category `id`.

### Products

```json
{
  "id": "product-id",
  "categoryId": "category-id",
  "name": "Product name",
  "description": "Product description",
  "imageAsset": "assets/images/client/products/product.jpg",
  "price": 8.99,
  "oldPrice": null,
  "isFeatured": true,
  "isAvailable": true,
  "displayOrder": 1,
  "tags": ["tag"]
}
```

Products are sorted by `displayOrder`. Negative prices, duplicate IDs, and unknown category references are rejected during catalog loading.

## Images, Icon, and Splash

Replace these two source branding files for each client:

- App icon source: `assets/branding/app_icon.png`
- Splash logo source: `assets/branding/splash_logo.png`

Then regenerate the native Android and iOS assets:

```sh
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Do not edit generated native icon and splash files by hand unless a platform-specific client requirement truly needs it. The generated outputs include Android mipmap icons, Android adaptive icon resources, iOS app icon assets, Android launch backgrounds, Android 12 splash resources, and the iOS launch storyboard configuration.

Other client image files:

- Business logo: path referenced by `business.logoAsset`.
- Category images: paths referenced by each category `imageAsset`.
- Product images: paths referenced by each product `imageAsset`.

Register new asset folders in `pubspec.yaml` if you add paths outside the existing `assets/images/...` structure. Missing image paths show a generic fallback instead of crashing.

## Localization

Edit:

- `lib/l10n/app_en.arb`
- `lib/l10n/app_ar.arb`

Then run:

```sh
flutter gen-l10n
```

Do not translate product names, category names, product descriptions, or business-provided text in ARB files. Those remain in `catalog.json`.

## Android Release Builds

Debug APK:

```sh
flutter build apk --debug
```

Release APK:

```sh
flutter build apk --release
```

Release Android App Bundle:

```sh
flutter build appbundle --release
```

This template does not include a production signing keystore. Configure signing outside source control before publishing to Google Play.

## iOS Build Note

iOS builds require macOS and Xcode:

```sh
flutter build ios --release
```

Configure signing in Xcode for the client Apple Developer account.

## Troubleshooting

- Run `flutter pub get` if packages are missing.
- Run `flutter gen-l10n` after editing ARB localization files.
- Run `dart run build_runner build` after editing Freezed models.
- Check `assets/data/catalog.json` if the app shows a catalog loading error.
- Ensure all asset paths in JSON are registered in `pubspec.yaml`.
- Ensure WhatsApp is installed or available on the test device before sending orders.
- Use valid URLs for Instagram/Facebook and include a country code for WhatsApp.

## Known Limitations

- Local JSON only.
- No backend.
- No Firebase.
- No authentication.
- No payments.
- No order history.
- No cart persistence.
- No taxes, discounts, or delivery fees.
- WhatsApp must be installed or available.
