class Booking {
  String bookingId;
  String eventId;
  String userId;
  DateTime bookingDate;
  String status; // Booking status (e.g., "booked", "cancelled")
  String? qrCode; // Optional QR code for the booking

  Booking({
    required this.bookingId,
    required this.eventId,
    required this.userId,
    required this.bookingDate,
    required this.status,
    this.qrCode, // Optional parameter for QR code
  });

  // Convert the Booking object to a Map to store in Firestore or other databases
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
      'qrCode': qrCode, // Store QR code if available
    };
  }

  // Create a Booking object from a Map
  Booking.fromMap(Map<String, dynamic> map, String bookingId)
      : bookingId = bookingId,
        eventId = map['eventId'],
        userId = map['userId'],
        bookingDate = DateTime.parse(map['bookingDate']),
        status = map['status'],
        qrCode = map['qrCode'];
}
