import 'package:firebase_database/firebase_database.dart';

class Catatan {
  String _id;
  String _judul;
  String _isi;

  Catatan(this._id, this._judul, this._isi);

  String get judul => _judul;

  String get isi => _isi;

  String get id => _id;

  Catatan.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _judul = snapshot.value['judul'];
    _isi = snapshot.value['isi'];
  }
}
