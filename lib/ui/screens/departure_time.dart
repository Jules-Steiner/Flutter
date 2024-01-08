import 'package:flutter/material.dart';

class DepartureTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupérer les arguments passés depuis la page précédente
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String stopName = args['name'] as String; // Récupérer le nom de l'arrêt

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Center(
        child: Text('Arrêt sélectionné : $stopName'), // Afficher le nom de l'arrêt
      ),
    );
  }
}
