// Tes integrasi widget dasar. Penanggung jawab: Arief Setiawan - 102022300098.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ukm_hub/core/app.dart';
import 'package:ukm_hub/models/ukm.dart';
import 'package:ukm_hub/screens/detail_page.dart';
import 'package:ukm_hub/services/api_service.dart';
import 'fixtures.dart';

// BEGIN UKM07-ARIEF-WIDGET-TESTS
// MULAI BAGIAN ARIEF.
// TODO(ARIEF): tambah Future loading terkontrol, filter/search,
// validasi form, mounted/batal, edit/hapus/undo dan konsistensi toggle tema.
// Tes baseline berikut adalah fondasi regresi, bukan cakupan QA final.
class FakeApi extends ApiService {
  bool failNext = false;
  @override
  Future<List<Ukm>> getUkm({String? bidang}) async {
    if (failNext) {
      failNext = false;
      throw const ApiException('Server uji sedang mati.');
    }
    return [fixtureUkm()];
  }
}

Future<void> start(WidgetTester tester) async {
  final api = FakeApi();
  addTearDown(api.close);
  await tester.pumpWidget(UkmHubApp(api: api));
  await tester.pumpAndSettle();
}

Future<void> register(WidgetTester tester) async {
  await tester.tap(find.text('Aksara'));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('register-ukm')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('form-nama')), 'Mahasiswa Demo');
  await tester.enterText(find.byKey(const Key('form-nim')), '001234567890');
  await tester.enterText(
    find.byKey(const Key('form-alasan')),
    'Belajar teater bersama.',
  );
  await tester.ensureVisible(find.byKey(const Key('save-registration')));
  await tester.tap(find.byKey(const Key('save-registration')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Coba lagi memulihkan katalog setelah request gagal', (
    tester,
  ) async {
    final api = FakeApi()..failNext = true;
    addTearDown(api.close);
    await tester.pumpWidget(UkmHubApp(api: api));
    await tester.pumpAndSettle();
    expect(find.text('Katalog belum tersedia'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();
    expect(find.text('Aksara'), findsOneWidget);
    expect(find.text('Coba lagi'), findsNothing);
  });

  testWidgets('tiga tab dapat dibuka dan katalog tetap tersedia', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('Pendaftaran Saya'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada minat'), findsOneWidget);
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Identitas belum diisi'), findsOneWidget);
    await tester.tap(find.text('Jelajah'));
    await tester.pumpAndSettle();
    expect(find.text('Aksara'), findsOneWidget);
  });

  testWidgets('kartu meneruskan Ukm ke konstruktor detail', (tester) async {
    await start(tester);
    await tester.tap(find.text('Aksara'));
    await tester.pumpAndSettle();
    expect(tester.widget<DetailPage>(find.byType(DetailPage)).ukm.id, 'aksara');
    expect(find.text('Saya berminat'), findsOneWidget);
  });

  testWidgets('hasil form langsung muncul dan UKM sama terkunci', (
    tester,
  ) async {
    await start(tester);
    await register(tester);
    expect(find.text('Mahasiswa Demo - 001234567890'), findsOneWidget);
    await tester.tap(find.text('Jelajah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aksara'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('register-ukm')))
          .onPressed,
      isNull,
    );
  });
}
// END UKM07-ARIEF-WIDGET-TESTS - ARIEF SAMPAI SINI.
