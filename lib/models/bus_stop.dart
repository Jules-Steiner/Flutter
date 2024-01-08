class BusStop {
  final String stopId;
  final String stopCode;
  final String stopName;
  final double stopLat;
  final double stopLon;
  final int locationType;
  final String stopTimezone;
  final int wheelchairBoarding;
  final int tripA;
  final int tripB;
  final int tripC;

  BusStop({
    required this.stopId,
    required this.stopCode,
    required this.stopName,
    required this.stopLat,
    required this.stopLon,
    required this.locationType,
    required this.stopTimezone,
    required this.wheelchairBoarding,
    required this.tripA,
    required this.tripB,
    required this.tripC,
  });
}
