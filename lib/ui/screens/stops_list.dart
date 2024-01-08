import 'package:flutter/material.dart';
import 'package:projet_flutter_tram/models/bus_stop.dart';
import 'package:projet_flutter_tram/repositories/bus_stop_repository.dart';
import 'package:projet_flutter_tram/router.dart';

class StopsList extends StatefulWidget {
  @override
  _StopsListState createState() => _StopsListState(); // Correction du nom de la classe d'état
}

class _StopsListState extends State<StopsList> {
  late BusStopRepository busStopRepository;
  String selectedLine = 'A';
  
  @override
  void initState() {
    super.initState();
    busStopRepository = BusStopRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des arrêts'),
      ),
      body: FutureBuilder<Map<String, List<BusStop>>>(
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
            
            // Utiliser le menu déroulant
            return Column(
              children: [
                DropdownButton<String>(
                  hint: Text('Sélectionner une ligne'),
                  value: selectedLine,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLine = newValue!;
                    });
                  },
                  items: busStopsMap.keys.map((String line) {
                    return DropdownMenuItem<String>(
                      value: line,
                      child: Text('Ligne $line'),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: busStopsMap[selectedLine]?.length ?? 0,
                    itemBuilder: (context, index) {
                      BusStop busStop = busStopsMap[selectedLine]![index];
                      return ListTile(
                        title: Text(busStop.stopName),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            AppRouter.departureTimesPage,
                            arguments: {'busStop': busStop},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
