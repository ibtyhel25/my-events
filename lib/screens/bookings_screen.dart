import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/booking_service.dart';

class BookingsScreen extends StatefulWidget {
  final String userId;

  BookingsScreen({required this.userId});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final BookingService _bookingService = BookingService();
  List<Event> _bookedEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookedEvents();
  }

  // Load booked events for the user
  Future<void> _loadBookedEvents() async {
    try {
      final bookedEvents = await _bookingService.getUserEvents(widget.userId);
      setState(() {
        _bookedEvents = bookedEvents.cast<Event>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookings: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookedEvents.isEmpty
          ? Center(child: Text('No bookings found'))
          : ListView.builder(
        itemCount: _bookedEvents.length,
        itemBuilder: (context, index) {
          final event = _bookedEvents[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                title: Text(event.title, style: TextStyle(fontSize: 18)),
                subtitle: Text(event.description),
                trailing: Text(
                  'Date: ${event.date}',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
