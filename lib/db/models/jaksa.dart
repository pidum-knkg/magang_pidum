import 'package:flutter/material.dart';
import 'package:magang_pidum/db/db.dart';
import 'package:mongo_dart/mongo_dart.dart';

final jaksaColl = db!.collection("jaksa");

enum CabangJaksa {
  kejari("kejari"),
  kejati("kejati");

  const CabangJaksa(this.value);
  final String value;

  static CabangJaksa fromString(String type) {
    switch (type.toLowerCase()) {
      case "kejari":
        return CabangJaksa.kejari;
      case "kejati":
        return CabangJaksa.kejati;
      default:
        throw Exception("not implemented");
    }
  }
}

class Jaksa {
  const Jaksa({
    required this.id,
    required this.nama,
    required this.cabang,
  });

  final ObjectId id;
  final String nama;
  final CabangJaksa cabang;

  Map<String, dynamic> toMongoMap() {
    return {
      '_id': id,
      'nama': nama,
      'cabang': cabang.value,
    };
  }

  static Jaksa fromMongoMap(Map<String, dynamic> map) {
    debugPrint("Jaksa.fromMap: $map");
    return Jaksa(
      id: map['_id']!,
      nama: map['nama']!,
      cabang: CabangJaksa.fromString(map['cabang']!.toString()),
    );
  }

  static Future<Jaksa?> findId(ObjectId id) async {
    var result = await jaksaColl.findOne(where.eq("_id", id));

    if (result != null) {
      return fromMongoMap(result);
    }

    return null;
  }

  static Future<Jaksa?> create({
    required String nama,
    required CabangJaksa cabang,
  }) async {
    var result = await jaksaColl.insertOne({
      'nama': nama,
      'cabang': cabang.value,
    });

    if (result.document != null) {
      var document = result.document!;
      return Jaksa(
        id: document['_id']! as ObjectId,
        nama: document['nama']!.toString(),
        cabang: CabangJaksa.fromString(document['cabang']!.toString()),
      );
    }

    return null;
  }

  static Future<List<Jaksa>> getAll({
    CabangJaksa? cabang,
  }) async {
    debugPrint("getAll");
    var result = <Jaksa>[];
    SelectorBuilder? query;

    if (cabang != null) {
      query = where.eq('cabang', cabang.value);
    }

    late List<Map<String, dynamic>> docs;
    docs = await jaksaColl.find(query).toList();

    for (var doc in docs) {
      result.add(fromMongoMap(doc));
    }

    debugPrint(result.toString());
    return result;
  }
}
