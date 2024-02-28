import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:magang_pidum/pages/home_page.dart';
import 'package:magang_pidum/services/api_service.dart';
import 'package:magang_pidum/services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        _sharedPreferences = snapshot.data!;
        var id = snapshot.data!.getString('id') ?? '';
        var password = snapshot.data!.getString('password') ?? '';

        debugPrint('$id $password');

        return FlutterLogin(
          title: 'PIDUM',
          onLogin: onLogin,
          onRecoverPassword: onRecoverPassword,
          userType: LoginUserType.text,
          savedEmail: id,
          savedPassword: password,
          messages: LoginMessages(
            userHint: "id",
          ),
          userValidator: (value) {
            if (value == null || value.isEmpty) return "Required";
            return null;
          },
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> onLogin(LoginData data) async {
    JPU? jpu;
    final ApiService apiService = locator();
    try {
      jpu = await apiService.getJPU(
        id: data.name,
        password: data.password,
      );
    } catch (e) {
      return "$e";
    }
    if (jpu == null) return "User Not Found";
    apiService.auth = jpu;
    _sharedPreferences.setString('id', data.name);
    _sharedPreferences.setString('password', data.password);
    return null;
  }

  Future<String?> onRecoverPassword(String data) async {
    debugPrint(data);
    return null;
  }
}
