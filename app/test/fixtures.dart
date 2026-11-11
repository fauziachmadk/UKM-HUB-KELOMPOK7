// Data tes. Penanggung jawab: Arief Setiawan - 102022300098.
import 'dart:convert';
import 'dart:io';
import 'package:ukm_hub/models/ukm.dart';

// BEGIN UKM07-ARIEF-FIXTURES
// MULAI BAGIAN ARIEF. Tambahkan fixture kasus rekrutmen tutup/JSON invalid.
List<Map<String, dynamic>> fixtureJson() =>
    (jsonDecode(File('../server/data/ukm.json').readAsStringSync()) as List)
        .cast<Map<String, dynamic>>();
List<Ukm> fixtureUkm() => fixtureJson().map(Ukm.fromJson).toList();
// END UKM07-ARIEF-FIXTURES - ARIEF SAMPAI SINI.
