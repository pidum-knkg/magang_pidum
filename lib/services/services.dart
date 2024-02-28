import 'package:get_it/get_it.dart';
import 'package:magang_pidum/services/api_service.dart';
import 'package:magang_pidum/services/notif_db_services.dart';
import 'package:magang_pidum/services/notification_service.dart';

final locator = GetIt.instance;

Future setupServices() async {
  locator.registerLazySingleton(ApiService.new);
  locator.registerSingletonAsync(NotifDbServices().init);
  locator.registerSingletonAsync(NotificationService().init);
  await locator.allReady();
}
