import 'package:dio/dio.dart';

import 'bitacora_interceptor.dart';

/// Servidor de recetas. Siempre por HTTPS.
const urlDummyJson = 'https://dummyjson.com';

/// Crea el cliente Dio de la app: base HTTPS, timeouts prudentes y bitácora.
///
/// La [BitacoraInterceptor] va primero; después, los [interceptores] extra
/// (por ejemplo, los cambios temporales de la etapa 6).
Dio crearDioRecetas({List<Interceptor> interceptores = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: urlDummyJson,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors
    ..add(BitacoraInterceptor())
    ..addAll(interceptores);
  return dio;
}
