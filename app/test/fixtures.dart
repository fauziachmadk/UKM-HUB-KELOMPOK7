// Data tes. Penanggung jawab: Arief Setiawan - 102022300098.
import 'package:ukm_hub/models/ukm.dart';

// BEGIN UKM07-ARIEF-FIXTURES
// MULAI BAGIAN ARIEF. Tambahkan fixture kasus rekrutmen tutup/JSON invalid.
Ukm fixtureUkm() => Ukm(
  id: 'aksara',
  nama: 'Aksara',
  bidang: 'Seni',
  ketua: 'Pengurus Demo',
  jumlahAnggota: 64,
  bukaRekrutmen: true,
  berdiri: DateTime.utc(2016, 8, 17),
  logo: 'assets/images/seni.svg',
  deskripsi: 'Komunitas teater contoh untuk pengujian.',
);
// END UKM07-ARIEF-FIXTURES - ARIEF SAMPAI SINI.
