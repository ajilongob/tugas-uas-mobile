import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:tugas_uas/add_catatan.dart';
import 'package:tugas_uas/catatan.dart';

import 'add_user_dialog.dart';
import 'firebase_database_util.dart';
import 'user.dart';

class UserDashboard extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<UserDashboard>
    implements AddCatatanCallback {
  bool _anchorToBottom = false;
  FirebaseDatabaseUtil databaseUtil;

  @override
  void initState() {
    super.initState();
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
  }

  @override
  void dispose() {
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTitle(BuildContext context) {
      return new InkWell(
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Catatan',
                style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> _buildActions() {
      return <Widget>[
        new IconButton(
          icon: const Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          onPressed: () => showEditCatatanWidget(null, false),
        ),
        //   new IconButton(
        //     icon: const Icon(
        //       Icons.group_add,
        //       color: Colors.white,
        //     ),
        //     onPressed: () => showEditWidget(null, false),
        //   ),
      ];
    }

    return new Scaffold(
      appBar: new AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body: new FirebaseAnimatedList(
        key: new ValueKey<bool>(_anchorToBottom),
        query: databaseUtil.getCtt(),
        reverse: _anchorToBottom,
        sort: _anchorToBottom
            ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            : null,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return new SizeTransition(
            sizeFactor: animation,
            child: showUser(snapshot),
          );
        },
      ),
    );
  }

  @override
  void addCtt(Catatan ctt) {
    setState(() {
      databaseUtil.addCatatan(ctt);
    });
  }

  @override
  void upCtt(Catatan ctt) {
    setState(() {
      databaseUtil.editCatatan(ctt);
    });
  }

  Widget showUser(DataSnapshot res) {
    // User user = User.fromSnapshot(res);
    Catatan ctt = Catatan.fromSnapshot(res);

    var item = new Card(
      child: new Container(
          child: new Center(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          ctt.judul,
                          // set some style to text
                          style: new TextStyle(
                              fontSize: 20.0, color: const Color(0xFF02BB9F)),
                        ),
                      ],
                    ),
                  ),
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.lightBlueAccent,
                      ),
                      onPressed: () => showEditCatatanWidget(ctt, true),
                    ),
                    new IconButton(
                      icon: const Icon(Icons.delete_forever,
                          color: const Color(0xFFFB2A3F)),
                      onPressed: () => deleteCatatan(ctt),
                    ),
                  ],
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
    );

    return item;
  }

  String getShortName(User user) {
    String shortName = "";
    if (!user.name.isEmpty) {
      shortName = user.name.substring(0, 1);
    }
    return shortName;
  }

  // showEditWidget(User user, bool isEdit) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         new AddUserDialog().buildAboutDialog(context, this, isEdit, user),
  //   );
  // }

  showEditCatatanWidget(Catatan ctt, bool isEdit) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          new AddCatatan().buildAboutDialog(context, this, isEdit, ctt),
    );
  }

  deleteCatatan(Catatan ctt) {
    setState(() {
      databaseUtil.deleteCatatan(ctt);
    });
  }
}
