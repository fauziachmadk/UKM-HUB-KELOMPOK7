import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:ukm_hub_server/api.dart';

Future<void> main() async {
  final data = File.fromUri(Platform.script.resolve('../data/ukm.json'));
  final items = (jsonDecode(await data.readAsString()) as List)
      .cast<Map<String, dynamic>>();
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final host = Platform.environment['HOST'] ?? '0.0.0.0';
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(createApi(items));
  final server = await shelf_io.serve(handler, host, port);
  final address = server.address.address;
  final browserHost = address == '0.0.0.0' || address == '::'
      ? 'localhost'
      : address;
  final catalogUrl = Uri(
    scheme: 'http',
    host: browserHost,
    port: server.port,
    path: '/ukm',
  );
  stdout.writeln('UKM Hub API aktif (${items.length} UKM).');
  stdout.writeln('Buka JSON di browser komputer: $catalogUrl');
}
