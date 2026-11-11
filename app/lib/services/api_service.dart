// Modul HTTP. Penanggung jawab: Arief Setiawan - 102022300098.
// Fondasi hanya menyediakan GET daftar dasar; lihat tugas di region.
import 'dart:async';
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

/// Client dapat disuntikkan agar tes memeriksa HTTP tanpa server sungguhan.
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

  Uri _uri(String path, [Map<String, String>? query]) => Uri.parse(
    '${_baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path',
  ).replace(queryParameters: query);

  Future<dynamic> _get(Uri uri) async {
    try {
      final response = await _client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        throw ApiException(
          response.statusCode == 404
              ? 'UKM tidak ditemukan.'
              : 'Server belum bisa memuat data (${response.statusCode}).',
        );
      }
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on TimeoutException {
      throw const ApiException('Server terlalu lama merespons. Coba lagi.');
    } on http.ClientException {
      throw const ApiException(
        'Tidak terhubung ke server. Periksa koneksi dan alamat API.',
      );
    } on FormatException {
      throw const ApiException('Format data server tidak valid.');
    }
  }

  /// Bidang dikirim sebagai query agar filter benar-benar dilakukan oleh API.
  Future<List<Ukm>> getUkm({String? bidang}) async {
    final data = await _get(
      _uri('/ukm', bidang == null ? null : {'bidang': bidang}),
    );
    try {
      return (data as List)
          .map((e) => Ukm.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ApiException('Data katalog dari server tidak lengkap.');
    }
  }

  Future<Ukm> getUkmById(String id) async {
    final data = await _get(_uri('/ukm/${Uri.encodeComponent(id)}'));
    try {
      return Ukm.fromJson(data as Map<String, dynamic>);
    } catch (_) {
      throw const ApiException('Data detail dari server tidak lengkap.');
    }
  }

  void close() => _client.close();
}
// END UKM07-ARIEF-HTTP - ARIEF SAMPAI SINI.
