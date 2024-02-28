import 'package:flutter/material.dart';
import 'package:magang_pidum/pages/home_page.dart';
import 'package:magang_pidum/pages/login_page.dart';
import 'package:magang_pidum/services/api_service.dart';
import 'package:magang_pidum/services/notification_service.dart';
import 'package:magang_pidum/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
  await setupServices();

  var notifServices = locator<NotificationService>();
  var apiServc = locator<ApiService>();
  debugPrint("main notif payload ${notifServices.onDidReceivePayload}");
  debugPrint("main notif action ${notifServices.onDidReceiveActionId}");

  var sharedPrefs = await SharedPreferences.getInstance();
  var id = sharedPrefs.getString('id');
  var password = sharedPrefs.getString('password');
  Widget? widget;

  if (id != null && password != null) {
    var jpu = await apiServc.getJPU(id: id, password: password);
    if (jpu != null) {
      apiServc.auth = jpu;
      widget = const HomePage();
    }
  }

  runApp(Main(
    widget: widget ?? const LoginPage(),
  ));
}

class Main extends StatelessWidget {
  const Main({
    super.key,
    required this.widget,
  });

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PIDUM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: widget,
    );
  }
}
