// Modul HTTP. Penanggung jawab: Arief Setiawan - 102022300098.
// Fondasi hanya menyediakan GET daftar dasar; lihat tugas di region.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ukm.dart';

// BEGIN UKM07-ARIEF-HTTP
// MULAI BAGIAN ARIEF. Kontrak publik jangan diubah tanpa Fauzi.
// TODO(ARIEF): tambahkan timeout, error jaringan/status/JSON yang spesifik,
// validasi respons, encoding query bidang, dan GET detail yang sesungguhnya.
// Uji seluruh jalur memakai MockClient; jangan memakai fallback data palsu.
class ApiException implements Exception {
  const ApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Client disuntikkan supaya tes tidak bergantung server jaringan.
class ApiService {
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'API_URL',
            defaultValue: 'http://10.0.2.2:8080',
          );
  final http.Client _client;
  final String _baseUrl;

  Future<List<Ukm>> getUkm({String? bidang}) async {
    // Filter belum dihubungkan: Arief mengirim query setelah kontrak Djalil siap.
    if (bidang != null) {
      throw const ApiException(
        'Filter bidang belum diimplementasikan pada kerangka.',
      );
    }
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/ukm'));
      if (response.statusCode != 200) {
        throw ApiException('API gagal (${response.statusCode}).');
      }
      final json = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return json
          .map((item) => Ukm.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'Katalog belum dapat dimuat. Periksa server dan API_URL.',
      );
    }
  }

  Future<Ukm> getUkmById(String id) async {
    throw const ApiException('Endpoint detail belum dihubungkan oleh Arief.');
  }

  void close() => _client.close();
}
// END UKM07-ARIEF-HTTP - ARIEF SAMPAI SINI.
