// Prueba de humo básica: verifica que la app arranca y muestra la pantalla inicial.
import 'package:flutter_test/flutter_test.dart';

import 'package:vetconnect_app/main.dart';

void main() {
  testWidgets('La app arranca y muestra la pantalla de inicio',
      (WidgetTester tester) async {
    // Construye la app y dibuja un frame.
    await tester.pumpWidget(const VetConnectApp());

    // La pantalla de inicio debe mostrar el saludo y el botón "Comenzar".
    expect(find.text('Hola, VetConnect'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
