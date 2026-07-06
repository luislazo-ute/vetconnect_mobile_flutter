/// Configuración central de la app (como el settings.py de Django).
class Constantes {
  Constantes._(); // constructor privado: esta clase es solo un contenedor de constantes.

  // === URL base de la API ===
  // Para producción usa urlProduccion; para probar el backend local en el
  // emulador Android, cambia a urlLocal.
  static const String urlBase = urlProduccion;

  static const String urlProduccion = 'https://vetconnect-api.uaeftt-ute.site/api/';

  // 10.0.2.2 es un alias especial: es el "localhost" de tu Mac visto DESDE el
  // emulador Android (dentro del emulador, 'localhost' sería el propio teléfono).
  static const String urlLocal = 'http://10.0.2.2:8000/api/';

  // Tiempo máximo de espera de una petición (lo pide el profe: 15s).
  static const Duration timeout = Duration(seconds: 15);
}
