import 'package:flutter/material.dart';
import 'package:magang_pidum/db/db.dart';
import 'package:mongo_dart/mongo_dart.dart';

final perkaraColl = db!.collection('perkara');

enum StatusBarangBukti {
  adaP34("Ada P-34"),
  tidakAda("Tidak Ada"),
  dititipBA6("Dititip/BA-6");

  const StatusBarangBukti(this.value);
  final String value;

  static StatusBarangBukti fromString(String type) {
    debugPrint("StatusBarangBukti.fromString $type");
    switch (type) {
      case "Ada P-34":
        return StatusBarangBukti.adaP34;
      case "Tidak Ada":
        return StatusBarangBukti.tidakAda;
      case "Dititip/BA-6":
        return StatusBarangBukti.dititipBA6;
      default:
        throw Exception("not implemented");
    }
  }
}

class Perkara {
  const Perkara({
    required this.id,
    required this.pdm,
    required this.t7,
    required this.t6,
    required this.ditahan,
    required this.terdakwa,
    required this.jaksaId,
    required this.asalPerkara,
    required this.pasal,
    required this.statusBarangBukti,
  });

  final ObjectId id;
  final String pdm;
  final String t7;
  final String t6;
  final String ditahan;
  final List<String> terdakwa;
  final ObjectId jaksaId;
  final String asalPerkara;
  final String pasal;
  final StatusBarangBukti statusBarangBukti;

  Map<String, dynamic> toMongoMap() {
    var result = {
      '_id': id,
      'pdm': pdm,
      't7': t7,
      't6': t6,
      'ditahan': ditahan,
      'terdakwa': terdakwa,
      'jaksaId': jaksaId,
      'asalPerkara': asalPerkara,
      'pasal': pasal,
      'statusBarangBukti': statusBarangBukti.value,
    };

    debugPrint("Perkara.toMongoMap $result");

    return result;
  }

  static Future<Perkara?> fromMongoMap(Map<String, dynamic> map) async {
    try {
      var result = Perkara(
        id: map["_id"]!,
        pdm: map['pdm']!,
        t7: map['t7']!,
        t6: map['t6']!,
        ditahan: map['ditahan']!,
        terdakwa: List.from(map['terdakwa']),
        jaksaId: map['jaksaId']!,
        asalPerkara: map['asalPerkara']!,
        pasal: map['pasal']!,
        statusBarangBukti:
            StatusBarangBukti.fromString(map['statusBarangBukti']!),
      );
      debugPrint("Perkara.fromMongoMap: ${result.toMongoMap()}");
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<List<Perkara>> getAllFromJaksaId(ObjectId jaksaId) async {
    var docs = await perkaraColl.find(where.eq('jaksaId', jaksaId)).toList();

    var result = await docs.map((e) => Perkara.fromMongoMap(e)).toList().wait;
    var filtered = result.nonNulls.toList();

    debugPrint(
        "Perkara.getAllFromJaksaId: $jaksaId ${docs.length} $docs, $result, $filtered");

    return filtered;
  }

  static Future<Perkara?> create({
    required String pdm,
    required String t7,
    required String t6,
    required String ditahan,
    required List<String> terdakwa,
    required ObjectId jaksaId,
    required String asalPerkara,
    required String pasal,
    required StatusBarangBukti statusBarangBukti,
  }) async {
    var data = {
      'pdm': pdm,
      't7': t7,
      't6': t6,
      'ditahan': ditahan,
      'terdakwa': terdakwa,
      'jaksaId': jaksaId,
      'asalPerkara': asalPerkara,
      'pasal': pasal,
      'statusBarangBukti': statusBarangBukti.value,
    };

    var doc = await perkaraColl.insertOne(data);
    if (doc.document != null) {
      var document = doc.document!;
      return Perkara.fromMongoMap(document);
    }

    debugPrint("Perkara.create: $data, $doc");
    return null;
  }

  String parseTerdakwaCS() {
    assert(terdakwa.isNotEmpty, "jumlah terdakwa kurang dari 1");
    var result = terdakwa.first;
    if (terdakwa.length > 1) result += " CS";
    return result;
  }
}
