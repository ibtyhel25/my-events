import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../services/profile_service.dart';  // Import the service that includes `getNameById`

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  EventDetailsScreen({required this.event, required String userId});

  @override
  Widget build(BuildContext context) {
    final EventService eventService = EventService();
    final ProfileService profileService = ProfileService(); // Create an instance of UserService

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView for scrollable content
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event details section with title, description, date
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Description:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(event.description, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text('Date:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(event.date.toIso8601String(), style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Subscribed users section with title, count, and list
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscribed Users',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<List<String>>(
                      future: eventService.getSubscribedUsers(event.id),
                      builder: (context, usersSnapshot) {
                        if (usersSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (usersSnapshot.hasError) {
                          return Center(child: Text('Error loading users.'));
                        } else if (!usersSnapshot.hasData || usersSnapshot.data!.isEmpty) {
                          return Text('No users have subscribed to this event.');
                        } else {
                          final users = usersSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Number of users subscribed: ${users.length}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 10),
                              // Get the user names instead of the IDs
                              FutureBuilder<List<String>>(
                                future: Future.wait(users.map((userId) => profileService.getNameById(userId))),
                                builder: (context, namesSnapshot) {
                                  if (namesSnapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (namesSnapshot.hasError) {
                                    return Center(child: Text('Error loading names.'));
                                  } else if (!namesSnapshot.hasData || namesSnapshot.data!.isEmpty) {
                                    return Text('No names found.');
                                  } else {
                                    final userNames = namesSnapshot.data!;
                                    return Column(
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true, // Prevent list from expanding
                                          itemCount: userNames.length,
                                          itemBuilder: (context, index) {
                                            return Text(userNames[index], style: TextStyle(fontSize: 16));
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
