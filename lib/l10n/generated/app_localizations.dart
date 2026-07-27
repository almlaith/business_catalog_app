import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Catalog'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalogTitle;

  /// No description provided for @productDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsTitle;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @businessInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInfoTitle;

  /// No description provided for @businessInfoNavLabel.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get businessInfoNavLabel;

  /// No description provided for @placeholderLabel.
  ///
  /// In en, this message translates to:
  /// **'Placeholder screen'**
  String get placeholderLabel;

  /// No description provided for @loadingCatalog.
  ///
  /// In en, this message translates to:
  /// **'Loading catalog...'**
  String get loadingCatalog;

  /// No description provided for @unableToLoadCatalog.
  ///
  /// In en, this message translates to:
  /// **'Unable to load catalog data.'**
  String get unableToLoadCatalog;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found.'**
  String get productNotFound;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @categoriesSection.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesSection;

  /// No description provided for @featuredSection.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featuredSection;

  /// No description provided for @viewCatalog.
  ///
  /// In en, this message translates to:
  /// **'View Catalog'**
  String get viewCatalog;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No active categories are available yet.'**
  String get noCategories;

  /// No description provided for @noFeaturedProducts.
  ///
  /// In en, this message translates to:
  /// **'No featured products are available yet.'**
  String get noFeaturedProducts;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products are available for this category.'**
  String get noProducts;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get addedToCart;

  /// No description provided for @viewCart.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCart;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get cartEmpty;

  /// No description provided for @browseCatalog.
  ///
  /// In en, this message translates to:
  /// **'Browse Catalog'**
  String get browseCatalog;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @clearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear cart'**
  String get clearCart;

  /// No description provided for @clearCartQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear cart?'**
  String get clearCartQuestion;

  /// No description provided for @clearCartMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove all items from your cart.'**
  String get clearCartMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Payment and order history are not implemented yet.'**
  String get checkoutNotImplemented;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order notes'**
  String get orderNotes;

  /// No description provided for @orderType.
  ///
  /// In en, this message translates to:
  /// **'Order type'**
  String get orderType;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @sendOrderViaWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send Order via WhatsApp'**
  String get sendOrderViaWhatsapp;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @whatsappUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to open WhatsApp.'**
  String get whatsappUnavailable;

  /// No description provided for @invalidWhatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'The business WhatsApp number is missing or invalid.'**
  String get invalidWhatsappNumber;

  /// No description provided for @orderSent.
  ///
  /// In en, this message translates to:
  /// **'Order opened in WhatsApp.'**
  String get orderSent;

  /// No description provided for @clearCartAfterOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear cart?'**
  String get clearCartAfterOrderQuestion;

  /// No description provided for @clearCartAfterOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'Would you like to clear the cart now?'**
  String get clearCartAfterOrderMessage;

  /// No description provided for @keepCart.
  ///
  /// In en, this message translates to:
  /// **'Keep cart'**
  String get keepCart;

  /// No description provided for @businessDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get businessDescription;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening hours'**
  String get openingHours;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @unableToOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Unable to open this link.'**
  String get unableToOpenLink;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsTooltip;

  /// No description provided for @settingsHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Tune the look, language, and support options for this reusable catalog app.'**
  String get settingsHeaderDescription;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @appearanceSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how the Aurora interface should feel on this device.'**
  String get appearanceSectionDescription;

  /// No description provided for @languageSetting.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSetting;

  /// No description provided for @languageSettingDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the interface language for this app.'**
  String get languageSettingDescription;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @englishNativeLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishNativeLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// No description provided for @arabicNativeLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicNativeLanguage;

  /// No description provided for @themeSetting.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSetting;

  /// No description provided for @themeSettingDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose Dark, Light, or System appearance. Dark is the template default.'**
  String get themeSettingDescription;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemTheme;

  /// No description provided for @systemThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow the device setting when the client prefers automatic switching.'**
  String get systemThemeDescription;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @lightThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the mist and lavender Aurora surfaces.'**
  String get lightThemeDescription;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @darkThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the premium ink and navy Aurora surfaces.'**
  String get darkThemeDescription;

  /// No description provided for @preferencesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Current setup'**
  String get preferencesSummaryTitle;

  /// No description provided for @preferencesSummaryDescription.
  ///
  /// In en, this message translates to:
  /// **'A quick snapshot of the active appearance preferences.'**
  String get preferencesSummaryDescription;

  /// No description provided for @applicationSection.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get applicationSection;

  /// No description provided for @applicationSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Template information, support, and reset actions.'**
  String get applicationSectionDescription;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'A reusable local catalog and WhatsApp ordering template for small businesses.'**
  String get aboutAppDescription;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @appVersionDescription.
  ///
  /// In en, this message translates to:
  /// **'Installed template build information.'**
  String get appVersionDescription;

  /// No description provided for @resetAppearance.
  ///
  /// In en, this message translates to:
  /// **'Reset appearance settings'**
  String get resetAppearance;

  /// No description provided for @resetAppearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Return language and theme to the template defaults.'**
  String get resetAppearanceDescription;

  /// No description provided for @resetAppearanceQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reset appearance settings?'**
  String get resetAppearanceQuestion;

  /// No description provided for @resetAppearanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Language and theme preferences will return to their defaults.'**
  String get resetAppearanceMessage;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @settingsSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings updated'**
  String get settingsSavedTitle;

  /// No description provided for @settingsSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your preference was applied.'**
  String get settingsSavedMessage;

  /// No description provided for @settingsResetTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings reset'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetMessage.
  ///
  /// In en, this message translates to:
  /// **'Appearance settings were reset.'**
  String get settingsResetMessage;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpSupportTitle;

  /// No description provided for @helpSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Find ordering help and contact options.'**
  String get helpSupportDescription;

  /// No description provided for @helpSupportHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Answers, contact actions, and ordering guidance for this business catalog.'**
  String get helpSupportHeaderDescription;

  /// No description provided for @quickSupportActions.
  ///
  /// In en, this message translates to:
  /// **'Quick support actions'**
  String get quickSupportActions;

  /// No description provided for @quickSupportActionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the available channels configured for this business.'**
  String get quickSupportActionsDescription;

  /// No description provided for @callBusiness.
  ///
  /// In en, this message translates to:
  /// **'Call business'**
  String get callBusiness;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get sendEmail;

  /// No description provided for @openWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Open WhatsApp'**
  String get openWhatsapp;

  /// No description provided for @openWhatsappDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a WhatsApp conversation with the business.'**
  String get openWhatsappDescription;

  /// No description provided for @visitBusinessInformation.
  ///
  /// In en, this message translates to:
  /// **'Visit business information'**
  String get visitBusinessInformation;

  /// No description provided for @visitBusinessInformationDescription.
  ///
  /// In en, this message translates to:
  /// **'View address, opening hours, and social links.'**
  String get visitBusinessInformationDescription;

  /// No description provided for @supportWhatsappMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello {businessName}, I need help with the catalog app.'**
  String supportWhatsappMessage(Object businessName);

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked questions'**
  String get faqTitle;

  /// No description provided for @faqDescription.
  ///
  /// In en, this message translates to:
  /// **'Generic answers that keep the template reusable.'**
  String get faqDescription;

  /// No description provided for @faqPlaceOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I place an order?'**
  String get faqPlaceOrderQuestion;

  /// No description provided for @faqPlaceOrderAnswer.
  ///
  /// In en, this message translates to:
  /// **'Browse the catalog, add items to the cart, enter your details, then send the prepared order through WhatsApp.'**
  String get faqPlaceOrderAnswer;

  /// No description provided for @faqWhatsappQuestion.
  ///
  /// In en, this message translates to:
  /// **'How does WhatsApp ordering work?'**
  String get faqWhatsappQuestion;

  /// No description provided for @faqWhatsappAnswer.
  ///
  /// In en, this message translates to:
  /// **'The app prepares a readable message with your cart and customer details, then opens WhatsApp so you can review and send it.'**
  String get faqWhatsappAnswer;

  /// No description provided for @faqChangeOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can I change my order after opening WhatsApp?'**
  String get faqChangeOrderQuestion;

  /// No description provided for @faqChangeOrderAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes. You can edit the message in WhatsApp before sending or contact the business directly for changes.'**
  String get faqChangeOrderAnswer;

  /// No description provided for @faqPaymentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is payment completed inside the application?'**
  String get faqPaymentQuestion;

  /// No description provided for @faqPaymentAnswer.
  ///
  /// In en, this message translates to:
  /// **'No. This template does not process payments inside the app.'**
  String get faqPaymentAnswer;

  /// No description provided for @faqUnavailableQuestion.
  ///
  /// In en, this message translates to:
  /// **'Why are some products unavailable?'**
  String get faqUnavailableQuestion;

  /// No description provided for @faqUnavailableAnswer.
  ///
  /// In en, this message translates to:
  /// **'Availability is controlled by the local catalog data. Unavailable items are shown clearly and cannot be added to the cart.'**
  String get faqUnavailableAnswer;

  /// No description provided for @aboutOrderingTitle.
  ///
  /// In en, this message translates to:
  /// **'About ordering'**
  String get aboutOrderingTitle;

  /// No description provided for @aboutOrderingDescription.
  ///
  /// In en, this message translates to:
  /// **'The checkout flow stays simple and WhatsApp-based.'**
  String get aboutOrderingDescription;

  /// No description provided for @orderFlowBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse products'**
  String get orderFlowBrowse;

  /// No description provided for @orderFlowBrowseDescription.
  ///
  /// In en, this message translates to:
  /// **'Review categories, products, services, and details from the local catalog.'**
  String get orderFlowBrowseDescription;

  /// No description provided for @orderFlowCart.
  ///
  /// In en, this message translates to:
  /// **'Add items to cart'**
  String get orderFlowCart;

  /// No description provided for @orderFlowCartDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose quantities and review the subtotal before continuing.'**
  String get orderFlowCartDescription;

  /// No description provided for @orderFlowDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter order details'**
  String get orderFlowDetails;

  /// No description provided for @orderFlowDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Provide customer details, order type, notes, and delivery address when needed.'**
  String get orderFlowDetailsDescription;

  /// No description provided for @orderFlowWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Send through WhatsApp'**
  String get orderFlowWhatsapp;

  /// No description provided for @orderFlowWhatsappDescription.
  ///
  /// In en, this message translates to:
  /// **'The app opens WhatsApp with a prepared message for the business.'**
  String get orderFlowWhatsappDescription;

  /// No description provided for @troubleshootingTitle.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get troubleshootingTitle;

  /// No description provided for @troubleshootingDescription.
  ///
  /// In en, this message translates to:
  /// **'Quick checks for common local-template issues.'**
  String get troubleshootingDescription;

  /// No description provided for @troubleshootWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'If WhatsApp does not open, check that WhatsApp or a compatible browser is available on the device.'**
  String get troubleshootWhatsapp;

  /// No description provided for @troubleshootContactLink.
  ///
  /// In en, this message translates to:
  /// **'If a contact link does not work, verify the phone, email, or URL in catalog.json.'**
  String get troubleshootContactLink;

  /// No description provided for @troubleshootImages.
  ///
  /// In en, this message translates to:
  /// **'If images are not visible, confirm the asset path exists and is registered in pubspec.yaml.'**
  String get troubleshootImages;

  /// No description provided for @troubleshootSettings.
  ///
  /// In en, this message translates to:
  /// **'If settings do not update immediately, reopen the screen and confirm preferences are saved.'**
  String get troubleshootSettings;

  /// No description provided for @troubleshootRetryContact.
  ///
  /// In en, this message translates to:
  /// **'You can retry the action or contact the business using another available channel.'**
  String get troubleshootRetryContact;

  /// No description provided for @applicationInformation.
  ///
  /// In en, this message translates to:
  /// **'Application information'**
  String get applicationInformation;

  /// No description provided for @refreshFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed'**
  String get refreshFailedTitle;

  /// No description provided for @refreshFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'The local catalog could not be reloaded. Existing content was kept.'**
  String get refreshFailedMessage;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get successTitle;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Check this'**
  String get warningTitle;

  /// No description provided for @infoTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get infoTitle;

  /// No description provided for @productUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This item is currently unavailable.'**
  String get productUnavailableMessage;

  /// No description provided for @invalidFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete required fields'**
  String get invalidFormTitle;

  /// No description provided for @invalidFormMessage.
  ///
  /// In en, this message translates to:
  /// **'Please review the highlighted fields and try again.'**
  String get invalidFormMessage;

  /// No description provided for @removeItem.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get removeItem;

  /// No description provided for @decreaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantity;

  /// No description provided for @increaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantity;

  /// No description provided for @missingImage.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get missingImage;

  /// No description provided for @orderMessageGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {businessName},'**
  String orderMessageGreeting(Object businessName);

  /// No description provided for @orderMessageIntro.
  ///
  /// In en, this message translates to:
  /// **'I would like to place an order.'**
  String get orderMessageIntro;

  /// No description provided for @orderMessageCustomerSection.
  ///
  /// In en, this message translates to:
  /// **'Customer:'**
  String get orderMessageCustomerSection;

  /// No description provided for @orderMessageName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get orderMessageName;

  /// No description provided for @orderMessagePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get orderMessagePhone;

  /// No description provided for @orderMessageOrderType.
  ///
  /// In en, this message translates to:
  /// **'Order type'**
  String get orderMessageOrderType;

  /// No description provided for @orderMessageDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get orderMessageDeliveryAddress;

  /// No description provided for @orderMessageItems.
  ///
  /// In en, this message translates to:
  /// **'Items:'**
  String get orderMessageItems;

  /// No description provided for @orderMessageNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes:'**
  String get orderMessageNotes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
