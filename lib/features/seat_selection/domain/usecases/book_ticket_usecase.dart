import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/seat_selection_repository.dart';

class BookTicketUseCase implements UseCase<void, BookTicketParams> {
  const BookTicketUseCase(this._repository);

  final SeatSelectionRepository _repository;

  @override
  Future<Either<Failure, void>> call(BookTicketParams params) {
    return _repository.bookTicket(params);
  }
}

class BookTicketParams {
  const BookTicketParams({
    required this.busId,
    required this.vehicleName,
    required this.selectedSeats,
    required this.totalPrice,
    required this.bookedAt,
    this.departureCity,
    this.destinationCity,
  });

  final String busId;
  final String vehicleName;
  final List<String> selectedSeats;
  final int totalPrice;
  final DateTime bookedAt;
  final String? departureCity;
  final String? destinationCity;

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'vehicleName': vehicleName,
      'selectedSeats': selectedSeats,
      'totalPrice': totalPrice,
      'bookedAt': bookedAt.toIso8601String(),
      'departureCity': departureCity,
      'destinationCity': destinationCity,
    };
  }
}
