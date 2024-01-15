import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:projet_flutter_tram/router.dart';
import '../../repositories/bus_stop_repository.dart';
import 'package:projet_flutter_tram/models/bus_stop.dart';

class AngersMap extends StatefulWidget {
  const AngersMap({Key? key}) : super(key: key);

  @override
  State<AngersMap> createState() => _AngersMapState();
}

class _AngersMapState extends State<AngersMap> {
  late BusStopRepository busStopRepository;

  @override
  void initState() {
    super.initState();
    busStopRepository = BusStopRepository();
  }

  void _onItemTapped(int index) {
    setState(() {
      // Votre logique pour le changement d'état ici
    });
  }

  void _onMarkerTap(BuildContext context, String name) {
    Navigator.of(context).pushNamed(
      AppRouter.departureTimesPage,
      arguments: {'name': name},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte'),
        // Vous pouvez ajouter des actions, des icônes ou d'autres éléments à l'app bar ici
      ),
      body: FutureBuilder(
          future: busStopRepository.loadBusStops('assets/stops.csv'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('Aucune donnée disponible');
            } else {
              Map<String, List<BusStop>> busStopsMap = snapshot.data!;

              return FlutterMap(
                options: MapOptions(
                  center: LatLng(47.478419, -0.563166),
                  zoom: 14.2,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayerOptions(
                    markers: [
                      for (final entry in busStopsMap.entries)
                        ...entry.value.map((busStop) => Marker(
                          width: 150.0,
                          height: 80.0,
                          point: LatLng(
                            busStop.stopLat,
                            busStop.stopLon,
                          ),
                          builder: (ctx) => GestureDetector(
                            onTap: () {
                              _onMarkerTap(context, busStop.stopName);
                            },
                            child: Container(
                              width: 80.0,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Colors.red, // Utilisation d'une seule couleur ici, vous pouvez adapter selon vos besoins
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
                                        busStop.stopName,
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
                        )),
                    ],
                  ),

                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRouter.stopsListPage);
        },
        child: Icon(Icons.list),
        // Vous pouvez ajouter un label ou un tooltip au floating button si nécessaire
      ),
    );
  }
}
