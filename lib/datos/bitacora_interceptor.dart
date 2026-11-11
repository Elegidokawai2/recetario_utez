import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Escribe una línea por petición, respuesta y error.
///
/// Solo registra método, ruta, código, tipo de error y tiempo. Nunca lo que
/// la persona buscó: eso viaja en la query, por eso se usa la ruta y no la URI.
class BitacoraInterceptor extends Interceptor {
  BitacoraInterceptor({void Function(String linea)? escribir})
      : _escribir = escribir ?? _escribirEnLog;

  final void Function(String linea) _escribir;

  static const _llaveReloj = 'bitacora_reloj';

  static void _escribirEnLog(String linea) =>
      developer.log(linea, name: 'recetario');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_llaveReloj] = Stopwatch()..start();
    _escribir('→ ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final o = response.requestOptions;
    _escribir(
      '← ${response.statusCode} ${o.method} ${o.path} (${_milisegundos(o)} ms)',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final o = err.requestOptions;
    final codigo = err.response?.statusCode;
    final partes = [
      '✗',
      err.type.name,
      if (codigo != null) '$codigo',
      o.method,
      o.path,
      '(${_milisegundos(o)} ms)',
    ];
    _escribir(partes.join(' '));
    handler.next(err);
  }

  int _milisegundos(RequestOptions o) {
    final reloj = o.extra[_llaveReloj];
    return reloj is Stopwatch ? reloj.elapsedMilliseconds : 0;
  }
}
