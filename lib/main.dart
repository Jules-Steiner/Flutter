import 'package:flutter/material.dart';
import 'package:projet_flutter_tram/router.dart';


void main() {
  // Pour pouvoir utiliser les SharePreferences avant le runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votre Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Note: "useMaterial3" property was removed in recent versions
        // useMaterial3: true,
      ),
      routes: AppRouter.routes,
      initialRoute: AppRouter.stopsListPage,
    );
  }
}
