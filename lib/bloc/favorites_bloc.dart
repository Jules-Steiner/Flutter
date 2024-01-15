import 'dart:async';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc {
  // StreamController pour gérer les changements dans la liste des favoris
  final _favoritesController = BehaviorSubject<List<String>>();
  List<String> _favorites = [];

  // Exposer un stream pour écouter les changements dans les favoris
  Stream<List<String>> get favoritesStream => _favoritesController.stream;

  // Méthode pour ajouter ou supprimer un arrêt des favoris
  void toggleFavorite(String stopCode) {
    if (_favorites.contains(stopCode)) {
      _favorites.remove(stopCode);
    } else {
      _favorites.add(stopCode);
    }
    // Ajouter la liste mise à jour à la stream
    _favoritesController.add(_favorites);
  }

  // Dispose du BLoC pour éviter les fuites de mémoire
  void dispose() {
    _favoritesController.close();
  }

  bool isFavorite(String stopCode) {
    // Implement the logic to check if the stop is a favorite
    return _favorites.contains(stopCode);
  }
}

// Instance unique du BLoC pour être partagée dans toute l'application
final favoritesBloc = FavoritesBloc();
