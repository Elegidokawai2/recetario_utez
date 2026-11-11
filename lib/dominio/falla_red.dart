/// Fallas posibles al pedir recetas. Es `sealed`: un `switch` sobre
/// [FallaRed] obliga a contemplar todos los casos.
sealed class FallaRed implements Exception {
  const FallaRed();
}

/// No se pudo llegar al servidor (sin red, DNS, conexión rechazada…).
final class SinConexion extends FallaRed {
  const SinConexion();
}

/// El servidor tardó más que los timeouts configurados.
final class TiempoAgotado extends FallaRed {
  const TiempoAgotado();
}

/// El servidor respondió con un código 5xx.
final class ErrorDelServidor extends FallaRed {
  const ErrorDelServidor(this.codigo);
  final int codigo;
}

/// El servidor respondió con un código 4xx (u otro no exitoso que no es 5xx).
final class PeticionRechazada extends FallaRed {
  const PeticionRechazada(this.codigo);
  final int codigo;
}

/// La respuesta llegó, pero no tiene la forma que esperamos.
final class RespuestaInvalida extends FallaRed {
  const RespuestaInvalida();
}
