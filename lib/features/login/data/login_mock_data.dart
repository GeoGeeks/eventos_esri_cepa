// lib/features/login/data/login_mock_data.dart

/// Datos de prueba del inicio de sesión.
///
/// ⚠️ MOCK — el proyecto no tiene backend todavía. Estos son los únicos
/// números de identificación que la app considera "registrados".
///
/// PENDIENTE: reemplazar por la validación real (endpoint o regla de negocio).
/// Mientras esto siga aquí, cualquier otro número lleva a la pantalla de
/// Verificación, que es el comportamiento esperado del flujo de Figma.
class LoginMockData {
  LoginMockData._();

  static const List<String> documentosRegistrados = [
    '1234567890',
    '0987654321',
  ];

  static bool estaRegistrado(String documento) =>
      documentosRegistrados.contains(documento.trim());
}
