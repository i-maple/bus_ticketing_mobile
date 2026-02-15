class TripSearchCriteria {
  const TripSearchCriteria({
    required this.departureCity,
    required this.destinationCity,
    required this.date,
  });

  final String departureCity;
  final String destinationCity;
  final DateTime date;
}
