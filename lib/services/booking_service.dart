import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/event.dart'; // Import for QR Code generation

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Book an event
  Future<bool> bookEvent(String eventId, String userId) async {
    try {
      // Check if the user has already booked the event
      final existingBooking = await _db
          .collection('subscriptions')
          .where('eventId', isEqualTo: eventId)
          .where('userId', isEqualTo: userId)
          .get();

      if (existingBooking.docs.isEmpty) {
        // Create the booking object
        final booking = Booking(
          bookingId: FirebaseFirestore.instance.collection('subscriptions').doc().id,
          eventId: eventId,
          userId: userId,
          bookingDate: DateTime.now(),
          status: 'booked', // Set the initial status as booked
          qrCode: '', // Will generate QR Code after saving to Firestore
        );

        // Save the booking (subscription) to Firestore
        await _db.collection('subscriptions').doc(booking.bookingId).set(booking.toMap());

        // Generate QR code for the booking and update it in Firestore
        final qrCode = generateQRCode(booking.bookingId);
        await _db.collection('subscriptions').doc(booking.bookingId).update({
          'qrCode': qrCode,
        });

        return true; // Return true if booking was successful
      } else {
        throw Exception('User has already booked this event');
      }
    } catch (e) {
      print('Error booking event: $e');
      return false; // Return false if there was an error
    }
  }

  // Retrieve all bookings for a user
  Future<List<Event>> getUserEvents(String userId) async {
    try {
      // Fetch user bookings
      final snapshot = await _db.collection('subscriptions')
          .where('userId', isEqualTo: userId)
          .get();

      // Extract the eventId from each booking and fetch the event details
      List<Event> events = [];
      for (var doc in snapshot.docs) {
        String eventId = doc['eventId'];

        // Fetch the event details using eventId
        final eventSnapshot = await _db.collection('events').doc(eventId).get();

        if (eventSnapshot.exists) {
          // Create an Event object from the fetched data
          Event event = Event.fromMap(eventSnapshot.data()!, eventSnapshot.id);
          events.add(event);
        }
      }

      return events;
    } catch (e) {
      throw Exception('Error retrieving user events: $e');
    }
  }


  // Retrieve all bookings for an event
  Future<List<Booking>> getEventBookings(String eventId) async {
    try {
      final snapshot = await _db.collection('subscriptions').where('eventId', isEqualTo: eventId).get();
      return snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Error retrieving event bookings: $e');
    }
  }

  // Update booking status (e.g., cancelled, completed)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _db.collection('subscriptions').doc(bookingId).update({'status': status});
    } catch (e) {
      throw Exception('Error updating booking status: $e');
    }
  }

  // Delete a booking (subscription)
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _db.collection('subscriptions').doc(bookingId).delete();
    } catch (e) {
      throw Exception('Error deleting booking: $e');
    }
  }

  // Generate QR code for the booking
  String generateQRCode(String bookingId) {
    final qrCodeData = bookingId; // Use the booking ID or any other relevant info
    return qrCodeData; // Return the QR code data as string
  }
}
