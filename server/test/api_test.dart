// Tes backend. Penanggung jawab: Muhammad Aditya Djalil - 102022300225.
// Reviewer kontrak: Arief Setiawan. Koordinasikan giliran sebelum edit file sama.
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:ukm_hub_server/api.dart';

// BEGIN UKM07-DJALIL-API-TESTS
// MULAI BAGIAN DJALIL.
// TODO(DJALIL): naikkan pemeriksaan ke minimal 12 item dan kelengkapan field,
// tambah tes filter server, bidang tidak dikenal, dan detail valid.
void main() {
  final items = (jsonDecode(File('data/ukm.json').readAsStringSync()) as List)
      .cast<Map<String, dynamic>>();
  final api = createApi(items);
  test('dataset awal memiliki id unik dan tanggal yang dapat dibaca', () {
    expect(items.length, greaterThanOrEqualTo(5));
    expect(items.map((e) => e['id']).toSet().length, items.length);
    for (final item in items) {
      expect(item['bukaRekrutmen'], isA<bool>());
      expect(DateTime.tryParse(item['berdiri'] as String), isNotNull);
    }
  });
  test('GET katalog mengembalikan dataset', () async {
    final response = await api(
      Request('GET', Uri.parse('http://unit.test/ukm')),
    );
    expect(response.statusCode, 200);
    expect(
      (jsonDecode(await response.readAsString()) as List).length,
      items.length,
    );
  });
  test('id tidak dikenal mengembalikan 404', () async {
    final response = await api(
      Request('GET', Uri.parse('http://unit.test/ukm/tidak-ada')),
    );
    expect(response.statusCode, 404);
  });
}
// END UKM07-DJALIL-API-TESTS - DJALIL SAMPAI SINI.
