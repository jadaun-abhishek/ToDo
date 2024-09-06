import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/DbHelper/DbHelper.dart';
import 'package:todo/screens/Home.dart';
import 'package:todo/screens/onBoarding/onBoardingView.dart';
import 'package:todo/service/themeService.dart';
import 'Themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Onboarding screen preferences set
  final prefs = await SharedPreferences.getInstance();
  final onboarding = prefs.getBool("onboarding") ?? false;

  await DbHelper.init();
  await GetStorage.init();
  runApp(ToDo(
    onboarding: onboarding,
  ));
}

class ToDo extends StatelessWidget {
  final bool onboarding;
  const ToDo({super.key, this.onboarding = false});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ToDo - Organise your Tasks!',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: onboarding ? const Home() : const OnboardingView(),
    );
  }
}
