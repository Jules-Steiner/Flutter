import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:projet_flutter_tram/models/bus_stop.dart';

class BusStopRepository {
  Future<Map<String, List<BusStop>>> loadBusStops(String filePath) async {
  try {
    String csvString = await rootBundle.loadString(filePath);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);
    Map<String, List<BusStop>> busStopsMap = {};

    for (List<dynamic> row in csvTable.skip(1)) {
      try {
        BusStop busStop = BusStop(
          stopId: row[0].toString(),
          stopCode: row[1].toString(),
          stopName: row[2].toString(),
          stopLat: double.parse(row[3].toString()),
          stopLon: double.parse(row[4].toString()),
          locationType: int.parse(row[5].toString()),
          stopTimezone: row[6].toString(),
          wheelchairBoarding: int.parse(row[7].toString()),
          tripA: int.parse(row[8].toString()),
          tripB: int.parse(row[9].toString()),
          tripC: int.parse(row[10].toString()),
        );

        for (int i = 8; i <= 10; i++) {
          String lineKey = String.fromCharCode(65 + i - 8);
          if (busStopsMap[lineKey] == null) {
            busStopsMap[lineKey] = [];
          }
          if(row.length > i && int.parse(row[i].toString()) > -1) {
            String stopName = busStop.stopName;
            print('Ligne $lineKey, arret $stopName');
            busStopsMap[lineKey]!.add(busStop);
          }
        }
      } catch (e) {
        print('Erreur lors de la conversion : $e');
        print('Ligne CSV problématique : $row');
      }
    }
    busStopsMap['A']?.sort((a, b) => a.tripA.compareTo(b.tripA));
    busStopsMap['B']?.sort((a, b) => a.tripB.compareTo(b.tripB));
    busStopsMap['C']?.sort((a, b) => a.tripC.compareTo(b.tripC));

    return busStopsMap;
  } catch (e) {
    print('Erreur lors du chargement des arrêts de bus : $e');
    throw e;
  }
  }
}