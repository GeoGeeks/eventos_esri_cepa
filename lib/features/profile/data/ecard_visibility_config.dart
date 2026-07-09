/// Configuración de qué campos se muestran en el e-card / QR.
/// Vive en memoria en ECardScreen y se pasa hacia el modal
/// y hacia el widget del QR.
class ECardVisibilityConfig {
  final bool cargo;
  final bool empresa;
  final bool correo;
  final bool telefono;

  const ECardVisibilityConfig({
    this.cargo = true,
    this.empresa = true,
    this.correo = true,
    this.telefono = true,
  });

  ECardVisibilityConfig copyWith({
    bool? cargo,
    bool? empresa,
    bool? correo,
    bool? telefono,
  }) {
    return ECardVisibilityConfig(
      cargo: cargo ?? this.cargo,
      empresa: empresa ?? this.empresa,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
    );
  }
}