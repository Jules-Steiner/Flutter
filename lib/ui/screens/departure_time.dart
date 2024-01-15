import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_flutter_tram/models/bus_stop.dart';
import 'package:xml/xml.dart';
import '../../bloc/favorites_bloc.dart';

class DepartureTime extends StatefulWidget {
  const DepartureTime({super.key});

  @override
  _DepartureTimeState createState() => _DepartureTimeState();
}

class _DepartureTimeState extends State<DepartureTime> {
  List<String> departureTimesList = [];
  bool isButtonEnabled = true;
  String currentBusStop = "";
  bool isFavorite = false;

  Future<void> fetchDepartureTimes(BusStop busStop) async {
    if(busStop.stopId != "1AARD") {
      if (isButtonEnabled) {
        currentBusStop = '2${busStop.stopId.substring(1)}';
      } else {
        currentBusStop = '1${busStop.stopId.substring(1)}';
      }
    }

    var headers = {
      'Content-Type': 'application/xml',
    };
    var request = http.Request('POST', Uri.parse('https://ara-api.enroute.mobi/irigo/siri'));
    request.body = '''
<?xml version="1.0" encoding="UTF-8"?>
<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Header />
    <S:Body>
        <sw:GetStopMonitoring xmlns:sw="http://wsdl.siri.org.uk" xmlns:siri="http://www.siri.org.uk/siri">
            <ServiceRequestInfo>
				<siri:RequestTimestamp></siri:RequestTimestamp>
				<siri:RequestorRef>opendata</siri:RequestorRef>
				<siri:MessageIdentifier>Test:Message::cedea420-95c1-4f48-9208-03709254b9b4:LOC</siri:MessageIdentifier>
			</ServiceRequestInfo>
            <Request version="2.0:FR-IDF-2.4">
                <siri:RequestTimestamp></siri:RequestTimestamp>
                <siri:MessageIdentifier>Test:Message::1c9d068d-fad2-4b71-a20a-7716195fc6f6:LOC</siri:MessageIdentifier>
                <siri:MonitoringRef>$currentBusStop</siri:MonitoringRef>
                <siri:StopVisitTypes>all</siri:StopVisitTypes>
            </Request>
            <RequestExtension />
        </sw:GetStopMonitoring>
    </S:Body>
</S:Envelope>
      ''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final xmlDocument = XmlDocument.parse(responseBody);

      final List<String> departureTimes = [];
      final monitoredVisits = xmlDocument.findAllElements('siri:MonitoredStopVisit');
      
      for (var visit in monitoredVisits) {
        var vehicleJourney = visit.findElements('siri:MonitoredVehicleJourney').first;
        var monitoredCall = vehicleJourney.findElements('siri:MonitoredCall').first;
        var lineRef = vehicleJourney.findElements('siri:LineRef').first.text;
        var destinationDisplay = monitoredCall.findElements('siri:DestinationDisplay').first.text;
        var expectedArrivalTime = monitoredCall.findElements('siri:ExpectedArrivalTime').first.text;

        if (expectedArrivalTime.isNotEmpty) {
          DateTime arrivalDateTime = DateTime.parse(expectedArrivalTime);
          DateTime now = DateTime.now();
          
          int minutesRemaining = arrivalDateTime.difference(now).inMinutes;
          String formattedTime = "${arrivalDateTime.hour}:${arrivalDateTime.minute}:${arrivalDateTime.second}";
          
          String lineAndDestination = "Ligne $lineRef - Destination $destinationDisplay";

          departureTimes.add("$formattedTime - $minutesRemaining min - $lineAndDestination");
        }
      }

      setState(() {
        departureTimesList = departureTimes;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  void toggleButtonText() {
    setState(() {
      isButtonEnabled = !isButtonEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final BusStop busStop = args['busStop'];

    // Remove this line from the build method
    // bool isFavorite = false;

    favoritesBloc.favoritesStream.listen((List<String> favorites) {
      setState(() {
        isFavorite = favorites.contains(busStop.stopCode);
        print(isFavorite);
      });
    });

    fetchDepartureTimes(busStop);

    return Scaffold(
      appBar: AppBar(
        title: Text(busStop.stopName),
        actions: [
          // IconButton for the "Add to Favorites" button with a filled or outlined star
          IconButton(
            icon: isFavorite ? const Icon(Icons.star) : const Icon(Icons.star_border),
            onPressed: () {
              // Call the BLoC function to add/remove from favorites
              favoritesBloc.toggleFavorite(busStop.stopCode); // Use the unique identifier of the stop
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: toggleButtonText,
            child: const Text("Changer de destination"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: departureTimesList.length,
              itemBuilder: (context, index) {
                List<String> parts = departureTimesList[index].split(' - ');
                String formattedTime = parts[0];
                String minutesRemaining = parts[1];
                String line = parts[2];
                String destination = parts[3];

                return ListTile(
                  title: Text("$line - Dans $minutesRemaining"),
                  subtitle: Text("$formattedTime - $destination"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}