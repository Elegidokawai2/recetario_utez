import '../dominio/receta.dart';

/// Traduce el texto de `difficulty` de DummyJSON. Nunca lanza error:
/// cualquier valor que no conozcamos (o `null`, o un número) es [Dificultad.desconocida].
Dificultad dificultadDesdeTexto(Object? valor) => switch (valor) {
      'Easy' => Dificultad.facil,
      'Medium' => Dificultad.media,
      'Hard' => Dificultad.dificil,
      _ => Dificultad.desconocida,
    };

/// Convierte un objeto de `recipes` en una [Receta].
///
/// Obligatorios: id, name, cuisine, prepTimeMinutes, cookTimeMinutes,
/// servings y rating. Si falta alguno o trae otro tipo → [FormatException].
/// `tags` e `ingredients` son opcionales (lista vacía si faltan).
Receta recetaDesdeJson(Map<String, dynamic> json) {
  return switch (json) {
    {
      'id': int id,
      'name': String nombre,
      'cuisine': String cocina,
      'prepTimeMinutes': int preparacion,
      'cookTimeMinutes': int coccion,
      'servings': int porciones,
      'rating': num calificacion,
    } =>
      Receta(
        id: id,
        nombre: nombre,
        cocina: cocina,
        dificultad: dificultadDesdeTexto(json['difficulty']),
        minutosPreparacion: preparacion,
        minutosCoccion: coccion,
        porciones: porciones,
        calificacion: calificacion.toDouble(),
        etiquetas: _textosOpcionales(json, 'tags'),
        ingredientes: _textosOpcionales(json, 'ingredients'),
      ),
    _ => throw const FormatException(
        'Receta inválida: falta un campo obligatorio o tiene otro tipo',
      ),
  };
}

/// Convierte la respuesta completa (`recipes` + `total`) en una [PaginaRecetas].
PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  return switch (json) {
    {'recipes': List<dynamic> recetas, 'total': int total} => PaginaRecetas(
        recetas: [
          for (final elemento in recetas)
            if (elemento is Map<String, dynamic>)
              recetaDesdeJson(elemento)
            else
              throw const FormatException('Cada receta debe ser un objeto'),
        ],
        total: total,
      ),
    _ => throw const FormatException(
        'Página inválida: faltan "recipes" o "total"',
      ),
  };
}

/// Lee una lista opcional de textos. Si la llave no existe → lista vacía.
/// Si existe pero no es lista, o algún elemento no es texto → [FormatException].
List<String> _textosOpcionales(Map<String, dynamic> json, String llave) {
  final valor = json[llave];
  if (valor == null) return const [];
  if (valor is! List) {
    throw FormatException('"$llave" debe ser una lista');
  }
  final textos = <String>[];
  for (final elemento in valor) {
    if (elemento is! String) {
      throw FormatException('"$llave" solo puede tener textos');
    }
    textos.add(elemento);
  }
  return textos;
}
