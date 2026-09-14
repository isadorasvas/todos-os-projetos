import 'package:flutter_test/flutter_test.dart';
import 'package:cep_app/main.dart';

void main() {
  testWidgets('Tela de consulta de CEP aparece', (WidgetTester tester) async {
    await tester.pumpWidget(const CepApp());

    expect(find.text('Consulta de CEP (ViaCEP API)'), findsOneWidget);
    expect(find.text('Informe o CEP (somente números)'), findsOneWidget);
    expect(find.text('Buscar Endereço'), findsOneWidget);
  });
}