import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:tugas_uas/catatan.dart';
import 'package:tugas_uas/user.dart';

class FirebaseDatabaseUtil {
  DatabaseReference _counterRef;
  DatabaseReference _userRef;
  DatabaseReference _catatRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  FirebaseDatabase database = new FirebaseDatabase();
  int _counter;
  DatabaseError error;

  static final FirebaseDatabaseUtil _instance =
      new FirebaseDatabaseUtil.internal();

  FirebaseDatabaseUtil.internal();

  factory FirebaseDatabaseUtil() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _userRef = database.reference().child('user');
    _catatRef = database.reference().child('catatan');
    print(database);
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);
    _catatRef.keepSynced(true);

    _counterSubscription = _counterRef.onValue.listen((Event event) {
      error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (Object o) {
      error = o;
    });
  }

  DatabaseError getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference getUser() {
    return _userRef;
  }

  addUser(User user) async {
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    if (transactionResult.committed) {
      _userRef.push().set(<String, String>{
        "name": "" + user.name,
        "age": "" + user.age,
        "email": "" + user.email,
        "mobile": "" + user.mobile,
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }

  void deleteUser(User user) async {
    await _userRef.child(user.id).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void updateUser(User user) async {
    await _userRef.child(user.id).update({
      "name": "" + user.name,
      "age": "" + user.age,
      "email": "" + user.email,
      "mobile": "" + user.mobile,
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  DatabaseReference getCtt() {
    return _catatRef;
  }

  void addCatatan(Catatan ctt) async {
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    if (transactionResult.committed) {
      _catatRef.push().set(<String, String>{
        "judul": "" + ctt.judul,
        "isi": "" + ctt.isi
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }

  void editCatatan(Catatan ctt) async {
    await _catatRef
        .child(ctt.id)
        .update({"judul": "" + ctt.judul, "isi": "" + ctt.isi}).then((_) {
      print('Transaction  committed.');
    });
  }

  void deleteCatatan(Catatan ctt) async {
    await _catatRef.child(ctt.id).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}
