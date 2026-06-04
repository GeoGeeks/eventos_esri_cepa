import 'package:flutter_test/flutter_test.dart';
import 'package:esri_eventos/main.dart';

void main() {
  testWidgets('EsriEventos smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EsriEventosApp());

    expect(find.text('Inicio'), findsOneWidget);
  });
}