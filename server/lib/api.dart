import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Response _json(Object data, {int status = 200}) => Response(
  status,
  body: jsonEncode(data),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Handler createApi(List<Map<String, dynamic>> items) {
  final router = Router();
  router.get('/ukm', (Request request) {
    final bidang = request.url.queryParameters['bidang'];
    final result = bidang == null || bidang.isEmpty
        ? items
        : items
              .where(
                (item) =>
                    (item['bidang'] as String).toLowerCase() ==
                    bidang.toLowerCase(),
              )
              .toList();
    return _json(result);
  });
  router.get('/ukm/<id>', (Request request, String id) {
    final matches = items.where((item) => item['id'] == id);
    return matches.isEmpty
        ? _json({'error': 'UKM tidak ditemukan'}, status: 404)
        : _json(matches.first);
  });
  router.all(
    '/<ignored|.*>',
    (Request request) =>
        _json({'error': 'Endpoint tidak ditemukan'}, status: 404),
  );

  return (request) async {
    final response = request.method == 'OPTIONS'
        ? Response.ok('')
        : await router.call(request);
    return response.change(
      headers: {
        'access-control-allow-origin': '*',
        'access-control-allow-methods': 'GET, OPTIONS',
        'access-control-allow-headers': 'Content-Type, Accept',
        'cache-control': 'no-store',
      },
    );
  };
}
