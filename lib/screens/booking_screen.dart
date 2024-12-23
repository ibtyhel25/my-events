import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  final Event event;
  final String userId; // Assuming userId is passed to the screen

  BookingScreen({required this.event, required this.userId});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();
  bool _isLoading = false;
  String _message = '';

  // Method to handle booking event
  Future<void> _bookEvent() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      final success = await _bookingService.bookEvent(widget.event.id, widget.userId); // Pass both eventId and userId
      setState(() {
        _isLoading = false;
        _message = success as bool
            ? 'Booking successful!'
            : 'Booking failed. Try again.';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book Event')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying event details (title, description, and date)
            Text(
              widget.event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat('yyyy-MM-dd – kk:mm').format(widget.event.date),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              widget.event.description,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 40),

            // Button to confirm booking
            _isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator while booking
                : ElevatedButton(
              onPressed: _bookEvent,
              child: Text('Confirm Booking'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            // Display booking message (success/failure)
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message == 'Booking successful!' ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
