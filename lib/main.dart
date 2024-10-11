import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxtask/model/user_model.dart';
import 'package:rxtask/utils/app_prefs.dart';
import 'package:rxtask/service/hive_service.dart';
import 'package:rxtask/utils/app_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Hive.initFlutter();
  } else {
    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);
  }

  Hive.registerAdapter(UserModelAdapter());

  await HiveService().initHive();
  await AppPrefs().initSharedPrefs();

  // await HiveService().clearAllUser();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      HiveService().closeBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RxTask',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Colors.blue.shade800), //2871e9
        useMaterial3: true,
      ),
      // home: const LoginScreen(),
      getPages: AppPages.pages,
      initialRoute: AppPrefs.getValue(key: "isLogin") == true
          ? AppRoutes.home
          : AppRoutes.login,
    );
  }
}
