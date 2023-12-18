import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_tram/router.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMarkerTap(BuildContext context, String name) {
    Navigator.of(context).pushNamed(AppRouter.departureTimesPage);
    // You can also pass data to DepartureTime screen if needed
    // Navigator.pushNamed(context, '/departure_times', arguments: {'name': name});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(47.478419, -0.563166),
          zoom: 14.2,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayerOptions(
            markers: [
              for (final location in [
                {'name': 'Eseo', 'lat': 47.478419, 'lng': -0.563166, 'color': Colors.red},
                {'name': 'Exemple 2', 'lat': 47.4725, 'lng': -0.5541, 'color': Colors.blue},
                {'name': 'Exemple 3', 'lat': 47.4707, 'lng': -0.5534, 'color': Colors.green},
                // Ajoutez autant d'emplacements que nécessaire avec leurs coordonnées et couleurs respectives
              ])
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(location['lat']! as double, location['lng']! as double),
                  builder: (ctx) => GestureDetector(
                    onTap: () {
                      _onMarkerTap(context, location['name']! as String);
                    },
                    child: Container(
                      width: 80.0, // Définir la largeur pour aligner les marqueurs horizontalement
                      child: Stack(
                        alignment: Alignment.center, // Aligner les éléments au centre horizontalement
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: location['color']! as Color?,
                            size: 40.0,
                          ),
                          Positioned(
                            top: 45,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                location['name']! as String,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
