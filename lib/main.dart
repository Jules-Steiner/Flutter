import 'package:flutter/material.dart';
import 'package:projet_flutter_tram/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Votre Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: AppRouter.routes,
      initialRoute: AppRouter.stopsListPage, 
    );
  }
}
