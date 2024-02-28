import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  String server = "https://pidum-knkg.vercel.app";

  JPU? auth;

  Future<List<BelumLimpah>> fetchBelumLimpah() async {
    var listJaksa = await fetchJPU();
    var res = await http
        .post(Uri.parse('$server/perkara/list'), body: {"secret": "pidum_gg"});
    try {} catch (e) {}
    var json = jsonDecode(res.body);
    var list = List<Map<String, dynamic>>.from(json["listBelumLimpah"]);
    var listBelumLimpah = list
        .map((e) {
          return BelumLimpah.fromJson(e, listJaksa);
        })
        .nonNulls
        .toList();

    return listBelumLimpah;
  }

  Future<List<JPU>> fetchJPU() async {
    var res = await http.get(Uri.parse('$server/jaksa/list'));
    var json = jsonDecode(res.body);
    var list = List<Map<String, dynamic>>.from(json["listJaksa"]);
    var listJPU = list
        .map((e) {
          return JPU.fromJson(e);
        })
        .nonNulls
        .toList();

    return listJPU;
  }

  Future<JPU?> getJPU({
    required String id,
    required String password,
  }) async {
    var res = await http.post(
      Uri.parse('$server/auth'),
      body: {
        'secret': 'pidum_gg',
        'id': id,
        'password': password,
      },
    );
    var json = jsonDecode(res.body);
    if (json['user'] == null) return null;
    var jpu = JPU.fromJson(json['user']);
    return jpu;
  }
}

class Tahap {
  const Tahap({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;

  factory Tahap.fromMap(Map<String, String> map) {
    var start = map['start'];
    var end = map['end'];
    if (start == null || end == null) {
      throw Exception("Failed To Parse $start $end");
    }
    var startDate = DateTime.parse(start);
    var endDate = DateTime.parse(end);
    startDate = DateTime(startDate.year, startDate.month, startDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);
    return Tahap(
      start: startDate,
      end: endDate,
    );
  }
}

enum CabangJPU {
  kejari,
  kejati;
}

class JPU {
  const JPU({
    required this.id,
    required this.nama,
    required this.cabang,
  });

  final String id;
  final String nama;
  final CabangJPU? cabang;

  @override
  String toString() {
    return """JPU: {
  nama: $nama,
  cabang: $cabang
}""";
  }

  static JPU? fromJson(Map<String, dynamic> json) {
    var id = json['id'] as String?;
    var nama = json['nama'] as String?;
    var cabang = json['cabang'] as String?;

    if (id == null || nama == null || cabang == null) return null;

    return JPU(
      id: id,
      nama: nama,
      cabang: switch (cabang.toLowerCase()) {
        'kejari' => CabangJPU.kejari,
        'kejati' => CabangJPU.kejati,
        _ => null,
      },
    );
  }
}

enum StatusBarangBukti {
  ada,
  dititip,
  tidakAda;
}

class BelumLimpah {
  const BelumLimpah({
    required this.pdm,
    required this.t7,
    required this.t6,
    required this.ditahan,
    required this.terdakwa,
    required this.jpu,
    required this.asalPerkara,
    required this.pasal,
    required this.statusBarangBukti,
  });

  final String pdm;
  final Tahap t7;
  final Tahap? t6;
  final String ditahan;
  final String terdakwa;
  final List<JPU> jpu;
  final String asalPerkara;
  final String pasal;
  final String statusBarangBukti;

  @override
  String toString() {
    return """BelumLimpah: {
  pdm: $pdm,
  t7: $t7,
  t6: $t6,
  ditahan: $ditahan,
  terdakwa: $terdakwa,
  jpu: $jpu,
  asalPerkara: $asalPerkara,
  pasal: $pasal,
  statusBarangBukti: $statusBarangBukti,
}\n""";
  }

  static BelumLimpah? fromJson(Map<String, dynamic> json, List<JPU> listJPU) {
    try {
      var pdm = json['pdm'] as String;
      var t7 = json['t7'] as Map<String, dynamic>;
      var t6 = json['t6'] as Map<String, dynamic>?;
      var ditahan = json['ditahan'] as String;
      var terdakwa = json['terdakwa'] as String;
      var jpu = List<Map<String, dynamic>>.from(json['jpu'])
          .map((e) => JPU.fromJson(e))
          .nonNulls
          .toList();
      var asalPerkara = json['asalPerkara'] as String;
      var pasal = json['pasal'] as String?;
      var statusBarangBukti = json['barangBukti'];
      var e = BelumLimpah(
        pdm: pdm,
        t7: Tahap.fromMap(t7.cast()),
        t6: t6 == null ? null : Tahap.fromMap(t6.cast()),
        ditahan: ditahan,
        terdakwa: terdakwa,
        jpu: jpu,
        asalPerkara: asalPerkara,
        pasal: pasal ?? "-",
        statusBarangBukti: statusBarangBukti,
      );
      return e;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }
}
