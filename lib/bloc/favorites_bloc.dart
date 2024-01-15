import 'dart:async';
import 'package:rxdart/rxdart.dart';

class FavoritesBloc {
  final _favoritesController = BehaviorSubject<List<String>>();
  List<String> _favorites = [];

  Stream<List<String>> get favoritesStream => _favoritesController.stream;

  void toggleFavorite(String stopCode) {
    if (_favorites.contains(stopCode)) {
      _favorites.remove(stopCode);
    } else {
      _favorites.add(stopCode);
    }
    _favoritesController.add(_favorites);
  }

  void dispose() {
    _favoritesController.close();
  }

  bool isFavorite(String stopCode) {
    return _favorites.contains(stopCode);
  }
}

final favoritesBloc = FavoritesBloc();
