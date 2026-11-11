// Tes integrasi widget dasar. Penanggung jawab: Arief Setiawan - 102022300098.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ukm_hub/core/app.dart';
import 'package:ukm_hub/models/pendaftaran.dart';
import 'package:ukm_hub/models/ukm.dart';
import 'package:ukm_hub/screens/detail_page.dart';
import 'package:ukm_hub/screens/registration_form.dart';
import 'package:ukm_hub/services/api_service.dart';
import 'fixtures.dart';

// BEGIN UKM07-ARIEF-WIDGET-TESTS
// MULAI BAGIAN ARIEF.
// TODO(ARIEF): tambah Future loading terkontrol, filter/search,
// validasi form, mounted/batal, edit/hapus/undo dan konsistensi toggle tema.
// Tes baseline berikut adalah fondasi regresi, bukan cakupan QA final.
class FakeApi extends ApiService {
  Future<List<Ukm>> Function(String?)? handler;
  final calls = <String?>[];
  @override
  Future<List<Ukm>> getUkm({String? bidang}) {
    calls.add(bidang);
    return handler?.call(bidang) ??
        Future.value(
          fixtureUkm()
              .where((u) => bidang == null || u.bidang == bidang)
              .toList(),
        );
  }
}

Future<void> start(WidgetTester tester, FakeApi api) async {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(api.close);
  await tester.pumpWidget(UkmHubApp(api: api));
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> submitAksara(
    WidgetTester tester, {
      String nim = '00012345678',
    }) async {
  await tapVisible(tester, find.text('Aksara'));
  await tester.tap(find.byKey(const Key('register-ukm')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('form-nama')), 'Penguji Demo');
  await tester.enterText(find.byKey(const Key('form-nim')), nim);
  await tester.enterText(
    find.byKey(const Key('form-alasan')),
    'Ingin belajar teater dan menulis naskah bersama.',
  );
  await tapVisible(tester, find.byKey(const Key('save-registration')));
}

void main() {
  testWidgets('loading -> error -> retry -> sukses dari API', (tester) async {
    tester.view.physicalSize = const Size(420, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final request = Completer<List<Ukm>>();
    final api = FakeApi()..handler = (_) => request.future;
    await tester.pumpWidget(UkmHubApp(api: api));
    expect(find.text('Memuat komunitas...'), findsOneWidget);
    request.completeError(const ApiException('Server mati'));
    await tester.pumpAndSettle();
    expect(find.text('Server mati'), findsOneWidget);
    api.handler = (_) async => fixtureUkm();
    await tapVisible(tester, find.text('Coba lagi'));
    expect(find.text('Aksara'), findsOneWidget);
    api.close();
  });

  testWidgets(
    'filter server, cari lokal, kosong dan IndexedStack mempertahankan query',
        (tester) async {
      final api = FakeApi();
      await start(tester, api);
      await tapVisible(tester, find.widgetWithText(ChoiceChip, 'Seni'));
      expect(api.calls.last, 'Seni');
      final requests = api.calls.length;
      await tester.enterText(find.byKey(const Key('search-ukm')), 'tak ada');
      await tester.pumpAndSettle();
      expect(find.text('Belum ada yang cocok'), findsOneWidget);
      expect(api.calls.length, requests);
      await tester.tap(find.text('Profil').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jelajah').last);
      await tester.pumpAndSettle();
      expect(find.text('tak ada'), findsOneWidget);
    },
  );

  testWidgets(
    'detail -> validasi form -> hasil langsung di daftar, ubah dan hapus undo',
        (tester) async {
      await start(tester, FakeApi());
      await tapVisible(tester, find.text('Aksara'));
      await tester.tap(find.byKey(const Key('register-ukm')));
      await tester.pumpAndSettle();
      await tapVisible(tester, find.byKey(const Key('save-registration')));
      expect(find.text('Isi nama minimal 2 karakter.'), findsOneWidget);
      await tester.enterText(
        find.byKey(const Key('form-nama')),
        'Penguji Demo',
      );
      await tester.enterText(find.byKey(const Key('form-nim')), '00012345678');
      await tester.enterText(
        find.byKey(const Key('form-alasan')),
        'Ingin belajar teater dan bekerja bersama.',
      );
      await tapVisible(tester, find.byKey(const Key('save-registration')));
      expect(find.text('Penguji Demo'), findsOneWidget);
      expect(find.text('NIM 00012345678'), findsOneWidget);
      expect(find.text('Minat berhasil disimpan.'), findsOneWidget);
      await tapVisible(tester, find.text('Ubah'));
      await tester.enterText(
        find.byKey(const Key('form-alasan')),
        'Alasan baru yang sudah diperbarui.',
      );
      await tapVisible(tester, find.byKey(const Key('save-registration')));
      expect(find.text('Alasan baru yang sudah diperbarui.'), findsOneWidget);
      await tapVisible(tester, find.text('Hapus'));
      await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
      await tester.pumpAndSettle();
      expect(find.text('Cerita kamu dimulai di sini'), findsOneWidget);
      await tester.tap(find.text('Urungkan'));
      await tester.pumpAndSettle();
      expect(find.text('Penguji Demo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('form menolak UKM yang sudah didaftar meskipun NIM berbeda', (
      tester,
      ) async {
    final ukm = fixtureUkm().first;
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationForm(
          ukm: ukm,
          namaAwal: 'Demo',
          nimAwal: '00087654321',
          registrations: [
            Pendaftaran(
              nama: 'Demo',
              nim: '00012345678',
              ukm: ukm,
              alasan: 'Alasan contoh',
              tanggal: DateTime(2026),
            ),
          ],
        ),
      ),
    );
    expect(
      find.byKey(const Key('duplicate-registration-message')),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('save-registration')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('save-registration')))
          .onPressed,
      isNull,
    );
  });

  testWidgets('rekrutmen tertutup tidak dapat membuka form', (tester) async {
    await start(
      tester,
      FakeApi()
        ..handler = (_) async => [
          fixtureUkm().firstWhere((u) => !u.bukaRekrutmen),
        ],
    );
    await tapVisible(tester, find.text('Lensa Kampus'));
    final button = tester.widget<FilledButton>(
      find.byKey(const Key('register-ukm')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('tema gelap dan lebar 320 dengan teks besar tidak overflow', (
      tester,
      ) async {
    await start(tester, FakeApi());
    await tester.tap(find.text('Profil').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Gelap'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Ruang kamu.'))).brightness,
      Brightness.dark,
    );
    tester.view.physicalSize = const Size(320, 850);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.tap(find.text('Jelajah').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('UKM terdaftar dikunci di kartu/detail, UKM lain tetap terbuka', (
      tester,
      ) async {
    await start(tester, FakeApi());
    await submitAksara(tester);
    await tester.tap(find.text('Jelajah').last);
    await tester.pumpAndSettle();
    expect(find.text('Sudah terdaftar'), findsOneWidget);
    await tapVisible(tester, find.text('Aksara'));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('register-ukm')))
          .onPressed,
      isNull,
    );
    expect(find.text('Sudah terdaftar'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Kode Kolektif'));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('register-ukm')))
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byKey(const Key('register-ukm')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('form-nama')), 'Penguji Demo');
    await tester.enterText(find.byKey(const Key('form-nim')), '00012345678');
    await tester.enterText(
      find.byKey(const Key('form-alasan')),
      'Ingin belajar membangun aplikasi bersama.',
    );
    await tapVisible(tester, find.byKey(const Key('save-registration')));
    expect(find.text('2 minat tersimpan • hanya sesi ini'), findsOneWidget);
  });

  testWidgets('hapus membuka pendaftaran kembali dan undo menguncinya lagi', (
      tester,
      ) async {
    await start(tester, FakeApi());
    await submitAksara(tester);
    await tapVisible(tester, find.text('Hapus'));
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jelajah').last);
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Aksara'));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('register-ukm')))
          .onPressed,
      isNotNull,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Aksara'));
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('register-ukm')))
          .onPressed,
      isNull,
    );
  });

  testWidgets(
    'ubah minat sendiri tetap dapat menyimpan tanpa dianggap duplikat',
        (tester) async {
      final ukm = fixtureUkm().first;
      final record = Pendaftaran(
        nama: 'Demo',
        nim: '00012345678',
        ukm: ukm,
        alasan: 'Alasan awal untuk bergabung.',
        tanggal: DateTime(2026),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: RegistrationForm(
            ukm: ukm,
            initial: record,
            registrations: [record],
          ),
        ),
      );
      expect(
        find.byKey(const Key('duplicate-registration-message')),
        findsNothing,
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('save-registration')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(
        tester
            .widget<FilledButton>(find.byKey(const Key('save-registration')))
            .onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'tombol tema di header sinkron dengan Profil tanpa memuat ulang katalog',
        (tester) async {
      final api = FakeApi();
      await start(tester, api);
      final requestCount = api.calls.length;
      await tester.tap(find.byKey(const Key('theme-toggle')));
      await tester.pumpAndSettle();
      expect(
        Theme.of(
          tester.element(find.byKey(const Key('theme-toggle'))),
        ).brightness,
        Brightness.dark,
      );
      expect(find.byTooltip('Aktifkan tema terang'), findsOneWidget);
      await tester.tap(find.text('Profil').last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Gelap'))
            .selected,
        isTrue,
      );
      await tester.tap(find.widgetWithText(ChoiceChip, 'Terang'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jelajah').last);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Aktifkan tema gelap'), findsOneWidget);
      expect(api.calls.length, requestCount);
    },
  );

  testWidgets('detail dan form mempertahankan identitas UKM saat digulir', (
      tester,
      ) async {
    await start(tester, FakeApi());
    await tapVisible(tester, find.text('Aksara'));
    expect(find.text('Tentang Aksara'), findsOneWidget);
    await tester.drag(
      find.byKey(const Key('detail-scroll')),
      const Offset(0, -650),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Aksara')),
      findsOneWidget,
    );
    expect(find.text('Minat bergabung dengan Aksara'), findsOneWidget);
    await tester.tap(find.byKey(const Key('register-ukm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('form-ukm-context')), findsOneWidget);
    expect(find.text('Daftar Aksara'), findsOneWidget);
    expect(find.textContaining('bergabung dengan Aksara'), findsOneWidget);
  });

  testWidgets(
    'detail dan form nama panjang tetap muat pada layar sempit bertema gelap',
        (tester) async {
      tester.view.physicalSize = const Size(320, 850);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final ukm = Ukm.fromJson({
        ...fixtureJson().first,
        'nama': 'Komunitas Seni Pertunjukan dan Penulisan Kampus',
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: DetailPage(ukm: ukm, registrations: const []),
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(const Key('detail-scroll')),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byKey(const Key('register-ukm')));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView).last, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
// END UKM07-ARIEF-WIDGET-TESTS - ARIEF SAMPAI SINI.
