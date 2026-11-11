import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:ukm_hub_server/api.dart';

void main() {
  final data = (jsonDecode(File('data/ukm.json').readAsStringSync()) as List)
      .cast<Map<String, dynamic>>();
  final api = createApi(data);
  Future<Response> get(String path) async =>
      api(Request('GET', Uri.parse('http://localhost$path')));

  test('dataset memiliki >=12 UKM, id unik, tipe dan seluruh bidang wajib', () {
    expect(data.length, greaterThanOrEqualTo(12));
    expect(data.map((e) => e['id']).toSet().length, data.length);
    expect(data.map((e) => e['bidang']).toSet(), {
      'Seni',
      'Olahraga',
      'Teknologi',
      'Keagamaan',
      'Sosial',
    });
    for (final item in data) {
      expect(item['jumlahAnggota'], isA<int>());
      expect(item['bukaRekrutmen'], isA<bool>());
      expect(DateTime.tryParse(item['berdiri'] as String), isNotNull);
      expect(File('../app/${item['logo']}').existsSync(), isTrue);
    }
  });
  test('GET daftar mengembalikan JSON utf8 dan semua UKM', () async {
    final response = await get('/ukm');
    expect(response.statusCode, 200);
    expect(response.headers['content-type'], contains('application/json'));
    expect(
      (jsonDecode(await response.readAsString()) as List).length,
      data.length,
    );
  });
  test('GET khas benar-benar memfilter bidang server-side', () async {
    final response = await get('/ukm?bidang=Teknologi');
    final items = jsonDecode(await response.readAsString()) as List;
    expect(items, isNotEmpty);
    expect(items.every((e) => e['bidang'] == 'Teknologi'), isTrue);
    expect(items.length, lessThan(data.length));
  });
  test('GET detail benar dan id tidak ada menghasilkan 404', () async {
    expect(
      jsonDecode(await (await get('/ukm/aksara')).readAsString())['nama'],
      'Aksara',
    );
    expect((await get('/ukm/tidak-ada')).statusCode, 404);
    expect((await get('/unknown')).statusCode, 404);
  });
  test('filter tidak ada menghasilkan daftar kosong', () async {
    expect(
      jsonDecode(await (await get('/ukm?bidang=Invalid')).readAsString()),
      isEmpty,
    );
  });
}
