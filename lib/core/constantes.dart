class Constantes {
  Constantes._();

  static const String urlBase = urlProduccion;

  static const String urlProduccion =
      'https://vetconnect-api.uaeftt-ute.site/api/';

  static const String urlLocal = 'http://10.0.2.2:8000/api/';

  static const Duration timeout = Duration(seconds: 15);
}
