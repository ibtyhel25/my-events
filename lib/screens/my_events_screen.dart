import 'package:flutter/material.dart';
import 'update_event_screen.dart';
import '../services/event_service.dart';
import '../models/event.dart';

class MyEventsScreen extends StatefulWidget {
  final String userId;
  final Function refreshEvents; // Added callback to refresh events after an update or deletion

  MyEventsScreen({required this.userId, required this.refreshEvents});

  @override
  _MyEventsScreenState createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Future<List<Event>> _userEventsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserEvents(); // Initialize the events list
  }

  // Method to load the user's events
  void _loadUserEvents() {
    _userEventsFuture = EventService().getUserEvents(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _userEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return Center(child: Text('No events available.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(event.title),
                  subtitle: Text('Event date: ${_formatDate(event.date)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final updatedEvent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UpdateEventScreen(
                                userId: widget.userId,
                                event: event,
                              ),
                            ),
                          );

                          // If the event was updated, refresh the event list
                          if (updatedEvent != null) {
                            _loadUserEvents(); // Reload events after update
                            widget.refreshEvents(); // Call callback to refresh events
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteEvent(context, event);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  void _deleteEvent(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await EventService().deleteEvent(event.id);
                  Navigator.of(context).pop();
                  _loadUserEvents(); // Reload events after deletion
                  widget.refreshEvents(); // Call callback to refresh events
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Event deleted successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting event: $e')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
