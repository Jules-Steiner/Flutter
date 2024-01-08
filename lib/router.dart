import 'package:projet_flutter_tram/ui/screens/departure_time.dart';
import 'package:projet_flutter_tram/ui/screens/angers_map.dart';
import 'package:projet_flutter_tram/ui/screens/stops_list.dart';

class AppRouter {
  static const String mapPage = '/map';
  static const String departureTimesPage = '/departure_times';
  static const String stopsListPage = '/stops_list';

  static final routes = {
    mapPage: (context) =>  const AngersMap(),
    departureTimesPage: (context) =>  DepartureTime(),
    stopsListPage: (context) =>  StopsList(),
  };
}
