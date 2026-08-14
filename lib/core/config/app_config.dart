enum CatalogSource { local, remote }

class AppConfig {
  const AppConfig({required this.catalogSource, this.apiBaseUrl});

  factory AppConfig.fromEnvironment({
    String catalogSource = const String.fromEnvironment(
      'CATALOG_SOURCE',
      defaultValue: 'local',
    ),
    String apiBaseUrl = const String.fromEnvironment('API_BASE_URL'),
  }) {
    final source = switch (catalogSource.trim().toLowerCase()) {
      'local' => CatalogSource.local,
      'remote' => CatalogSource.remote,
      _ => throw ArgumentError.value(
        catalogSource,
        'CATALOG_SOURCE',
        'Expected "local" or "remote".',
      ),
    };

    final normalizedUrl = apiBaseUrl.trim();
    if (source == CatalogSource.remote && normalizedUrl.isEmpty) {
      throw ArgumentError(
        'API_BASE_URL is required when CATALOG_SOURCE=remote.',
      );
    }

    final uri = normalizedUrl.isEmpty ? null : Uri.tryParse(normalizedUrl);
    if (uri != null &&
        (!uri.hasScheme ||
            !uri.hasAuthority ||
            (uri.scheme != 'http' && uri.scheme != 'https'))) {
      throw ArgumentError.value(
        apiBaseUrl,
        'API_BASE_URL',
        'Expected an absolute HTTP(S) URL.',
      );
    }

    return AppConfig(
      catalogSource: source,
      apiBaseUrl: uri == null
          ? null
          : Uri.parse(normalizedUrl.replaceFirst(RegExp(r'/+$'), '')),
    );
  }

  final CatalogSource catalogSource;
  final Uri? apiBaseUrl;
}
