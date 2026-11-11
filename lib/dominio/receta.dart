/// Una receta es "rápida" si su tiempo total es a lo más este número de minutos.
const umbralRapidaMinutos = 30;

/// Dificultad de una receta, con su etiqueta en español para la interfaz.
enum Dificultad {
  facil('Fácil'),
  media('Media'),
  dificil('Difícil'),
  desconocida('Sin dato');

  const Dificultad(this.etiqueta);
  final String etiqueta;
}

/// Receta del dominio: no sabe nada de JSON, Dio ni Flutter.
class Receta {
  const Receta({
    required this.id,
    required this.nombre,
    required this.cocina,
    required this.dificultad,
    required this.minutosPreparacion,
    required this.minutosCoccion,
    required this.porciones,
    required this.calificacion,
    this.etiquetas = const [],
    this.ingredientes = const [],
  });

  final int id;
  final String nombre;
  final String cocina;
  final Dificultad dificultad;
  final int minutosPreparacion;
  final int minutosCoccion;
  final int porciones;
  final double calificacion;
  final List<String> etiquetas;
  final List<String> ingredientes;

  /// Minutos de preparación más minutos de cocción.
  int get tiempoTotal => minutosPreparacion + minutosCoccion;

  /// Verdadero si el tiempo total es a lo más [umbralRapidaMinutos].
  bool get esRapida => tiempoTotal <= umbralRapidaMinutos;
}

/// Una página de resultados: las recetas recibidas y el total que reporta el servidor.
class PaginaRecetas {
  const PaginaRecetas({required this.recetas, required this.total});

  final List<Receta> recetas;
  final int total;
}
