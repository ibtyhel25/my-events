import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'create_event_screen.dart';
import 'event_details_screen.dart';
import 'my_events_screen.dart';
import 'bookings_screen.dart'; // Screen for booked events
import '../services/event_service.dart';
import '../models/event.dart';
import 'profile_view_screen.dart'; // Import the profile screen

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventService _eventService = EventService();
  bool _isLoading = true;
  int _selectedIndex = 0; // Index for selected tab

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events initially
  }

  // Method to load events
  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _eventService.getEvents();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navbar screens
  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0: // All Events
        return _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildEventList();
      case 1: // My Events
        return MyEventsScreen(
          userId: widget.userId,
          refreshEvents: _loadEvents, // Pass the callback here
        );
      case 2: // Bookings
        return BookingsScreen(userId: widget.userId);
      default:
        return Center(child: Text('Invalid Tab'));
    }
  }

  // Method to build event list
  Widget _buildEventList() {
    return FutureBuilder<List<Event>>(
      future: _eventService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];

        return events.isEmpty
            ? Center(child: Text('No events available'))
            : ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(event.description),
                  trailing: IconButton(
                    icon: Icon(Icons.bookmark_add_rounded),
                    color: Colors.blueAccent,
                    onPressed: () {
                      // Navigate to BookingScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingScreen(
                            event: event,
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailsScreen(
                        event: event,
                        userId: widget.userId,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Handle navbar tap
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management'),
        centerTitle: true,
        elevation: 10,
        backgroundColor: Colors.deepPurple,
        actions: [
          // Profile icon in the top right corner
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to ProfileScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileViewScreen(), // Pass userId to ProfileScreen
                ),
              );
            },
          ),
        ],
      ),
      body: _buildScreen(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEventScreen(userId: widget.userId),
            ),
          ).then((_) {
            _loadEvents(); // Reload events after creation
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
        elevation: 10,
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'All Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books),
            label: 'My Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
        ],
      ),
    );
  }
}
