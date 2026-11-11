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
  test(
    'MockClient: filter bidang dan header dikirim, DateTime/bool diurai',
        () async {
      final api = ApiService(
        baseUrl: 'http://test.local/',
        client: MockClient((request) async {
          expect(request.url.path, '/ukm');
          expect(request.url.queryParameters, {'bidang': 'Seni'});
          expect(request.headers['Accept'], 'application/json');
          return http.Response(jsonEncode([fixtureJson().first]), 200);
        }),
      );
      addTearDown(api.close);
      final items = await api.getUkm(bidang: 'Seni');
      expect(items.first.berdiri, DateTime.utc(2016, 8, 17));
      expect(items.first.bukaRekrutmen, isTrue);
      expect(Ukm.fromJson(items.first.toJson()).toJson(), items.first.toJson());
    },
  );
  test('GET detail mengirim id dan mengurai model', () async {
    final api = ApiService(
      baseUrl: 'http://test.local',
      client: MockClient((request) async {
        expect(request.url.path, '/ukm/aksara');
        return http.Response(jsonEncode(fixtureJson().first), 200);
      }),
    );
    addTearDown(api.close);
    expect((await api.getUkmById('aksara')).nama, 'Aksara');
  });
  test(
    'HTTP 500 menjadi error yang dapat ditampilkan, tanpa data palsu',
        () async {
      final api = ApiService(
        client: MockClient((_) async => http.Response('{}', 500)),
      );
      addTearDown(api.close);
      await expectLater(api.getUkm(), throwsA(isA<ApiException>()));
    },
  );
  test('JSON rusak dan model tidak lengkap ditolak', () async {
    for (final body in ['not json', '[{"id":1}]', '{}']) {
      final api = ApiService(
        client: MockClient((_) async => http.Response(body, 200)),
      );
      await expectLater(api.getUkm(), throwsA(isA<ApiException>()));
      api.close();
    }
  });
  test('koneksi terputus menjadi ApiException', () async {
    final api = ApiService(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    addTearDown(api.close);
    await expectLater(api.getUkm(), throwsA(isA<ApiException>()));
  });
}
// END UKM07-ARIEF-MOCK-TESTS - ARIEF SAMPAI SINI.
