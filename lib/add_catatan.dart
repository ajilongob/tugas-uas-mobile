import 'package:flutter/material.dart';
import 'package:tugas_uas/catatan.dart';

class AddCatatan {
  final teJudul = TextEditingController();
  final teIsi = TextEditingController();

  Catatan ctt;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(BuildContext context,
      AddCatatanCallback _myHomePageState, bool isEdit, Catatan ctt) {
    if (ctt != null) {
      this.ctt = ctt;
      teJudul.text = ctt.judul;
      teIsi.text = ctt.isi;
    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Judul", teJudul),
            getTextFieldIsi("Isi", teIsi),
            new GestureDetector(
              onTap: () => onTap(isEdit, _myHomePageState, context),
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(
                    isEdit ? "Edit Catatan" : "Tambah Catatan",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var textfield = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return textfield;
  }

  Widget getTextFieldIsi(
      String inputBoxName, TextEditingController inputBoxController) {
    var textfield = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
          border: OutlineInputBorder(),
        ),
        maxLines: 7,
      ),
    );

    return textfield;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF02BB9F)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF02BB9F),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Catatan getData(bool isEdit) {
    return new Catatan(isEdit ? ctt.id : "", teJudul.text, teIsi.text);
  }

  onTap(
      bool isEdit, AddCatatanCallback _myHomePageState, BuildContext context) {
    if (isEdit) {
      _myHomePageState.upCtt(getData(isEdit));
      Navigator.of(context).pop();
    } else {
      _myHomePageState.addCtt(getData(isEdit));
      Navigator.of(context).pop();
    }
  }
}

abstract class AddCatatanCallback {
  void addCtt(Catatan ctt);

  void upCtt(Catatan ctt);
}
