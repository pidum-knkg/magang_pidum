import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Notif {
  Notif({
    required this.id,
    required this.pdm,
    this.readed = 0,
  });

  static late Database db;
  static String table = "notif";

  final int id;
  final String pdm;
  int readed;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'pdm': pdm,
      'readed': readed,
    };
  }

  Future<bool> save() async {
    try {
      await db.update(table, toMap(), where: "pdm=?", whereArgs: [pdm]);
    } catch (e) {
      debugPrint("$e");
      return false;
    }

    return true;
  }

  static Notif? fromMap(Map<String, Object?> map) {
    var id = map['id'];
    var pdm = map['pdm'];
    var readed = map['readed'];
    if (id == null ||
        pdm == null ||
        readed == null ||
        id.runtimeType != int ||
        pdm.runtimeType != String ||
        readed.runtimeType != int) return null;

    return Notif(
      id: id as int,
      pdm: pdm as String,
      readed: readed as int,
    );
  }

  static Future<List<Notif>> getAll() async {
    var rows = await db.query(table);
    var notif = rows.map((e) => Notif.fromMap(e)).nonNulls.toList();
    return notif;
  }

  static Future<Notif?> findFirstByPdm(String pdm) async {
    var results = await db.query(table, where: "pdm=?", whereArgs: [pdm]);
    var notif = results.isEmpty ? null : Notif.fromMap(results.first);
    debugPrint("findFirstByPdm $notif");
    return notif;
  }

  static Future<Notif> create({
    required String pdm,
    int readed = 0,
  }) async {
    var id = await db.insert(table, {
      'pdm': pdm,
      'readed': readed,
    });

    return Notif(
      id: id,
      pdm: pdm,
      readed: readed,
    );
  }

  @override
  String toString() {
    return "Notif {id: $id, pdm: $pdm, readed: $readed}";
  }

  static void init(Database db) {
    Notif.db = db;
    createTableIfNotExists();
  }

  static Future createTableIfNotExists() async {
    await db.execute(
      "create table if not exists $table (id integer primary key autoincrement, pdm text, readed integer default 0)",
    );
  }

  static Future deleteWherePDMNotInList(List<String> listPDM) async {
    await db.execute(
        'delete from $table where pdm not in (${listPDM.map((e) => "'$e'").join(", ")})');
  }

  static Future<List<Notif>> getAllByPDMNotInList(List<String> list) async {
    var rows = await db.rawQuery(
        'delete from $table where pdm not in (${list.map((e) => "'$e'").join(", ")})');
    List<Notif> result = [];
    for (var row in rows) {
      var notif = Notif.fromMap(row);
      if (notif != null) result.add(notif);
    }
    return result;
  }
}

class NotifDbServices {
  late Database _database;
  Database get database => _database;

  Future<NotifDbServices> init() async {
    debugPrint("${await getDatabasesPath()}dev.db");
    _database = await openDatabase(join(await getDatabasesPath(), "dev.db"));
    print(_database);
    Notif.init(_database);
    return this;
  }
}
