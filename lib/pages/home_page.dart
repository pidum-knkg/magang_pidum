import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:magang_pidum/pages/login_page.dart';
import 'package:magang_pidum/services/api_service.dart';
import 'package:magang_pidum/services/notif_db_services.dart';
import 'package:magang_pidum/services/notification_service.dart';
import 'package:magang_pidum/services/services.dart';
import 'package:magang_pidum/utils.dart';
import 'package:magang_pidum/views/perkara_list_view.dart';
import 'package:magang_pidum/views/perkara_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<JPU>? _listJPU;
  final ApiService _apiService = locator();
  final NotificationService _notificationService = locator();
  StreamSubscription<String?>? sub;

  @override
  void dispose() {
    if (sub != null) sub!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var payload = _notificationService.onDidReceivePayload;

    debugPrint(payload);
    _apiService.fetchBelumLimpah().then((value) {
      sub = _notificationService.stream.listen((p) {
        if (p != null) {
          handleClickNotif(p, null, value);
        }
      });
      startNotif(value
          .where((element) =>
              element.jpu.map((e) => e.id).contains(_apiService.auth?.id))
          .toList());
      if (payload != null) {
        handleClickNotif(
          payload,
          _notificationService.onDidReceiveActionId,
          value,
        );
      }
      _apiService.fetchJPU().then((value) {
        if (mounted) {
          setState(() {
            _listJPU = value;
          });
        }
      });
    });

    if (payload == null) {
      _apiService.fetchJPU().then((value) {
        if (mounted) {
          setState(() {
            _listJPU = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_apiService.auth?.nama ?? "Pidum"),
      ),
      body: createBody(context),
      drawer: _createDrawer(),
    );
  }

  Widget createBody(BuildContext context) {
    if (_listJPU == null) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Gap(20),
            Text("Loading..."),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RefreshIndicator(
        onRefresh: () {
          return _apiService.fetchJPU().then((value) {
            if (mounted) {
              setState(() {
                _listJPU = value;
              });
            }
          });
        },
        child: ListView(
          children: [
            _searchAnchor(),
            const Gap(20),
            ElevatedButton(
              onPressed: () {
                if (_apiService.auth == null) {
                  showToast(context, 'Not Logged In');
                } else {
                  gotoPage(
                    PerkaraListView(jaksa: _apiService.auth!),
                    context,
                  );
                }
              },
              child: const Text("Jadwal Saya"),
            ),
            _listKejati(),
            _listKejari(),
          ],
        ),
      ),
    );
  }

  Drawer _createDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icon/icon.png'),
                opacity: .3,
              ),
              color: Colors.greenAccent,
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue,
                  Colors.greenAccent,
                ],
              ),
            ),
            child: Text(
              "PIDUM",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              _notificationService.notificationsPlugin.cancelAll();
              Notif.deleteWherePDMNotInList([]);
              var sharedPrefs = await SharedPreferences.getInstance();
              await sharedPrefs.clear();
              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _listKejari() {
    var listKejari = _listJPU!.where((e) => e.cabang == CabangJPU.kejari);
    var listWidget = listKejari
        .map((e) => ListTile(
              onTap: () {
                gotoPage(PerkaraListView(jaksa: e), context);
              },
              title: Text(e.nama),
            ))
        .toList();

    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      title: const Text(
        "KEJARI",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: listWidget,
    );
  }

  Widget _listKejati() {
    var listKejati = _listJPU!.where((e) => e.cabang == CabangJPU.kejati);
    var listWidget = listKejati
        .map((e) => ListTile(
              onTap: () {
                gotoPage(PerkaraListView(jaksa: e), context);
              },
              title: Text(e.nama),
            ))
        .toList();

    return ExpansionTile(
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
      ),
      title: const Text(
        "KEJATI",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: listWidget,
    );
  }

  Widget _searchAnchor() {
    return SearchAnchor(
      builder: (context, controller) => SearchBar(
        hintText: 'Cari Jaksa',
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.search),
        ),
        onTap: () {
          controller.openView();
        },
      ),
      suggestionsBuilder: (context, controller) {
        return _listJPU!
            .where((element) => element.nama
                .toLowerCase()
                .contains(controller.text.toLowerCase()))
            .map((e) => ListTile(
                  onTap: () {
                    gotoPage(PerkaraListView(jaksa: e), context);
                  },
                  title: Text(e.nama),
                ));
      },
    );
  }

  void handleClickNotif(String payload, String? actionId,
      List<BelumLimpah> listBelumLimpah) async {
    var found = listBelumLimpah.where((element) => element.pdm == payload);
    if (found.isNotEmpty) {
      var notif = await Notif.findFirstByPdm(found.first.pdm);
      debugPrint("$notif");
      if (notif != null) {
        notif.readed = 1;
        await notif.save();
      }
      if (mounted) {
        gotoPage(
          PerkaraView(belumLimpah: found.first),
          context,
        );
      }
    } else {
      _apiService.fetchJPU().then((value) {
        if (mounted) {
          setState(() {
            _listJPU = value;
          });
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not Found"),
        ),
      );
    }
  }

  void startNotif(List<BelumLimpah> listBelumLimpah) async {
    debugPrint("registering notif.size: ${listBelumLimpah.length}");
    var notifs = await Notif.getAllByPDMNotInList(
        listBelumLimpah.map((e) => e.pdm).toList());
    for (var notif in notifs) {
      _notificationService.notificationsPlugin.cancel(notif.id);
    }
    for (var belumLimpah in listBelumLimpah) {
      var notif = await Notif.findFirstByPdm(belumLimpah.pdm) ??
          await Notif.create(pdm: belumLimpah.pdm);
      debugPrint("startNotifi Notif: $notif");
      var tahap = belumLimpah.t6 ?? belumLimpah.t7;
      var date = tahap.end.subtract(
        const Duration(days: 10),
      );
      date = date.add(const Duration(hours: 8));
      if (notif.readed > 0) continue;
      if (date.isBefore(DateTime.now()..add(const Duration(days: 1)))) {
        debugPrint("notif is not readed and forgoten: $notif");
        _notificationService.show(
          id: notif.id,
          payload: belumLimpah.pdm,
          title: belumLimpah.terdakwa,
          body: parseTahapRange(belumLimpah.t6 ?? belumLimpah.t7),
        );
      } else {
        debugPrint("registering notif: ${belumLimpah.pdm}; date: $date");
        _notificationService.dateNotification(
          id: notif.id,
          title: belumLimpah.terdakwa,
          body: belumLimpah.pdm,
          payload: belumLimpah.pdm,
          date: date,
        );
      }
    }
  }
}
