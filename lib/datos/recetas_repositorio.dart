import '../dominio/receta.dart';

/// Contrato de la fuente de recetas. La presentación solo conoce esto,
/// nunca a Dio ni a DummyJSON.
abstract class RecetasRepositorio {
  /// Busca recetas. Texto vacío = recetas en general.
  /// Si algo falla, lanza una [FallaRed].
  Future<PaginaRecetas> buscar({String texto = ''});
}
