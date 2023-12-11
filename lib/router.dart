import 'package:projet_flutter_tram/ui/screens/departure%20_time.dart';
import 'package:projet_flutter_tram/ui/screens/map.dart';
import 'package:projet_flutter_tram/ui/screens/stops_list.dart';

class AppRouter {
  static const String mapPage = '/map';
  static const String departureTimesPage = '/departure_times';
  static const String stopsListPage = '/stops_list';

  static final routes = {
    mapPage: (context) =>  Map(),
    departureTimesPage: (context) =>  DepartureTimes(),
    stopsListPage: (context) =>  StopsList(),
  };
}