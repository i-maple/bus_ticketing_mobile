enum BookingPaymentStatus { pending, booked, cancelled }

extension BookingPaymentStatusX on BookingPaymentStatus {
  String get value => switch (this) {
    BookingPaymentStatus.pending => 'pending',
    BookingPaymentStatus.booked => 'booked',
    BookingPaymentStatus.cancelled => 'cancelled',
  };

  static BookingPaymentStatus fromKhaltiStatus(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'completed' ||
        normalized == 'paid' ||
        normalized == 'success') {
      return BookingPaymentStatus.booked;
    }

    if (normalized == 'user canceled' ||
        normalized == 'cancelled' ||
        normalized == 'canceled' ||
        normalized == 'expired' ||
        normalized == 'refunded' ||
        normalized == 'failed') {
      return BookingPaymentStatus.cancelled;
    }

    return BookingPaymentStatus.pending;
  }

  static BookingPaymentStatus fromKhaltiLookup({
    required String status,
    String? transactionId,
    bool? refunded,
  }) {
    final mappedFromStatus = fromKhaltiStatus(status);
    if (mappedFromStatus == BookingPaymentStatus.cancelled) {
      return BookingPaymentStatus.cancelled;
    }

    if (refunded == true) {
      return BookingPaymentStatus.cancelled;
    }

    if ((transactionId ?? '').trim().isNotEmpty) {
      return BookingPaymentStatus.booked;
    }

    return mappedFromStatus;
  }

  static BookingPaymentStatus fromValue(String value) {
    return switch (value.trim().toLowerCase()) {
      'booked' => BookingPaymentStatus.booked,
      'cancelled' => BookingPaymentStatus.cancelled,
      _ => BookingPaymentStatus.pending,
    };
  }
}
