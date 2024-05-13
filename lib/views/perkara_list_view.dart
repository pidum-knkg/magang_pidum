import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:magang_pidum/services/api_service.dart';
import 'package:magang_pidum/services/services.dart';
import 'package:magang_pidum/utils.dart';
import 'package:magang_pidum/views/perkara_view.dart';

class PerkaraListView extends StatefulWidget {
  const PerkaraListView({
    super.key,
    required this.jaksa,
  });

  final JPU jaksa;

  @override
  State<PerkaraListView> createState() => _PerkaraListViewState();
}

class _PerkaraListViewState extends State<PerkaraListView> {
  List<BelumLimpah>? _listBelumLimpah;
  final ApiService _apiService = locator();

  @override
  void initState() {
    super.initState();
    _apiService.fetchBelumLimpah().then((value) {
      if (mounted) {
        setState(() {
          _listBelumLimpah = value.where((element) => element.jpu.map((e) => e.nama).contains(widget.jaksa.nama)).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Perkara"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_listBelumLimpah == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Gap(10),
            Text(
              "Loading",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    if (_listBelumLimpah?.isEmpty ?? true) {
      return const Center(
        child: Text("Kosong"),
      );
    }

    return ListView(
      children: [
        for (var i = 0; i < (_listBelumLimpah?.length ?? 0); i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Material(
              elevation: 5,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.black54,
              child: ListTile(
                onTap: () {
                  gotoPage(PerkaraView(belumLimpah: _listBelumLimpah![i]), context);
                },
                title: Text(
                  _listBelumLimpah![i].terdakwa,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(parseTahapRange(_listBelumLimpah![i].t6 ?? _listBelumLimpah![i].t7)),
                // leading: Text(
                //   "${i + 1}",
                //   style: const TextStyle(fontSize: 18),
                // ),
                trailing: Text(_listBelumLimpah![i].pdm),
              ),
            ),
          )
      ],
    );
  }
}

String parseTahapRange(Tahap tahap) {
  var now = DateTime.now();
  var end = DateTime(tahap.end.year, tahap.end.month, tahap.end.day);
  now = DateTime(now.year, now.month, now.day);
  var dif = end.difference(now).inDays;
  if (dif > 0) {
    return "$dif Hari Lagi Penahanan Habis";
  } else if (dif < 0) {
    return "Penahanan ${dif.abs()} Hari Yang Lalu";
  } else {
    return "Penahanan Hari Ini";
  }
}
