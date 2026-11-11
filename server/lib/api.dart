// Modul API. Penanggung jawab: Muhammad Aditya Djalil - 102022300225.
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

// BEGIN UKM07-DJALIL-ROUTES
// MULAI BAGIAN DJALIL.
// TODO(DJALIL): implementasikan filter bidang sungguhan, kontrak kasus kosong,
// tes query/detail/404, dan validasi dataset 12+ UKM. Jangan kembalikan semua
// item seolah filter sudah bekerja. Baseline menandai query belum siap (501).
Response _json(Object value, {int status = 200}) => Response(
  status,
  body: jsonEncode(value),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Handler createApi(List<Map<String, dynamic>> items) {
  final router = Router();
  router.get('/ukm', (Request request) {
    if (request.url.queryParameters.containsKey('bidang')) {
      return _json({
        'error': 'Filter bidang belum diimplementasikan pada kerangka.',
      }, status: 501);
    }
    return _json(items);
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
  return router.call;
}
// END UKM07-DJALIL-ROUTES - DJALIL SAMPAI SINI.
