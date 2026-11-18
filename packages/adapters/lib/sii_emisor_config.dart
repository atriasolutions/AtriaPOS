/// Configuración fiscal emisor — puente piloto hasta RF-001.
class SiiEmisorConfig {
  const SiiEmisorConfig({
    required this.rutEmisor,
    required this.razonSocial,
    required this.giro,
  });

  final String rutEmisor;
  final String razonSocial;
  final String giro;

  factory SiiEmisorConfig.fromEnvironment() {
    const rut = String.fromEnvironment('SII_RUT_EMISOR', defaultValue: '00000000-0');
    const rs = String.fromEnvironment(
      'SII_RAZON_SOCIAL',
      defaultValue: 'Tienda demo',
    );
    const giro = String.fromEnvironment('SII_GIRO', defaultValue: 'Comercio');
    return SiiEmisorConfig(
      rutEmisor: rut,
      razonSocial: rs,
      giro: giro,
    );
  }

  bool get isConfigured => rutEmisor != '00000000-0';
}