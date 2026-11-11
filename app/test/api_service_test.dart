// Tes HTTP tanpa server. Penanggung jawab: Arief Setiawan - 102022300098.
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ukm_hub/services/api_service.dart';
import 'fixtures.dart';

// BEGIN UKM07-ARIEF-MOCK-TESTS
// MULAI BAGIAN ARIEF.
// TODO(ARIEF): uji query bidang, detail, non-200, timeout/koneksi, JSON rusak,
// tipe field salah dan round-trip DateTime. Jangan bergantung server nyata.
void main() {
  test('GET katalog memakai base URL dan membaca model bertanggal', () async {
    final api = ApiService(
      baseUrl: 'http://unit.test:8080',
      client: MockClient((request) async {
        expect(request.url.toString(), 'http://unit.test:8080/ukm');
        return http.Response(jsonEncode([fixtureUkm().toJson()]), 200);
      }),
    );
    addTearDown(api.close);
    final items = await api.getUkm();
    expect(items.single.id, 'aksara');
    expect(items.single.berdiri, DateTime.utc(2016, 8, 17));
  });
}
// END UKM07-ARIEF-MOCK-TESTS - ARIEF SAMPAI SINI.
