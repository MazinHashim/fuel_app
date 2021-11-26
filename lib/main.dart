import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:fuel_app/controller/api_services.dart';
import 'locale/locale.dart';
import 'package:fuel_app/features_page.dart';
import 'package:fuel_app/login_page.dart';
import './stationAppPages/home_page.dart';
import './splashScreen.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => APIServices());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    // configOneSignal();
  }

  // void configOneSignal() async {
  //   await OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.debug).then(
  //       (value) =>
  //           OneSignal.shared.init("ef207a9a-07d1-4cf8-a425-987f7989c1c6"));
  //   // OneSignal.shared
  //   //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      title: "Fuela App",
      theme: ThemeData(
        fontFamily: "Josefin",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        accentColor: Color.fromRGBO(18, 5, 150, 1.0),
        primaryColor: Color.fromRGBO(18, 35, 100, 1.0),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "home": (context) => Home(),
        "login": (context) => LoginPage(),
        "features": (context) => FeatPage(),
      },
    );
  }
}
