// Bootstrap server. Penanggung jawab: Muhammad Aditya Djalil - 102022300225.
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:ukm_hub_server/api.dart';

// BEGIN UKM07-DJALIL-BOOTSTRAP
// MULAI BAGIAN DJALIL.
// TODO(DJALIL): validasi data startup dan pesan error JSON/port yang membantu;
// tambahkan middleware yang relevan. Tetap tampilkan URL tujuan browser.
Future<void> main() async {
  final file = File.fromUri(Platform.script.resolve('../data/ukm.json'));
  final items = (jsonDecode(await file.readAsString()) as List)
      .cast<Map<String, dynamic>>();
  final host = Platform.environment['HOST'] ?? '0.0.0.0';
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await shelf_io.serve(createApi(items), host, port);
  stdout.writeln(
    'UKM Hub KERANGKA aktif (${items.length} UKM contoh; belum dataset final).',
  );
  stdout.writeln(
    'Buka JSON di browser komputer: http://localhost:${server.port}/ukm',
  );
}
// END UKM07-DJALIL-BOOTSTRAP - DJALIL SAMPAI SINI.
