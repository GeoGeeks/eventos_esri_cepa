import '../../profile/data/ecard_mock_data.dart';

class LoginMockData {
  LoginMockData._();


  static const List<String> documentosRegistrados = [
    EcardMockData.documento,
    '0987654321',
  ];

  static bool estaRegistrado(String documento) =>
      documentosRegistrados.contains(documento.trim());
}
