import 'package:flutter/material.dart';
import 'package:magang_pidum/constants.dart';
import 'package:mongo_dart/mongo_dart.dart';

Db? db;

Future<void> setupDB() async {
  db = await Db.create(mongoURL);
  if (db == null) throw Exception("failed to create connection to $mongoURL");
  await db!.open();
  debugPrint("connected to $mongoURL");
}
