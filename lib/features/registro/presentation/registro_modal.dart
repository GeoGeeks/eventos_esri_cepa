import 'package:flutter/widgets.dart';

import '../../../core/widgets/formulario_web_modal.dart';

/// Ventana de **Registro** — `assets/views/Ventana evento.svg`.
///
/// Es el [FormularioWebModal] con el formulario público del evento. La
/// geometría, el velo y la aspa de cerrar viven allí; aquí solo el título y la
/// dirección, que es lo único que cambia entre esta ventana y «Agendar».
class RegistroModal {
  RegistroModal._();

  static const String titulo = 'Registro';

  /// Formulario público de registro de [idEvento] (`IDEvento` de
  /// eventosdb). Antes era fijo el de Planeta Esri Bogotá, así que
  /// «Registrarse» abría ese formulario en cualquier evento.
  static String urlDe(String idEvento) =>
      'https://registroeventos.esri.co/registro-publico/'
      '${Uri.encodeComponent(idEvento)}';

  static Future<void> mostrar(
    BuildContext context, {
    required String idEvento,
  }) {
    return FormularioWebModal.mostrar(
      context,
      titulo: titulo,
      url: urlDe(idEvento),
    );
  }
}
