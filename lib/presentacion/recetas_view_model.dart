import 'package:flutter/foundation.dart';

import '../datos/recetas_repositorio.dart';
import '../dominio/falla_red.dart';
import '../dominio/receta.dart';
import 'mensajes.dart';

/// Estados excluyentes de la pantalla: solo uno a la vez.
sealed class EstadoRecetas {
  const EstadoRecetas();
}

/// Aún no se ha buscado nada.
final class RecetasInicial extends EstadoRecetas {
  const RecetasInicial();
}

/// La petición va en camino.
final class RecetasCargando extends EstadoRecetas {
  const RecetasCargando();
}

/// Llegaron recetas.
final class RecetasListas extends EstadoRecetas {
  const RecetasListas(this.recetas, this.total);
  final List<Receta> recetas;
  final int total;
}

/// La búsqueda respondió bien, pero sin resultados.
final class RecetasVacias extends EstadoRecetas {
  const RecetasVacias(this.busqueda);
  final String busqueda;
}

/// Algo falló; [mensaje] ya está listo para mostrarse.
final class RecetasFallidas extends EstadoRecetas {
  const RecetasFallidas(this.mensaje);
  final String mensaje;
}

/// Coordina la búsqueda: pide al repositorio y expone el estado a la vista.
class RecetasViewModel extends ChangeNotifier {
  RecetasViewModel(this._repositorio);

  final RecetasRepositorio _repositorio;

  EstadoRecetas _estado = const RecetasInicial();
  String _ultimaBusqueda = '';
  bool _desechado = false;

  EstadoRecetas get estado => _estado;

  bool get cargando => _estado is RecetasCargando;

  String get ultimaBusqueda => _ultimaBusqueda;

  int get rapidas => switch (_estado) {
        RecetasListas(:final recetas) =>
          recetas.where((r) => r.esRapida).length,
        _ => 0,
      };

  Future<void> buscar(String texto) async {
    if (cargando) return;
    _ultimaBusqueda = texto.trim();
    _cambiar(const RecetasCargando());
    try {
      final pagina = await _repositorio.buscar(texto: _ultimaBusqueda);
      _estado = pagina.recetas.isEmpty
          ? RecetasVacias(_ultimaBusqueda)
          : RecetasListas(pagina.recetas, pagina.total);
    } on FallaRed catch (falla) {
      _estado = RecetasFallidas(mensajePara(falla));
    } catch (_) {
      _estado = const RecetasFallidas(mensajeInesperado);
    }
    _avisar();
  }

  Future<void> reintentar() => buscar(_ultimaBusqueda);

  void _cambiar(EstadoRecetas nuevo) {
    _estado = nuevo;
    _avisar();
  }

  void _avisar() {
    if (!_desechado) notifyListeners();
  }

  @override
  void dispose() {
    _desechado = true;
    super.dispose();
  }
}
