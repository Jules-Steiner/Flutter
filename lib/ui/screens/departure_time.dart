import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_flutter_tram/models/bus_stop.dart';
import 'package:xml/xml.dart';

class DepartureTime extends StatefulWidget {
  @override
  _DepartureTimeState createState() => _DepartureTimeState();
}

class _DepartureTimeState extends State<DepartureTime> {
  List<String> departureTimesList = [];

  Future<void> fetchDepartureTimes(BusStop busStop) async {
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
                <siri:MonitoringRef>${busStop.stopId}</siri:MonitoringRef>
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
      print(responseBody);

      // Exemple: Extraire les horaires de passage des bus
      final List<String> departureTimes = [];
      final monitoredVisits = xmlDocument.findAllElements('siri:MonitoredStopVisit');
      
      for (var visit in monitoredVisits) {
        var vehicleJourney = visit.findElements('siri:MonitoredVehicleJourney').first;
        var monitoredCall = vehicleJourney.findElements('siri:MonitoredCall').first;
        var expectedArrivalTime = monitoredCall.findElements('siri:ExpectedArrivalTime').first.text;

        if (expectedArrivalTime.isNotEmpty) {
          departureTimes.add(expectedArrivalTime);
        }
      }

      setState(() {
        departureTimesList = departureTimes;
      });
    } else {
      print(response.reasonPhrase);
      // Gérez les erreurs ici
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final BusStop busStop = args['busStop'];

    // Appeler la fonction pour récupérer les données
    fetchDepartureTimes(busStop);

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Arrêt sélectionné : ${busStop.stopName}'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: departureTimesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(departureTimesList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}