// Prueba de humo básica: verifica que la app arranca en la pantalla de bienvenida.
import 'package:flutter_test/flutter_test.dart';

import 'package:vetconnect_app/main.dart';

void main() {
  testWidgets('La app arranca y muestra la pantalla de bienvenida',
      (WidgetTester tester) async {
    // Construye la app y dibuja un frame.
    await tester.pumpWidget(const VetConnectApp());

    // La bienvenida debe mostrar el titular y el botón "Comenzar".
    expect(find.text('Bienvenido a VetConnect'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
  });
}
